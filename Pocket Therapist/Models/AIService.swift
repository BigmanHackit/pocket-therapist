//
//  AIService.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 15/07/2025.
//

import Foundation

struct AIResponse: Decodable {
    struct Choice: Decodable {
        let message: Message
    }
    
    struct Message: Decodable {
        let role: String
        let content: String
    }
    
    let choices: [Choice]
}

class AIService {
    static let shared = AIService()
    
    let endpoint = "https://router.huggingface.co/fireworks-ai/inference/v1/chat/completions"
    private let apiKey: String? = Bundle.main.infoDictionary?["HF_KEY"] as? String

    private var chatHistory: [[String : String]] = []
    
    func resetConversation() {
        chatHistory.removeAll()
    }
    
    func sendToAI(userMessage: String, completion: @escaping (String) -> Void) {
        
        guard let apiKey = apiKey else {
            completion("❌ Missing API key.")
            return
        }

        
        let systemPrompt = """
        You are a licensed mental health therapist trained in compassionate listening and suicide prevention. Be kind, professional, and emotionally supportive. Do not repeat the same introductory phrases like “I'm sorry you're feeling this way.” Avoid redundancy and keep responses clear, short, and contextually empathetic.
        """
        
        // Add new user message
        chatHistory.append(["role": "user", "content": userMessage])
        
        // Limit history to last 6 exchanges for brevity
        let limitedHistory = chatHistory.suffix(6)
        
        var messages: [[String: String]] = [["role": "system", "content": systemPrompt]]
        messages.append(contentsOf: limitedHistory)
        
        // Prepare request
        guard let url = URL(string: endpoint) else {
            completion("Invalid API URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "messages": messages,
            "model": "accounts/fireworks/models/llama-v3p1-8b-instruct",
            "max_tokens": 200,
            "temperature": 0.5 // less creative = more consistent
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion("No response from Hugging Face.")
                return
            }
            
            // Try decoding into AIResponse
            if let aiResponse = try? JSONDecoder().decode(AIResponse.self, from: data),
               let firstChoice = aiResponse.choices.first {
                let raw = firstChoice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
                let cleaned = self.trimCommonPhrases(from: raw)
                self.chatHistory.append(["role": "assistant", "content": cleaned])
                completion(cleaned)
                return
            }
            
            // Fallback: manual parse
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
                let cleaned = self.trimCommonPhrases(from: trimmed)
                self.chatHistory.append(["role": "assistant", "content": cleaned])
                completion(cleaned)
                return
            }
            
            if let raw = String(data: data, encoding: .utf8) {
                print("Hugging Face raw response:\n\(raw)")
                completion("Sorry, the AI service is currently unavailable.")
            } else {
                completion("An unknown error occurred.")
            }
        }
        task.resume()
    }
    
    /// Removes repetitive empathetic boilerplate
    private func trimCommonPhrases(from text: String) -> String {
        var cleaned = text
        let patterns = [
            #"(?i)I'm really sorry to hear that(,)?\.?"#,
            #"(?i)I understand how you feel(,)?\.?"#,
            #"(?i)That must be tough(,)?\.?"#,
            #"(?i)It sounds like you're going through a lot(,)?\.?"#,
            #"(?i)You're not alone(,)?\.?"#
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                cleaned = regex.stringByReplacingMatches(in: cleaned, range: NSRange(cleaned.startIndex..., in: cleaned), withTemplate: "")
            }
        }
        
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
