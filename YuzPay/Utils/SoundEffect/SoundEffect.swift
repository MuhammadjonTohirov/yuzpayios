//
//  SoundEffect.swift
//  YuzPay
//
//  Created by applebro on 31/01/23.
//

import Foundation
import AVKit

public struct SEffect {
//    public static var soundPlayer: AVAudioPlayer?
    
    public static func rigid() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
}
