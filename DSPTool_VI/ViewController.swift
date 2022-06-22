//
//  ViewController.swift
//  DSPTool_VI
//
//  Created by Amelia Murphy on 6/21/22.
//

import Cocoa
import AUFramework
import AudioUnit
import CoreGraphics
import AppKit

class ViewController: NSViewController {
    
    private var audioPlayer: AudioPlayer!
    private var pluginVC: TemplateAudioUnitViewController!
    private var gainVC: GainStageViewController!
    
    @IBOutlet weak var auContainer: NSView!
    
    @IBOutlet weak var addEffectButton: NSButton!
    
    lazy var window: NSWindow = self.view.window!
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    var location: NSPoint { window.mouseLocationOutsideOfEventStream }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "measuringtape2", withExtension: "mp3") else {
            fatalError("can't create urls from resource")
        }
        audioPlayer = AudioPlayer(url)
        setupEventListeners()
        auContainer = addPluginView()
        //connectAudioUnitWithPlayer()
        //audioPlayer.play()
    }
    
    private func setupEventListeners() {
        
        var diffX: CGFloat!
        var diffY: CGFloat!
        var isInBounds: Bool!
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) {
            let color = CGColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 1)
            self.auContainer.wantsLayer = true
            self.auContainer.layer?.backgroundColor = color
            
            
            diffX = self.location.x - self.auContainer.frame.minX
            diffY = self.location.y - self.auContainer.frame.minY
            
            if (self.checkMouseInBounds(frame: self.auContainer.frame)) {
                isInBounds = true
            }
            else {
                isInBounds = false
            }
            
            return $0
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseUp) {
            let color = CGColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 0)
            self.auContainer.wantsLayer = true
            self.auContainer.layer?.backgroundColor = color
            return $0
        }
        
        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDragged]) {
            
            let mX = self.location.x
            let mY = self.location.y
            
            if (isInBounds) {
                self.auContainer.setFrameOrigin(NSPoint(x: mX - diffX, y: mY - diffY))
            }
        
            
            return $0
        }
        
        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .leftMouseDragged]) {
            
            return $0
        }
    }
    
    private func checkMouseInBounds(frame: CGRect) -> Bool {
        let mX = self.location.x
        let mY = self.location.y
        print(mX, " ", mY)
        print("minX: ", frame.minX, " maxX: ", frame.maxX, " minY: ", frame.minY, " maxY: ", frame.maxY)
        
        if (mX > frame.minX && mX < frame.maxX && mY > frame.minY && mY < frame.maxY) {
            print("true")
            return true
        }
        else {
            return false
        }
    }

    private func addPluginView() -> NSView {
        
        // grab appex
        let builtInPluginsURL = Bundle.main.builtInPlugInsURL
        guard let pluginURL = builtInPluginsURL?.appendingPathComponent("GainStage.appex") else {
            fatalError("cannot get plugin URL")
        }
        let appExtensionBundle = Bundle(url: pluginURL)
        
        // get view controller
        pluginVC = TemplateAudioUnitViewController(nibName: "TemplateAudioUnitViewController", bundle: appExtensionBundle)
        gainVC = GainStageViewController(nibName: "GainStageViewController", bundle: appExtensionBundle)
        
        // set view controller's bounds for checking
        let auView = gainVC.view
        auView.frame = auContainer.bounds
        auContainer.addSubview(auView)
        return auContainer
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
        // spawn AU contanier
        addPluginView()
        
        
       // mouseDownEvent = NSEvent.pressedMouseButtons
        
        //print(mouseDownEvent)
    }

    
    
}
