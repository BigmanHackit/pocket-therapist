//
//  InputAreaView.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import SwiftUI

struct InputAreaView: View {
    @ObservedObject var recognizer: SpeechRecognizer
    let onSendMessage: (String) -> Void
    
    @State private var textInput = ""
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Divider
            Rectangle()
                .fill(TeamsColors.border)
                .frame(height: 1)
            
            // Recording indicator
            if recognizer.isRecording {
                recordingIndicator
            }
            
            // Input area
            VStack(spacing: 12) {
                // Input field
                HStack(spacing: 12) {
                    // Text input
                    TextField("Type a message...", text: $textInput)
                        .textFieldStyle(TeamsTextFieldStyle())
                        .onSubmit {
                            if !textInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                sendMessage(textInput)
                            }
                        }
                        .foregroundColor(.black)
                    
                    // Voice input button
                    Button(action: toggleRecording) {
                        Image(systemName: recognizer.isRecording ? "stop.circle.fill" : "mic.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(recognizer.isRecording ? .red : TeamsColors.primary)
                    }
                    .buttonStyle(TeamsIconButtonStyle())
                    
                    // Send button
                    Button(action: {
                        if !getCurrentMessage().isEmpty {
                            sendMessage(getCurrentMessage())
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(getCurrentMessage().isEmpty ? TeamsColors.textSecondary : TeamsColors.primary)
                    }
                    .disabled(getCurrentMessage().isEmpty)
                }
                
                // Voice input display
                if !recognizer.transcribedText.isEmpty {
                    voiceInputDisplay
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(TeamsColors.surface)
        }
        .onChange(of: recognizer.transcribedText) { _ in
            textInput = recognizer.transcribedText
        }
    }
    
    private var recordingIndicator: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(.red)
                    .frame(width: 8, height: 8)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: 1.0)
                
                Text("Recording...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.red)
            }
            
            WaveformView()
                .frame(height: 40)
                .padding(.horizontal, 32)
        }
        .padding(.vertical, 12)
        .background(Color.red.opacity(0.05))
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var voiceInputDisplay: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "mic.fill")
                    .font(.system(size: 12))
                    .foregroundColor(TeamsColors.primary)
                
                Text("Voice Input")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(TeamsColors.primary)
                
                Spacer()
                
                Button(action: {
                    recognizer.transcribedText = ""
                    textInput = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(TeamsColors.textSecondary)
                }
            }
            
            Text(recognizer.transcribedText)
                .font(.system(size: 14))
                .foregroundColor(TeamsColors.text)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(TeamsColors.primary.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(TeamsColors.hover)
        .cornerRadius(8)
    }
    
    private func toggleRecording() {
        if recognizer.isRecording {
            recognizer.stopRecording()
        } else {
            recognizer.startRecording()
        }
    }
    
    private func getCurrentMessage() -> String {
        if !recognizer.transcribedText.isEmpty {
            return recognizer.transcribedText
        }
        return textInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func sendMessage(_ message: String) {
        onSendMessage(message)
        textInput = ""
        recognizer.transcribedText = ""
    }
}

struct TeamsTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(TeamsColors.hover)
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(TeamsColors.border, lineWidth: 1)
            )
    }
}

struct InputAreaView_Previews: PreviewProvider {
    static var previews: some View {
        InputAreaView(
            recognizer: SpeechRecognizer(),
            onSendMessage: { message in
                print("Sent: \(message)")
            }
        )
    }
}
