import AVFoundation
import AudioToolbox
import Foundation

protocol FeedbackPlaying {
    func playCorrect(for round: GameRound, settings: GameSettings)
    func playRetry(settings: GameSettings)
    func playPrompt(for round: GameRound, settings: GameSettings)
}

final class SystemFeedbackPlayer: FeedbackPlaying {
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let voiceStore: VoicePromptStore

    init(voiceStore: VoicePromptStore = .shared) {
        self.voiceStore = voiceStore
    }

    func playCorrect(for round: GameRound, settings: GameSettings) {
        if settings.soundEnabled {
            AudioServicesPlaySystemSound(1057)
        }
        playSpokenFeedback(round.successSpeechText, recordingID: round.voicePromptID, settings: settings)
    }

    func playRetry(settings: GameSettings) {
        guard settings.soundEnabled else { return }
        AudioServicesPlaySystemSound(1104)
    }

    func playPrompt(for round: GameRound, settings: GameSettings) {
        guard settings.voicePromptEnabled else { return }

        if settings.soundEnabled {
            AudioServicesPlaySystemSound(1113)
        }
        playSpokenFeedback(round.promptSpeechText, recordingID: round.voicePromptID, settings: settings)
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

final class VoicePromptStore: NSObject, ObservableObject, AVAudioRecorderDelegate {
    static let shared = VoicePromptStore()

    @Published private(set) var recordingID: String?
    @Published private(set) var availableRecordingIDs: Set<String> = []
    @Published private(set) var authorizationDenied = false

    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?

    override init() {
        super.init()
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

    func startRecording(for kind: FriendKind) {
        startRecording(for: kind.rawValue)
    }

    func startRecording(for id: String) {
        stopRecording()

        let permissionHandler: (Bool) -> Void = { [weak self] granted in
            DispatchQueue.main.async {
                guard let self else { return }
                guard granted else {
                    self.authorizationDenied = true
                    return
                }
                self.authorizationDenied = false
                self.beginRecording(for: id)
            }
        }

        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission(completionHandler: permissionHandler)
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission(permissionHandler)
        }
    }

    var recordingKind: FriendKind? {
        guard let recordingID else { return nil }
        return FriendKind(rawValue: recordingID)
    }

    func stopRecording() {
        recorder?.stop()
        recorder = nil
        recordingID = nil
        refreshAvailableRecordings()
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

    func deleteRecording(for kind: FriendKind) {
        deleteRecording(for: kind.rawValue)
    }

    func deleteRecording(for id: String) {
        try? FileManager.default.removeItem(at: recordingURL(for: id))
        refreshAvailableRecordings()
    }

    private func beginRecording(for id: String) {
        do {
            try FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            recorder = try AVAudioRecorder(url: recordingURL(for: id), settings: settings)
            recorder?.delegate = self
            recorder?.record()
            recordingID = id
        } catch {
            recordingID = nil
            recorder = nil
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
