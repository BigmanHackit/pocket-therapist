//
//  ContentView.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 15/07/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var recognizer = SpeechRecognizer()
    @StateObject private var chatViewModel = ChatViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HeaderView()
                
                // Chat Messages
                ChatMessagesView(viewModel: chatViewModel)
                
                // Input Area
                InputAreaView(
                    recognizer: recognizer,
                    onSendMessage: { message in
                        chatViewModel.sendMessage(message)
                    }
                )
            }
            .background(TeamsColors.background)
            .navigationBarHidden(true)
        }
    }
}

