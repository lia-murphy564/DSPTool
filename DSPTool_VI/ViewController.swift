//
//  ViewController.swift
//  DSPTool_VI
//
//  Created by Amelia Murphy on 6/21/22.
//

import Cocoa
import AUFramework
import AudioUnit

class ViewController: NSViewController {
    
    private var audioPlayer: AudioPlayer!
    private var pluginVC: TemplateAudioUnitViewController!
    private var gainVC: GainStageViewController!
    
    @IBOutlet weak var auContainer: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "measuringtape2", withExtension: "mp3") else {
            fatalError("can't create url from resource")
        }
        audioPlayer = AudioPlayer(url)
        addPluginView()
        connectAudioUnitWithPlayer()
        audioPlayer.play()
    }
    
    private func addPluginView() {
        let builtInPluginsURL = Bundle.main.builtInPlugInsURL
        guard let pluginURL = builtInPluginsURL?.appendingPathComponent("GainStage.appex") else {
            fatalError("cannot get plugin URL")
        }
        let appExtensionBundle = Bundle(url: pluginURL)
        
        pluginVC = TemplateAudioUnitViewController(nibName: "TemplateAudioUnitViewController", bundle: appExtensionBundle)
        gainVC = GainStageViewController(nibName: "GainStageViewController", bundle: appExtensionBundle)
        //let auView = pluginVC.view
        let auView = gainVC.view
        auView.frame = auContainer.bounds
        auContainer.addSubview(auView)
    }
    
    private func connectAudioUnitWithPlayer() {
            var componentDescription = AudioComponentDescription()
            componentDescription.componentType = kAudioUnitType_Effect
            // used https://codebeautify.org/string-hex-converter to convert strings to fourCC hex
            componentDescription.componentSubType = 0x44656d6f // "Demo"
            componentDescription.componentManufacturer = 0x44656d6f // "Demo"
            componentDescription.componentFlags = 0
            componentDescription.componentFlagsMask = 0
            
            AUAudioUnit.registerSubclass(GainStageAudioUnit.self, as: componentDescription, name: "Demo: GainStage", version: UInt32.max)
            audioPlayer.selectAudioUnitWithComponentDescription(componentDescription) {
                guard let audioUnit = self.audioPlayer.audioUnit as? GainStageAudioUnit else {
                    fatalError("playEngine.testAudioUnit nil or cast failed")
                }
                self.gainVC.audioUnit = audioUnit
            }
        }
}
