import Foundation

struct Chat: Identifiable, Codable {
    let id = UUID()
    var title: String
    var messages: [ChatMessage]
    let createdAt: Date
    var lastMessageAt: Date
    
    init(title: String) {
        self.title = title
        self.messages = []
        self.createdAt = Date()
        self.lastMessageAt = Date()
    }
    
    mutating func addMessage(_ message: ChatMessage) {
        messages.append(message)
        lastMessageAt = message.timestamp
        
        // Update title based on first user message if it's still "New Chat"
        if title == "New Chat" && message.isUser && !message.content.isEmpty {
            let words = message.content.components(separatedBy: .whitespacesAndNewlines)
            let firstFiveWords = words.prefix(5).joined(separator: " ")
            title = firstFiveWords.isEmpty ? "New Chat" : firstFiveWords
        }
    }
}
