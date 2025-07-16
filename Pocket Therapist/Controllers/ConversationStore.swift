//
//  ConversationStore.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import Foundation

class ConversationStore: ObservableObject {
    @Published var sessions: [ConversationSession] = [] {
        didSet { saveSessions() }
    }

    private let storageKey = "ConversationSessions"

    init() {
        loadSessions()
    }

    func addSession(_ session: ConversationSession) {
        sessions.insert(session, at: 0)
    }

    private func saveSessions() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([ConversationSession].self, from: data) {
            self.sessions = saved
        }
    }
}
