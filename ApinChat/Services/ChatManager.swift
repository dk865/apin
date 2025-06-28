import Foundation
import SwiftUI

@MainActor
class ChatManager: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var selectedChatId: UUID?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let aiService = AIService()
    private let saveKey = "SavedChats"
    
    var selectedChat: Chat? {
        guard let selectedChatId = selectedChatId else { return nil }
        return chats.first { $0.id == selectedChatId }
    }
    
    init() {
        loadChats()
    }
    
    func createNewChat() {
        let newChat = Chat(title: "New Chat")
        chats.insert(newChat, at: 0)
        selectedChatId = newChat.id
        aiService.createSession(for: newChat.id)
        saveChats()
    }
    
    func selectChat(_ chat: Chat) {
        selectedChatId = chat.id
        // Session will be created when needed in AIService
    }
    
    func deleteChat(_ chat: Chat) {
        chats.removeAll { $0.id == chat.id }
        aiService.removeSession(for: chat.id)
        
        if selectedChatId == chat.id {
            selectedChatId = chats.first?.id
        }
        
        saveChats()
    }
    
    func sendMessage(_ content: String) async {
        guard let selectedChatId = selectedChatId,
              let chatIndex = chats.firstIndex(where: { $0.id == selectedChatId }) else {
            return
        }
        
        // Add user message
        let userMessage = ChatMessage(content: content, isUser: true)
        chats[chatIndex].addMessage(userMessage)
        saveChats()
        
        // Start loading
        isLoading = true
        errorMessage = nil
        
        do {
            // Generate AI response
            let response = try await aiService.generateResponse(for: selectedChatId, prompt: content)
            
            // Add AI response
            let aiMessage = ChatMessage(content: response, isUser: false)
            chats[chatIndex].addMessage(aiMessage)
            saveChats()
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func checkAIAvailability() {
        aiService.checkModelAvailability()
    }
    
    func getAIStatusMessage() -> String {
        return aiService.getAvailabilityMessage()
    }
    
    var isAIAvailable: Bool {
        if case .available = aiService.modelAvailability {
            return true
        }
        return false
    }
    
    private func saveChats() {
        if let encoded = try? JSONEncoder().encode(chats) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadChats() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Chat].self, from: data) {
            chats = decoded
        }
    }
}
