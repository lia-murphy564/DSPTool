//
//  GainStageAudioUnit.swift
//  AUFramework
//
//  Created by Amelia Murphy on 6/21/22.
//

import Foundation
import AudioUnit
import AudioToolbox
import AVFoundation
import CoreAudio

public class GainStageAudioUnit: AUAudioUnit {

    // parameter declarations
    private let gain: AUParameter

    // dsp kernel adapter
    private let kernelAdapter: GainStageDSPKernelAdapter

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
    weak var viewController: GainStageViewController?

    // input busses
    public override var inputBusses: AUAudioUnitBusArray { return inputBusArray }

    // output busses
    public override var outputBusses: AUAudioUnitBusArray { return inputBusArray }

    // can the audio unit support user presets?
    public override var supportsUserPresets: Bool {
        return false
    }

    public override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions = []) throws {
        // kernel adapter communicates with c++ dsp code
        kernelAdapter = GainStageDSPKernelAdapter()

        // declare parameters in parameterTrees
        gain = AUParameterTree.createParameter(withIdentifier: "gain",
                                                 name: "Gain",
                                                 address: 0,
                                                 min: 0,
                                                 max: 1,
                                                 unit: .linearGain,
                                                 unitName: nil,
                                                 flags: [.flag_IsReadable,.flag_IsWritable,.flag_CanRamp],
                                                 valueStrings: nil,
                                                 dependentParameters: nil)



        // init parameter values
        gain.value = 1

        // init super class
        try super.init(componentDescription: componentDescription, options: options)

        // Create the audio unit's tree of parameters.
        parameterTree = AUParameterTree.createTree(withChildren: [self.gain])

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

