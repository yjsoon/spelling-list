//
//  SpeechManager.swift
//  Spelling List
//
//  Created by YJ Soon on 30/1/25.
//

import AVFoundation
import Observation

@Observable
final class SpeechManager {
    private let synthesizer = AVSpeechSynthesizer()
    var isSpeaking = false
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
}
