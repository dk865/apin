import Foundation
import FoundationModels

@MainActor
class AIService: ObservableObject {
    private var model = SystemLanguageModel.default
    private var sessions: [UUID: LanguageModelSession] = [:]
    
    @Published var modelAvailability: SystemLanguageModel.Availability
    
    init() {
        self.modelAvailability = model.availability
    }
    
    func checkModelAvailability() {
        modelAvailability = model.availability
    }
    
    func createSession(for chatId: UUID) {
        let instructions = """
        You are Apin, an AI assistant created by dk865. You are helpful, creative, and engaging.
        Keep your responses conversational and concise unless specifically asked for detailed information.
        You maintain context within this conversation but don't remember previous conversations.
        """
        
        sessions[chatId] = LanguageModelSession(instructions: instructions)
    }
    
    func removeSession(for chatId: UUID) {
        sessions.removeValue(forKey: chatId)
    }
    
    func generateResponse(for chatId: UUID, prompt: String) async throws -> String {
        guard case .available = modelAvailability else {
            throw AIServiceError.modelUnavailable
        }
        
        // Get or create session for this chat
        if sessions[chatId] == nil {
            createSession(for: chatId)
        }
        
        guard let session = sessions[chatId] else {
            throw AIServiceError.sessionNotFound
        }
        
        // Check if session is already responding
        if session.isResponding {
            throw AIServiceError.sessionBusy
        }
        
        let options = GenerationOptions(temperature: 0.7)
        
        do {
            let response = try await session.respond(to: prompt, options: options)
            return response
        } catch {
            throw AIServiceError.generationFailed(error.localizedDescription)
        }
    }
    
    func getAvailabilityMessage() -> String {
        switch modelAvailability {
        case .available:
            return "AI Ready"
        case .unavailable(.deviceNotEligible):
            return "Device not eligible for Apple Intelligence"
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Please enable Apple Intelligence in Settings"
        case .unavailable(.modelNotReady):
            return "AI model is loading..."
        case .unavailable(let other):
            return "AI unavailable: \(other.localizedDescription)"
        }
    }
}

enum AIServiceError: LocalizedError {
    case modelUnavailable
    case sessionNotFound
    case sessionBusy
    case generationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .modelUnavailable:
            return "AI model is not available"
        case .sessionNotFound:
            return "Chat session not found"
        case .sessionBusy:
            return "AI is currently processing another request"
        case .generationFailed(let message):
            return "Failed to generate response: \(message)"
        }
    }
}
