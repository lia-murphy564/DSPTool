//
//  DrawView.swift
//  DSPTool_VI
//
//  Created by Amelia Murphy on 6/28/22.
//

import Foundation
import Cocoa
import CoreGraphics

class DrawView: NSView {
    // >>>CODE ADDED BY LC<<<
        private var path: NSBezierPath = {
            let path = NSBezierPath()
            path.lineWidth = 50.0
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            return path
        }()

        enum State {
            case normal
            case drawingLine(from: CGPoint, to: CGPoint)
        }
        var state = State.normal

        override func mouseDown(with event: NSEvent) {
            super.mouseDown(with: event)
            var lastPoint = event.locationInWindow
            lastPoint.x -= frame.origin.x
            lastPoint.y -= frame.origin.y
            state = .drawingLine(from: lastPoint, to: lastPoint)
        }

        override func mouseUp(with event: NSEvent) {
            if case .drawingLine(let firstPoint, _) = state {
                var newPoint = event.locationInWindow
                newPoint.x -= frame.origin.x
                newPoint.y -= frame.origin.y

                // >>>CODE ADDED BY LC<<<
                path.move(to: convert(event.locationInWindow, from: nil))
                path.line(to: firstPoint)
                
                
                needsDisplay = true
            }
        }

        override func draw(_ dirtyRect: NSRect) {
            if case .drawingLine(let firstPoint, let secondPoint) = state {

                // >>>CODE ADDED BY LC<<<
                NSColor.orange.set()
                path.lineWidth = 5.0
                path.stroke()
                
//                let cp1 = CGPoint(x: firstPoint.x + 100, y: firstPoint.y + 100)
//                let cp2 = CGPoint(x: secondPoint.x + 100, y: secondPoint.y + 100)
//
//                path.curve(to: secondPoint, controlPoint1: cp1, controlPoint2: cp2)
                path.line(to: firstPoint)
                path.line(to: secondPoint)
            }
        }
    }
