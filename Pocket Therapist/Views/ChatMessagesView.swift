//
//  ChatMessagesView.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import SwiftUI

struct ChatMessagesView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.messages.isEmpty {
                        WelcomeMessageView()
                            .padding(.top, 40)
                    } else {
                        ForEach(viewModel.messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    
                    // Typing indicator
                    if viewModel.isTyping {
                        TypingIndicatorView()
                            .id("typing")
                    }
                    
                    // Loading indicator
                    if viewModel.isLoading {
                        LoadingIndicatorView()
                            .id("loading")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(TeamsColors.background)
            .onChange(of: viewModel.messages.count) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                }
            }
            .onChange(of: viewModel.isTyping) { _ in
                if viewModel.isTyping {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo("typing", anchor: .bottom)
                    }
                }
            }
            .onChange(of: viewModel.isLoading) { _ in
                if viewModel.isLoading {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo("loading", anchor: .bottom)
                    }
                }
            }
        }
    }
}

struct WelcomeMessageView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(TeamsColors.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            
            Text("Welcome to Pocket Therapist")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            
            Text("I'm here to listen and support you. Share what's on your mind, and I'll do my best to help.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.vertical, 32)
    }
}

struct TypingIndicatorView: View {
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 8) {
            // AI Avatar
            ZStack {
                Circle()
                    .fill(.gray)
                    .frame(width: 24, height: 24)
                
                Text("AI")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Typing bubble
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(TeamsColors.background)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animating ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(TeamsColors.aiBubble)
            .cornerRadius(18)
            
            Spacer()
        }
        .onAppear {
            animating = true
        }
    }
}

struct LoadingIndicatorView: View {
    var body: some View {
        HStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.8)
                .progressViewStyle(CircularProgressViewStyle(tint: TeamsColors.primary))
            
            Text("Processing your message...")
                .font(.system(size: 14))
                .foregroundColor(TeamsColors.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(TeamsColors.surface)
        .cornerRadius(18)
    }
}

//struct ChatMessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatMessagesView(viewModel: ChatViewModel)
//    }
//}
