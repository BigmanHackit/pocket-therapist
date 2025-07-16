//
//  ChatViewModel.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var isTyping = false
    @Published var currentResponse = ""
    
    private var typingTimer: Timer?
    
    func sendMessage(_ content: String) {
        // Add user message
        let userMessage = ChatMessage(
            content: content,
            isUser: true,
            timestamp: Date()
        )
        
        messages.append(userMessage)
        
        // Start loading
        isLoading = true
        
        // Simulate API call
        AIService.shared.sendToAI(userMessage: content) { [weak self] response in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.startTypingAnimation(response)
            }
        }
    }
    
    private func startTypingAnimation(_ fullResponse: String) {
        isTyping = true
        currentResponse = ""
        
        // Add empty AI message that will be filled during typing
        let aiMessage = ChatMessage(
            content: "",
            isUser: false,
            timestamp: Date()
        )
        messages.append(aiMessage)
        
        var currentIndex = 0
        
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if currentIndex < fullResponse.count {
                let index = fullResponse.index(fullResponse.startIndex, offsetBy: currentIndex)
                let nextIndex = fullResponse.index(fullResponse.startIndex, offsetBy: currentIndex + 1)
                
                self.currentResponse = String(fullResponse[..<nextIndex])
                
                // Update the last message
                if let lastIndex = self.messages.indices.last {
                    self.messages[lastIndex].content = self.currentResponse
                }
                
                currentIndex += 1
            } else {
                timer.invalidate()
                self.isTyping = false
                self.saveConversation(userMessage: self.messages[self.messages.count - 2].content, aiResponse: fullResponse)
                
                // Start speaking if enabled
                self.speakResponse(fullResponse)
            }
        }
    }
    
    private func saveConversation(userMessage: String, aiResponse: String) {
        let userMsg = Message(role: "user", content: userMessage, timestamp: Date())
        let aiMsg = Message(role: "ai", content: aiResponse, timestamp: Date())
        
        let conversation = Conversation(
            title: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short),
            messages: [userMsg, aiMsg]
        )
        
        ConversationManager.shared.addConversation(conversation)
    }
    
    private func speakResponse(_ text: String) {
        if !text.lowercased().contains("unavailable") {
            SpeechService.shared.speak(text) {
                // Speech completed
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
        currentResponse = ""
        isTyping = false
        isLoading = false
        typingTimer?.invalidate()
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    var content: String
    let isUser: Bool
    let timestamp: Date
}
