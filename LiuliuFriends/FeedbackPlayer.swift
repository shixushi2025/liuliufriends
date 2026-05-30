import AVFoundation
import AudioToolbox
import Foundation

protocol FeedbackPlaying {
    func playCorrect(settings: GameSettings)
    func playRetry(settings: GameSettings)
    func playPrompt(for round: GameRound, settings: GameSettings)
}

final class SystemFeedbackPlayer: FeedbackPlaying {
    private let speechSynthesizer = AVSpeechSynthesizer()

    func playCorrect(settings: GameSettings) {
        guard settings.soundEnabled else { return }
        AudioServicesPlaySystemSound(1057)
    }

    func playRetry(settings: GameSettings) {
        guard settings.soundEnabled else { return }
        AudioServicesPlaySystemSound(1104)
    }

    func playPrompt(for round: GameRound, settings: GameSettings) {
        guard settings.voicePromptEnabled else { return }
        AudioServicesPlaySystemSound(1113)

        guard round.mode == .sound else { return }
        speak(round.targetKind.soundText)
    }

    private func speak(_ text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.78
        utterance.pitchMultiplier = 1.18
        utterance.volume = 0.86
        speechSynthesizer.speak(utterance)
    }
}
