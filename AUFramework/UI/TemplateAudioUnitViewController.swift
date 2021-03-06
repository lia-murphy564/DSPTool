//
//  AudioUnitViewController.swift
//  Template
//
//  Created by Amelia Murphy on 6/21/22.
//

import CoreAudioKit

public class TemplateAudioUnitViewController: AUViewController, AUAudioUnitFactory {
    var audioUnit: AUAudioUnit?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if audioUnit == nil {
            return
        }
        
        // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
    }
    
    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try TemplateAudioUnit(componentDescription: componentDescription, options: [])
        
        return audioUnit!
    }
    
}
