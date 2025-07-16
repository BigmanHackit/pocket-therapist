//
//  HeaderView.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import SwiftUI

struct HeaderView: View {
    @State private var showingHistory = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Top header bar
            HStack {
                // Avatar and title
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(TeamsColors.primary)
                            .frame(width: 40, height: 40)
                        
                        Text("AI")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pocket Therapist")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(TeamsColors.text)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(TeamsColors.success)
                                .frame(width: 8, height: 8)
                            
                            Text("Active")
                                .font(.system(size: 12))
                                .foregroundColor(TeamsColors.textSecondary)
                        }
                    }
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 16) {
                    Button(action: {
                        showingHistory.toggle()
                    }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(TeamsColors.textSecondary)
                    }
                    .buttonStyle(TeamsIconButtonStyle())
                    
                    Button(action: {
                        // Settings action
                    }) {
                        Image(systemName: "gear")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(TeamsColors.textSecondary)
                    }
                    .buttonStyle(TeamsIconButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(TeamsColors.surface)
            
            // Divider
            Rectangle()
                .fill(TeamsColors.border)
                .frame(height: 1)
        }
        .sheet(isPresented: $showingHistory) {
            ConversationHistoryView()
        }
    }
}

struct TeamsIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .fill(configuration.isPressed ? TeamsColors.hover : Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
