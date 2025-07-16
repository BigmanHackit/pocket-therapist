//
//  MessageBubbleView.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage
    @State private var isSpeaking = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser {
                Spacer()
                userMessageBubble
            } else {
                aiAvatar
                aiMessageBubble
                Spacer()
            }
        }
        .padding(.horizontal, 4)
    }
    
    private var userMessageBubble: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(message.content)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(TeamsColors.userBubble)
                .cornerRadius(18)
                .cornerRadius(4, corners: .bottomLeft)
            
            Text(formatTime(message.timestamp))
                .font(.system(size: 11))
                .foregroundColor(TeamsColors.textSecondary)
        }
    }
    
    private var aiMessageBubble: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 12) {
                Text(message.content)
                    .font(.system(size: 16))
                    .foregroundColor(TeamsColors.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(TeamsColors.aiBubble)
                    .cornerRadius(18)
                    .cornerRadius(4, corners: .bottomRight)
                    .scaleEffect(isSpeaking ? 1.02 : 1.0)
                    .animation(
                        isSpeaking ?
                            .easeInOut(duration: 1.0).repeatForever(autoreverses: true) :
                            .default,
                        value: isSpeaking
                    )
                
                // Speak button
                Button(action: {
                    speakMessage()
                }) {
                    Image(systemName: isSpeaking ? "speaker.wave.2.fill" : "speaker.2")
                        .font(.system(size: 14))
                        .foregroundColor(TeamsColors.primary)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(TeamsIconButtonStyle())
            }
            
            HStack(spacing: 8) {
                Text(formatTime(message.timestamp))
                    .font(.system(size: 11))
                    .foregroundColor(TeamsColors.textSecondary)
                
                if isSpeaking {
                    HStack(spacing: 4) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 10))
                            .foregroundColor(TeamsColors.primary)
                        
                        Text("Speaking...")
                            .font(.system(size: 11))
                            .foregroundColor(TeamsColors.primary)
                    }
                }
            }
        }
    }
    
    private var aiAvatar: some View {
        ZStack {
            Circle()
                .fill(TeamsColors.primary)
                .frame(width: 28, height: 28)
            
            Text("AI")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func speakMessage() {
        isSpeaking = true
        SpeechService.shared.speak(message.content) {
            isSpeaking = false
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            MessageBubbleView(message: ChatMessage(
                content: "Hello, how are you feeling today?",
                isUser: false,
                timestamp: Date()
            ))
            
            MessageBubbleView(message: ChatMessage(
                content: "I'm feeling a bit anxious about work.",
                isUser: true,
                timestamp: Date()
            ))
        }
        .padding()
        .background(TeamsColors.background)
    }
}
