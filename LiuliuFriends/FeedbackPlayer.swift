import AudioToolbox
import Foundation

protocol FeedbackPlaying {
    func playCorrect(settings: GameSettings)
    func playRetry(settings: GameSettings)
    func playPrompt(for round: GameRound, settings: GameSettings)
}

struct SystemFeedbackPlayer: FeedbackPlaying {
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
    }
}
