//
//  SpeechRecognizer.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 15/07/2025.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: ObservableObject {
    
    private let recognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()
    
    @Published var transcribedText = ""
    @Published var isRecording = false 
    
    func startRecording() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                DispatchQueue.main.async {
                    // Reset previous state
                    self.audioEngine.stop()
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                    guard let recognitionRequest = self.recognitionRequest else { return }
                    recognitionRequest.shouldReportPartialResults = true

                    let inputNode = self.audioEngine.inputNode
                    let recordingFormat = inputNode.outputFormat(forBus: 0)

                    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                        recognitionRequest.append(buffer)
                    }

                    do {
                        try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        self.audioEngine.prepare()
                        try self.audioEngine.start()
                    } catch {
                        print("Audio Engine Error: \(error.localizedDescription)")
                    }

                    self.recognizer?.recognitionTask(with: recognitionRequest) { result, error in
                        if let result = result {
                            DispatchQueue.main.async {
                                self.transcribedText = result.bestTranscription.formattedString
                            }
                        }
                    }
                }
            } else {
                print("Speech recognition not authorized")
            }
        }
    }

    
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
}
