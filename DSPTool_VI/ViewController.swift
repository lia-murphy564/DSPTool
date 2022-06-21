//
//  ViewController.swift
//  DSPTool_VI
//
//  Created by Amelia Murphy on 6/21/22.
//

import Cocoa
//import AUFramework
import AudioUnit

import Cocoa

class ViewController: NSViewController {

    private var audioPlayer: AudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "measuringtape2", withExtension: "mp3") else {
            fatalError("can't create url from resource")
        }
        audioPlayer = AudioPlayer(url)
        audioPlayer.play()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
}
