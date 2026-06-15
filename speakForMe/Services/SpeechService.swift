//
//  SpeechService.swift
//  speakForMe
//
//  Created by Jameka Echols on 6/14/26.
//
import AVFoundation

@MainActor
final class SpeechService: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    func speak(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            print("SpeechService: text was empty")
            return
        }

        print("SpeechService: speaking -> \(trimmedText)")
        configureAudioSession()
        

//        if synthesizer.isSpeaking {
//            synthesizer.stopSpeaking(at: .immediate)
//        }

        let utterance = AVSpeechUtterance(string: trimmedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.48
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .spokenAudio,
                options: [.duckOthers]
            )

            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("SpeechService audio session error:", error.localizedDescription)
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didStart utterance: AVSpeechUtterance
    ) {
        print("SpeechService: did start speaking")
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        print("SpeechService: did finish speaking")
    }
    
}
