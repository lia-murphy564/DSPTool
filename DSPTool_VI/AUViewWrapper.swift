//
//  File.swift
//  DSPTool_VI
//
//  Created by Amelia Murphy on 6/27/22.
//

import Foundation
import AppKit
import CoreAudioKit
import AUFramework

enum AUType : Int {
    case kGainStage = 0
}

class AUViewWrapper : NSView {
    
    var auView: AUViewController!
    
    var auViewID: Int!
    
    //@IBOutlet var wrapperContainer: NSView!
    @IBOutlet weak var connectHandle: NSButton!
    
    //@IBOutlet weak var connectionView: ConnectionView!
    
    //@IBOutlet var view: NSView!// = NSView()
    @IBOutlet var view: NSView!
    
    var connectionView: ConnectionView!
    
    let builtInPluginsURL = Bundle.main.builtInPlugInsURL
    
    //override lazy var window: NSWindow?
    //var mouseLocation: NSPoint { NSEvent.mouseLocation }
    var location: NSPoint { self.window!.mouseLocationOutsideOfEventStream }
    
    var diffX: CGFloat!
    var diffY: CGFloat!
    var isInBounds: Bool!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        let bundle = Bundle(for: type(of: self))
        let nib = NSNib(nibNamed: .init(String(describing: type(of: self))), bundle: bundle)!
        nib.instantiate(withOwner: self, topLevelObjects: nil)
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = ColorPalette.light_blue
        self.view.layer?.borderWidth = 1
        self.view.layer?.borderColor = ColorPalette.black
        self.view.layer?.cornerRadius = 5

        self.view.frame = NSRect(x: 0, y: 0, width: frame.size.height, height: frame.size.width)
        
        self.addSubview(view)
        //self.setupEventListeners()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func instantiateAudioUnit(auType: AUType) {
        switch (auType) {
        case AUType.kGainStage:
            // get appex
            guard let pluginURL = builtInPluginsURL?.appendingPathComponent("GainStage.appex") else {
                fatalError("cannot get plugin URL")
            }
            let appExtensionBundle = Bundle(url: pluginURL)
            
            // add view controller to array
            let auVc = GainStageViewController(nibName: "GainStageViewController", bundle: appExtensionBundle)
            
           // self.auView = auVc
           // self.addSubview(self.auView.view)
        }
    }
    
    @IBAction func connectionHandleClicked(_ sender: NSButton) {
        var newConnection = Connection(start: self.connectHandle.frame.origin)
        //newConnection.startPoint = self.connectHandle.frame.origin//NSPoint(x: 0, y: 0)
        //newConnection.controlPoint1 = NSPoint(x: newConnection.startPoint.x + 50 ,y: newConnection.startPoint.y)
        //newConnection.controlPoint1 = NSPoint(x: 110, y: 100)
        ///newConnection.controlPoint2 = NSPoint(x: 140, y: 150)
        //newConnection.endPoint = NSPoint(x: 1500, y: 1050)
        newConnection.recalculate()
        
        self.connectionView.createConnection(connection: newConnection)
        self.connectionView.connectionStyle = .solidLine
        self.connectionView.state = .didSelectConnection
        
        //self.connectionView.setViewId(id: self.auViewID)
       // self.connectionView.setCurrentConnectionID(connection: newConnection)
    }
    
    public func setConnectionView(_ v: ConnectionView) {
        self.connectionView = v
    }
    
    private func checkMouseInBounds(frame: CGRect) -> Bool {
        let mX = self.location.x
        let mY = self.location.y

        return (mX > frame.minX && mX < frame.maxX && mY > frame.minY && mY < frame.maxY) ? true : false
    }

    override func mouseDown(with event: NSEvent) {
        self.diffX = self.location.x - self.frame.minX
        self.diffY = self.location.y - self.frame.minY

        self.isInBounds = self.checkMouseInBounds(frame: self.frame) ? true : false

        if (self.isInBounds) {
            self.view.wantsLayer = true
            self.view.layer?.backgroundColor = ColorPalette.black
        }
        
        print(self.auViewID!)
        self.connectionView.setViewId(id: self.auViewID)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = ColorPalette.light_blue
        //self.connectionView.setEndLocation(NSPoint(x: super.frame.midX, y: super.frame.midY))
    }
    
    override func mouseDragged(with event: NSEvent) {
        let mX = self.location.x
        let mY = self.location.y

        //print(mX, " ", mY)
        //print(self.diffX, " ", self.diffY)
        if (self.isInBounds) {
            let point = NSPoint(x: mX - self.diffX, y: mY - self.diffY)
            //print(point)
            self.setFrameOrigin(point)
            //print("connection handle location:", self.view.convert(self.connectHandle.frame.origin, to: connectionView))
            self.connectionView.moveStartPoint(id: self.auViewID, startPoint: self.view.convert(self.connectHandle.frame.origin, to: connectionView))
            self.connectionView.needsDisplay = true

        }
        else {
            self.connectionView.mouseDragged(with: event)
        }
    }

    
//    override func keyDown(with event: NSEvent) {
//        //super.keyDown(with: event)
//        print(event.keyCode)
////        if event.keyCode ==  {
////            let loc = event.locationInWindow
////            self.connectionView.setEndpoint(connectionID: 0, endPoint: loc)
////            print("pressed")
////        }
//    }
}
