//
//  SwiftTemplateAudioUnit.swift
//  AUFramework
//
//  Created by Amelia Murphy on 6/21/22.
//

import Foundation
import AudioUnit
import AudioToolbox
import AVFoundation
import CoreAudio

fileprivate extension AUAudioUnitPreset {
    convenience init(number: Int, name: String) {
        self.init()
        self.number = number
        self.name = name
    }
}

public class TemplateAudioUnit: AUAudioUnit {

    // parameter declarations
    private let param1: AUParameter

    // parameter tree declaratiozzn
    //public let parameterTree: AUParameterTree?

    // dsp kernel adapter
    private let kernelAdapter: TemplateDSPKernelAdapter

    lazy private var inputBusArray: AUAudioUnitBusArray = {
        AUAudioUnitBusArray(audioUnit: self,
                            busType: .input,
                            busses: [kernelAdapter.inputBus])
    }()

    lazy private var outputBusArray: AUAudioUnitBusArray = {
        AUAudioUnitBusArray(audioUnit: self,
                            busType: .output,
                            busses: [kernelAdapter.outputBus])
    }()

    // owning view controller
    weak var viewController: TemplateAudioUnitViewController?

    // input busses
    public override var inputBusses: AUAudioUnitBusArray { return inputBusArray }

    // output busses
    public override var outputBusses: AUAudioUnitBusArray { return inputBusArray }


    public override var factoryPresets: [AUAudioUnitPreset] {
        return [
            AUAudioUnitPreset(number: 0, name: "Default")
        ]
    }
    /*
    private let factoryPresetValues:[(cutoff: AUValue, resonance: AUValue)] = [
        (2500.0, 5.0),    // "Prominent"
        (14_000.0, 12.0), // "Bright"
        (384.0, -3.0)     // "Warm"
    ]

    private var _currentPreset: AUAudioUnitPreset?

    public override var currentPreset: AUAudioUnitPreset? {
        get { return _currentPreset }
        set {
            // If the newValue is nil, return.
            guard let preset = newValue else {
                _currentPreset = nil
                return
            }

            // Factory presets need to always have a number >= 0.
            if preset.number >= 0 {
                let values = factoryPresetValues[preset.number]
                parameters.setParameterValues(cutoff: values.cutoff, resonance: values.resonance)
                _currentPreset = preset
            }
            // User presets are always negative.
            else {
                // Attempt to restore the archived state for this user preset.
                do {
                    fullStateForDocument = try presetState(for: preset)
                    // Set the currentPreset after successfully restoring the state.
                    _currentPreset = preset
                } catch {
                    print("Unable to restore set for preset \(preset.name)")
                }
            }
        }
    }
     */

    // can the audio unit support user presets?
    public override var supportsUserPresets: Bool {
        return true
    }

    public override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions = []) throws {
        // kernel adapter communicates with c++ dsp code
        kernelAdapter = TemplateDSPKernelAdapter()


        // declare parameters in parameterTree
        param1 = AUParameterTree.createParameter(withIdentifier: "param1",
                                                 name: "Param 1",
                                                 address: 0,
                                                 min: 0,
                                                 max: 1,
                                                 unit: .linearGain,
                                                 unitName: nil,
                                                 flags: [.flag_IsReadable,.flag_IsWritable,.flag_CanRamp],
                                                 valueStrings: nil,
                                                 dependentParameters: nil)



        // init parameter values
        param1.value = 0.5

        // init super class
        try super.init(componentDescription: componentDescription, options: options)

        // Create the audio unit's tree of parameters.
        parameterTree = AUParameterTree.createTree(withChildren: [self.param1])

        // A closure for observing all externally generated parameter value changes.
        parameterTree?.implementorValueObserver = { param, value in
            self.kernelAdapter.setParameter(param, value: value)
        }

        // A closure for returning state of the requested parameter.
        parameterTree?.implementorValueProvider = { param in
            return self.kernelAdapter.value(for: param)
        }

        // A closure for returning the string representation of the requested parameter value.
//        parameterTree?.implementorStringFromValueCallback = { param, value in
//            switch param.address {
//            case AUv3FilterParam.cutoff.rawValue:
//                return String(format: "%.f", value ?? param.value)
//            case AUv3FilterParam.resonance.rawValue:
//                return String(format: "%.2f", value ?? param.value)
//            default:
//                return "?"
//            }
//        }

        // set default preset
        currentPreset = factoryPresets.first
    }

    public override var maximumFramesToRender: AUAudioFrameCount {
        get { return kernelAdapter.maximumFramesToRender }
        set { if !renderResourcesAllocated { kernelAdapter.maximumFramesToRender = newValue }}
    }

    public override func allocateRenderResources() throws {
        if kernelAdapter.outputBus.format.channelCount != kernelAdapter.inputBus.format.channelCount {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(kAudioUnitErr_FailedInitialization), userInfo: nil)
        }
        try super.allocateRenderResources()
        kernelAdapter.allocateRenderResources()
    }

    public override func deallocateRenderResources() {
        super.deallocateRenderResources()
        kernelAdapter.deallocateRenderResources()
    }

    public override var internalRenderBlock: AUInternalRenderBlock {
        return kernelAdapter.internalRenderBlock()
    }

    // process in place? basically realtime vs non-rt
    public override var canProcessInPlace: Bool { return true }
}

