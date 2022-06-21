//
//  AudioPlayer.swift
//  DSPTool_VI
//
//  Created by Amelia Murphy on 6/21/22.
//

import AVFoundation

class AudioPlayer: NSObject {
    
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var file: AVAudioFile!
    private var isPlaying = false
    private let audioPlayerQueue = DispatchQueue(label: "AudioPlayerQueue")
    
    init(_ url: URL) {
        guard let file = try? AVAudioFile(forReading: url) else {
            fatalError("can't load file")
        }
        self.file = file
        super.init()
        engine.attach(playerNode)
    }
    
    func play() {
        audioPlayerQueue.sync {
            guard !self.isPlaying else { return }
            self.startPlaying()
        }
    }
    
    private func startPlaying() {
        engine.connect(playerNode, to: engine.mainMixerNode, format: file.processingFormat)
        scheduleLoop(file)
        let hardwareFormat = engine.outputNode.outputFormat(forBus: 0)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: hardwareFormat)
        do {
            try engine.start()
        } catch {
            fatalError("can't start engine \(error)")
        }
        playerNode.play()
        isPlaying = true
    }
    
    private func scheduleLoop(_ file: AVAudioFile) {
        playerNode.scheduleFile(file, at: nil) {
            self.audioPlayerQueue.async {
                if self.isPlaying {
                    self.scheduleLoop(file)
                }
            }
        }
    }
}
