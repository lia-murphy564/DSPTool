//
//  AUAudioUnitPreset.swift
//  AUFramework
//
//  Created by Amelia Murphy on 6/21/22.
//

import Foundation

extension AUAudioUnitPreset {
    convenience init(number: Int, name: String) {
        self.init()
        self.number = number
        self.name = name
    }
}
