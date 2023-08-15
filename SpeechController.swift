//import Foundation
//import Speech
//import AVFoundation
//
//// SpeechController manages speech recognition
//class SpeechController: ObservableObject {
//    private let speechRecognizer = SFSpeechRecognizer() // Change the locale if needed
//    private let audioEngine = AVAudioEngine()
//
//    @Published var recognizedText = ""
//    @Published var isRecording = false
//
//    init() {
////        requestSpeech(buffer: buffer)
//    }
//
//    func startRecordingNew() {
//            if isRecording {
//                // Stop recording
//                isRecording = false
//            } else {
//                // Start recording
//                isRecording = true
//
//                let node = audioEngine.inputNode
//                let recordingFormat = node.outputFormat(forBus: 0)
//                node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
//                    self.requestSpeechNew(buffer: buffer)
//                }
//                do{
//                    try audioEngine.start()
//                    audioEngine.inputNode.removeTap(onBus: 0)
//                    audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
//                        self.requestSpeechNew(buffer: buffer)
//                    }
//                }catch{
//
//                }
//
//            }
//        }
//
//    func startRecording() {
//            if isRecording {
//                // Stop recording
//                isRecording = false
//            } else {
//                // Start recording
//                isRecording = true
//
//                let node = audioEngine.inputNode
//                let recordingFormat = node.outputFormat(forBus: 0)
//                node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
//                    self.requestSpeechNew(buffer: buffer)
//                }
//                audioEngine.prepare ()
//
//                do {
//                    try  audioEngine.start()
//                } catch {
//                return print (error)
//                }
//
//                audioEngine.inputNode.removeTap(onBus: 0)
//                audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
//                    self.requestSpeech(buffer: buffer)
//                }
//            }
//        }
//
//    func requestSpeechNew(buffer: AVAudioPCMBuffer) {
//            let request = SFSpeechAudioBufferRecognitionRequest()
//            request.shouldReportPartialResults = true
//            request.contextualStrings = ["hello", "goodbye"]
//            request.append(buffer)
//
//        let recognitionTask = speechRecognizer!.recognitionTask(with: request) { (result, error) in
//                if let result = result {
//                    self.recognizedText = result.bestTranscription.formattedString
//                    if result.isFinal {
//                        print("Result",self.recognizedText)
//                        if self.recognizedText == "hello" {
////                            self.showAlert(title: "Hello!", message: "Greetings!")
//                        } else if self.recognizedText == "goodbye" {
////                            self.showAlert(title: "Goodbye!", message: "Farewell!")
//                        }
//                    }
//                }
//            }
//        }
//
//
//    func stopRecording() {
//        isRecording = false
//        audioEngine.stop()
//        audioEngine.inputNode.removeTap(onBus: 0)
//    }
//
//    // Other speech control methods and error handling
//
//    func requestSpeech(buffer: AVAudioPCMBuffer) {
//            let request = SFSpeechAudioBufferRecognitionRequest()
//            request.shouldReportPartialResults = true
//            request.contextualStrings = ["hello", "goodbye"]
//            request.append(buffer)
//
//        let recognitionTask = speechRecognizer?.recognitionTask(with: request) { (result, error) in
//                if let result = result {
//                    self.recognizedText = result.bestTranscription.formattedString
//                    if result.isFinal {
//                        if self.recognizedText == "hello" {
//                            print("Hello")
//                        } else if self.recognizedText == "goodbye" {
//                            print("goodbye")
//                        }
//                    }
//                }
//            }
//        }
//}


import AVFoundation
import Foundation
import Speech

/// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
class SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    @Published var transcript: String = ""
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer? = nil
    
    init() {
           recognizer = SFSpeechRecognizer()
           
           Task(priority: .background                                                                                                                                           ) {
               do {
                   guard recognizer != nil else {
                       throw RecognizerError.nilRecognizer
                   }
                   guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                       throw RecognizerError.notAuthorizedToRecognize
                   }
                   guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                       throw RecognizerError.notPermittedToRecord
                   }
               } catch {
                   speakError(error)
               }
           }
       }
       
       deinit {
           reset()
       }
    
    /// Reset the speech recognizer.
        func reset() {
            task?.cancel()
            audioEngine?.stop()
            audioEngine = nil
            request = nil
            task = nil
        }
    
    /// Stop transcribing audio.
        func stopTranscribing() {
            reset()
        }
    
    private func speak(_ message: String) {
            transcript = message
    }
    
    private func speakError(_ error: Error) {
            var errorMessage = ""
            if let error = error as? RecognizerError {
                errorMessage += error.message
            } else {
                errorMessage += error.localizedDescription
            }
            transcript = "<< \(errorMessage) >>"
    }
    /**
            Begin transcribing audio.
         
            Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopTranscribing()`.
            The resulting transcription is continuously written to the published `transcript` property.
         */
        func transcribe() {
            DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
                guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                    self?.speakError(RecognizerError.recognizerIsUnavailable)
                    return
                }
                
                do {
                    let (audioEngine, request) = try Self.prepareEngine()
                    self.audioEngine = audioEngine
                    self.request = request
                    
                    self.task = recognizer.recognitionTask(with: request) { result, error in
                        let receivedFinalResult = result?.isFinal ?? false
                        let receivedError = error != nil // != nil mean there's error (true)
                        
                        if receivedFinalResult || receivedError {
                            audioEngine.stop()
                            audioEngine.inputNode.removeTap(onBus: 0)
                        }
                        
                        if let result = result {
                            self.speak(result.bestTranscription.formattedString)
                        }
                    }
                } catch {
                    self.reset()
                    self.speakError(error)
                }
            }
        }
        
        private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
            let audioEngine = AVAudioEngine()
            
            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = audioEngine.inputNode
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
                (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                request.append(buffer)
            }
            audioEngine.prepare()
            try audioEngine.start()
            
            return (audioEngine, request)
        }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}


