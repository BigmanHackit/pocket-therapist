//
//  ConversationMessage.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import Foundation

struct ConversationMessage: Codable, Identifiable {
    var id = UUID()
    let role: String // "user" or "assistant"
    let content: String
    let timestamp: Date
}

struct ConversationSession: Codable, Identifiable {
    var id = UUID()
    let title: String
    let messages: [ConversationMessage]
    let createdAt: Date
}

struct Message: Codable {
    let role: String  // "user" or "ai"
    let content: String
    let timestamp: Date
}

struct Conversation: Codable, Identifiable {
    let id: UUID
    var title: String
    var messages: [Message]
    let createdAt: Date

    init(title: String, messages: [Message]) {
        self.id = UUID()
        self.title = title
        self.messages = messages
        self.createdAt = Date()
    }
}
