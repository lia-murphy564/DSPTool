//
//  ConnectionView.swift
//  DSPTool_VI
//
//  Created by Amelia Murphy on 6/30/22.
//

import Foundation
import Cocoa
import CoreGraphics

class Connection {
    var startPoint: NSPoint!
    var endPoint: NSPoint!
    var midPoint: NSPoint!
    var controlPoint1: NSPoint!// = NSPoint(x: startPoint.x + 50 ,y: startPoint.y)
    var controlPoint2: NSPoint!
    
    init(start: NSPoint) {
        self.startPoint = start
        self.endPoint = self.startPoint
        self.recalculate()
    }
    
    public func recalculate() {
        self.controlPoint1 = NSPoint(x: self.startPoint.x + 50 ,y: self.startPoint.y)
    }
    
}

enum ConnectionStyle {
    case null
    case solidLine
}

enum ConnectionState {
    case inactive
    case didSelectConnection
}

class ConnectionView: NSView {
    
    var state: ConnectionState = .inactive
    var id: Int = 0
    
    var trackingArea : NSTrackingArea?
    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        self.createConnection(connection: Connection(start: NSPoint(x: 0, y: 0)))
//    }
//
//    override required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    override func updateTrackingAreas() {
        if trackingArea != nil {
            self.removeTrackingArea(trackingArea!)
        }
        let options : NSTrackingArea.Options =
            [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options,
                                      owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }
    
    private var connectionsList: [Connection] = [ ]
    
    public var connectionStyle: ConnectionStyle = .null
    
    public func createConnection(connection: Connection) {
        connectionsList.append(connection)
        print("created connection: ", connectionsList.count)
        needsDisplay = true
    }
    
    public func setEndpoint(connectionID: Int, endPoint: NSPoint) {
        guard connectionsList.isEmpty else {
            connectionsList[connectionID].endPoint = endPoint
            needsDisplay = true
            return
        }
    }
    
    public func setViewId(id: Int) {
        self.id = id
    }
    
    public func moveStartPoint(id: Int, startPoint: NSPoint) {
        guard connectionsList.isEmpty else {
            connectionsList[id].startPoint = startPoint
            //print(connectionsList[id].startPoint)
            return
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        guard let context = NSGraphicsContext.current?.cgContext else {
          return
        }
        
        switch self.connectionStyle {
        case .solidLine:
            connectionsList.forEach {
                context.setStrokeColor(NSColor.blue.cgColor)
                context.setLineWidth(2.0)
                context.setLineCap(.round)
                context.move(to: $0.startPoint)
                context.addQuadCurve(to: $0.endPoint, control: $0.controlPoint1)
                //context.addLine(to: $0.endPoint)
                context.strokePath()
            }
        case .null:
            return
        }
    }
    
    func isMouseInView(view: NSView) -> Bool? {
        if let window = view.window {
            return view.isMousePoint(window.mouseLocationOutsideOfEventStream, in: view.frame)
        }
        return nil
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        
        if self.state == .didSelectConnection {
            let loc = event.locationInWindow
            self.setEndpoint(connectionID: self.id, endPoint: loc)
            connectionsList.forEach {
                $0.recalculate()
            }
        }

        needsDisplay = true
        //print("moving!!")
    }

    override func mouseDragged(with event: NSEvent) {
       
        let loc = event.locationInWindow
        self.setEndpoint(connectionID: self.id, endPoint: loc)
        connectionsList.forEach {
            $0.recalculate()
        }
        needsDisplay = true
        //print(loc)
        //print("pressed")
    }
    
    override var acceptsFirstResponder: Bool { true }
    
    override func keyDown(with event: NSEvent) {
        //super.keyDown(with: event)
        //print("keycode: ", event.keyCode)
        
        if self.state == .inactive { self.state = .didSelectConnection }
        else if self.state == .didSelectConnection { self.state = .inactive }
        //print("zoomma")
//        if event.keyCode == 49 { // space
//            let loc = event.locationInWindow
//            self.setEndpoint(connectionID: 0, endPoint: loc)
//            //print(loc)
//            //print("pressed")
//        }
    }
}

