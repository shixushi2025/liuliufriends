import AVFoundation
import AudioToolbox
import Foundation

protocol FeedbackPlaying {
    func playCorrect(text: String, recordingID: String, settings: GameSettings)
    func playRetry(settings: GameSettings)
    func playPrompt(text: String, recordingID: String, settings: GameSettings)
}

final class SystemFeedbackPlayer: FeedbackPlaying {
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let voiceStore: VoicePromptStore

    init(voiceStore: VoicePromptStore = .shared) {
        self.voiceStore = voiceStore
    }

    func playCorrect(text: String, recordingID: String, settings: GameSettings) {
        if settings.soundEnabled {
            AudioServicesPlaySystemSound(1057)
        }
        playSpokenFeedback(text, recordingID: recordingID, settings: settings)
    }

    func playRetry(settings: GameSettings) {
        guard settings.soundEnabled else { return }
        AudioServicesPlaySystemSound(1104)
    }

    func playPrompt(text: String, recordingID: String, settings: GameSettings) {
        guard settings.voicePromptEnabled else { return }

        if settings.soundEnabled {
            AudioServicesPlaySystemSound(1113)
        }
        playSpokenFeedback(text, recordingID: recordingID, settings: settings)
    }

    private func playSpokenFeedback(_ text: String, recordingID: String, settings: GameSettings) {
        guard settings.voicePromptEnabled else { return }

        if settings.customVoiceEnabled, voiceStore.playRecording(for: recordingID) {
            return
        }
        speak(text)
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

final class VoicePromptStore: ObservableObject {
    static let shared = VoicePromptStore()

    @Published private(set) var availableRecordingIDs: Set<String> = []

    private var player: AVAudioPlayer?

    init() {
        refreshAvailableRecordings()
    }

    func hasRecording(for kind: FriendKind) -> Bool {
        hasRecording(for: kind.rawValue)
    }

    func hasRecording(for id: String) -> Bool {
        availableRecordingIDs.contains(id)
    }

    var recordingCount: Int {
        availableRecordingIDs.count
    }

    @discardableResult
    func playRecording(for kind: FriendKind) -> Bool {
        playRecording(for: kind.rawValue)
    }

    @discardableResult
    func playRecording(for id: String) -> Bool {
        let url = recordingURL(for: id)
        guard FileManager.default.fileExists(atPath: url.path) else {
            return false
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            return player?.play() == true
        } catch {
            return false
        }
    }

    private func refreshAvailableRecordings() {
        let urls = (try? FileManager.default.contentsOfDirectory(at: recordingsDirectory, includingPropertiesForKeys: nil)) ?? []
        availableRecordingIDs = Set(urls.compactMap { url in
            guard url.pathExtension == "m4a" else { return nil }
            return url.deletingPathExtension().lastPathComponent
        })
    }

    private var recordingsDirectory: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("VoicePrompts", isDirectory: true)
    }

    private func recordingURL(for id: String) -> URL {
        recordingsDirectory.appendingPathComponent(id).appendingPathExtension("m4a")
    }
}
