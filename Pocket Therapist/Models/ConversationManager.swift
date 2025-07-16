//
//  ConversationManager.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import Foundation

class ConversationManager: ObservableObject {
    static let shared = ConversationManager()
    
    @Published private(set) var conversations: [Conversation] = []

    private let fileURL: URL = {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("conversations.json")
    }()

    private init() {
        loadFromFile()
    }

    func addConversation(_ conversation: Conversation) {
        conversations.insert(conversation, at: 0)
        saveToFile()
    }

    func saveToFile() {
        do {
            let data = try JSONEncoder().encode(conversations)
            try data.write(to: fileURL)
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }

    func loadFromFile() {
        do {
            let data = try Data(contentsOf: fileURL)
            conversations = try JSONDecoder().decode([Conversation].self, from: data)
        } catch {
            print("❌ Failed to load: \(error)")
        }
    }
}
