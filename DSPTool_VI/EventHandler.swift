////
////  EventHandler.swifts
////  DSPTool_VI
////
////  Created by Amelia Murphy on 6/22/22.
////
//
//import Foundation
//import Cocoa
//
//extension ViewController {
//
//
//    public func setupEventListeners() {
//
//
//        NSEvent.addLocalMonitorForEvents(matching: .leftMouseUp, handler: onMouseUp)
//        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged, handler: onMouseDragged)
//        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown, handler: onMouseDown)
//    }
//
//    private func onMouseDown(event: NSEvent) -> NSEvent {
//        //let _view = self.auContainer!
//
////        let color = CGColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 1)
////
//        view.wantsLayer = true
////        _view.layer?.backgroundColor = color
//
//        self.diffX = self.location.x - self.auContainer.frame.minX
//        self.diffY = self.location.y - self.auContainer.frame.minY
//
//        isInBounds = self.checkMouseInBounds(frame: view.frame) ? true : false
//
//        if (isInBounds) {
//            let color = CGColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 1)
//            self.auContainer.wantsLayer = true
//            self.auContainer.layer?.backgroundColor = color
//        }
//
//        return event
//    }
//
//    private func onMouseUp(event: NSEvent) -> NSEvent {
//        //let _view = self.auContainer!
//        let color = CGColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 0)
//        self.auContainer.wantsLayer = true
//        self.auContainer.layer?.backgroundColor = color
//
//
//        return event
//    }
//
//    private func onMouseDragged(event: NSEvent) -> NSEvent {
//
//        //let view = self.auContainer!
//
//        let mX = self.location.x
//        let mY = self.location.y
//
//        if (self.isInBounds) {
//            self.auContainer.setFrameOrigin(NSPoint(x: mX - self.diffX, y: mY - self.diffY))
//
//
//        }
//
//        return event
//    }
//
//    private func checkMouseInBounds(frame: CGRect) -> Bool {
//        let mX = self.location.x
//        let mY = self.location.y
//        return (mX > frame.minX && mX < frame.maxX && mY > frame.minY && mY < frame.maxY) ? true : false
//    }
//
////    private func checkMouseInBounds(frame: CGRect) -> Bool {
////        let mX = self.location.x
////        let mY = self.location.y
////        print(mX, " ", mY)
////        print("minX: ", frame.minX, " maxX: ", frame.maxX, " minY: ", frame.minY, " maxY: ", frame.maxY)
////
////        if (mX > frame.minX && mX < frame.maxX && mY > frame.minY && mY < frame.maxY) {
////            print("true")
////            return true
////        }
////        else {
////            return false
////        }
////      }
//}
//
//
//// }
