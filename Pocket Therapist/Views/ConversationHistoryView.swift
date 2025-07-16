//
//  ConversationHistoryView.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import SwiftUI

struct ConversationHistoryView: View {
    @ObservedObject var manager = ConversationManager.shared

    var body: some View {
        NavigationView {
            List(manager.conversations) { convo in
                NavigationLink(destination: ConversationDetailView(conversation: convo)) {
                    VStack(alignment: .leading) {
                        Text(convo.title)
                            .font(.headline)
                        Text("\(convo.messages.count) message(s)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Conversation History")
        }
    }
}

struct ConversationDetailView: View {
    let conversation: Conversation

    var body: some View {
        List {
            ForEach(conversation.messages, id: \.timestamp) { message in
                VStack(alignment: .leading) {
                    Text(message.role.capitalized)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(message.content)
                        .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(conversation.title)
    }
}


struct ConversationHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationHistoryView()
    }
}
