//
//  AudioUnitViewController.swift
//  GainStage
//
//  Created by Amelia Murphy on 6/21/22.
//

import Foundation
import CoreAudioKit

public class GainStageViewController: AUViewController, AUAudioUnitFactory {
    
    // handle to audio unit
    public var audioUnit: GainStageAudioUnit? {
        didSet {
            self.connectViewToAU()
        }
    }
    
    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try GainStageAudioUnit(componentDescription: componentDescription, options: [])
        return audioUnit!
    }
    
    // create parameter handles
    private var gain: AUParameter!
    
    // create parameter observer
    private var parameterObserverToken: AUParameterObserverToken?
    
    // IBOutlets for controls
    
    public override init(nibName: NSNib.Name?, bundle: Bundle?) {
        // Pass a reference to the owning framework bundle.
        super.init(nibName: nibName, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        connectViewToAU()
    }
    

    private func connectViewToAU() {
        // grab reference to parameter tree
        guard let paramTree = audioUnit?.parameterTree else { return }
        
        gain = paramTree.value(forKey: "gain") as? AUParameter
    
        parameterObserverToken = paramTree.token(byAddingParameterObserver: { [weak self] address, value in
            guard self != nil else { return }
        })
        
        // sync UI with parameter state
        updateUI()
    }
    
    private func updateUI() {
        
    }
    
    @IBAction func sliderUpdated(_ sender: NSSlider) {
        //gain.value = AUValue(sender.floatValue)
        print(sender.floatValue)
    }
}

