//
//  ViewController.swift
//  DSPTool_VI
//
//  Created by Amelia Murphy on 6/21/22.
//

import Foundation
import Cocoa
import AUFramework
import AudioUnit
import CoreGraphics
import AppKit
import AVFAudio

class ViewController: NSViewController {
    
    private var audioPlayer: AudioPlayer!
//    private var pluginVC: TemplateAudioUnitViewController!
    private var gainVC: GainStageViewController!
    
    private var reverbAU: AVAudioUnitReverb!
    
    @IBOutlet weak var connectionView: ConnectionView!
    
    @IBOutlet weak var auContainer: NSView!
    
    @IBOutlet weak var addEffectButton: NSButton!
    
    // array of audio unit controllers
    private var audioUnitVCArr: NSMutableArray!
    
    lazy var window: NSWindow = self.view.window!
//    var mouseLocation: NSPoint { NSEvent.mouseLocation }
//    var location: NSPoint { window.mouseLocationOutsideOfEventStream }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let audioUrl = Bundle.main.url(forResource: "measuringtape2", withExtension: "mp3") else {
            fatalError("can't create urls from resource")
        }
        audioPlayer = AudioPlayer(audioUrl)
        
        self.audioUnitVCArr = NSMutableArray()
        
        //setupEventListeners()

        //auContainer = addPluginView() // default
        //connectAudioUnitWithPlayer()
        //audioPlayer.play()
        

    }
    

    
    private func addAudioUnit(auType: AUType) {

        let builtInPluginsURL = Bundle.main.builtInPlugInsURL
        
        switch (auType) {
        case AUType.kGainStage:
            
            // get appex
            guard let pluginURL = builtInPluginsURL?.appendingPathComponent("GainStage.appex") else {
                fatalError("cannot get plugin URL")
            }
            let appExtensionBundle = Bundle(url: pluginURL)
            
            // add view controller to array
          //  let auVc = GainStageViewController(nibName: "GainStageViewController", bundle:appExtensionBundle)//
            //audioUnitVCArr.add(auVc)
            
           // let auViewWrapper = AUViewWrapper()
            //auViewWrapper.addAudioUnit(auType: AUType.kGainStage)
           // audioUnitVCArr.add(auViewWrapper)
            
            
            
            // instantiate view controller on main vc
            //let auView = auVc.view
            //auVc.view.frame = auContainer.bounds
            //auContainer.addSubview(auVc.view)
            
            
            // connect audio unit to the players
        }
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
    
    @IBAction func buttonPressed(_ sender: NSButton) {
        
        let auWrapper = AUViewWrapper(frame: NSRect(x: self.window.contentView!.frame.minX, y: self.window.contentView!.frame.minY, width: 150, height: 150))
        self.view.addSubview(auWrapper)
        auWrapper.instantiateAudioUnit(auType: AUType.kGainStage)
        auWrapper.setConnectionView(self.connectionView)
        
        auWrapper.auViewID = audioUnitVCArr.count

        audioUnitVCArr.add(auWrapper)

        print("Number of AU: ", audioUnitVCArr.count)
        

    }
    


    
    
}


