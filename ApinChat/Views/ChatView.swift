import SwiftUI

struct ChatView: View {
    @ObservedObject var chatManager: ChatManager
    @State private var messageText = ""
    @State private var scrollProxy: ScrollViewReader?
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat Header
            if let chat = chatManager.selectedChat {
                HStack {
                    VStack(alignment: .leading) {
                        Text(chat.title)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text("\(chat.messages.count) messages")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if !chatManager.isAIAvailable {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                
                Divider()
            }
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if let chat = chatManager.selectedChat {
                            ForEach(chat.messages) { message in
                                MessageBubbleView(message: message)
                                    .id(message.id)
                            }
                            
                            if chatManager.isLoading {
                                TypingIndicatorView()
                                    .id("typing")
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    scrollProxy = proxy
                }
                .onChange(of: chatManager.selectedChat?.messages.count) { _, _ in
                    scrollToBottom()
                }
                .onChange(of: chatManager.isLoading) { _, _ in
                    scrollToBottom()
                }
            }
            
            Divider()
            
            // Message Input
            MessageInputView(
                messageText: $messageText,
                isLoading: chatManager.isLoading,
                isAIAvailable: chatManager.isAIAvailable,
                onSend: {
                    sendMessage()
                }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: .constant(chatManager.errorMessage != nil)) {
            Button("OK") {
                chatManager.errorMessage = nil
            }
        } message: {
            if let error = chatManager.errorMessage {
                Text(error)
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let text = messageText
        messageText = ""
        
        Task {
            await chatManager.sendMessage(text)
        }
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.3)) {
                if chatManager.isLoading {
                    scrollProxy?.scrollTo("typing", anchor: .bottom)
                } else if let lastMessageId = chatManager.selectedChat?.messages.last?.id {
                    scrollProxy?.scrollTo(lastMessageId, anchor: .bottom)
                }
            }
        }
    }
}

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.blue.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: "brain.head.profile")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Text("Apin")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    
                    Text(message.content)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.gray.opacity(0.1))
                        .cornerRadius(20)
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 50)
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TypingIndicatorView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Apin")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(.gray.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .offset(y: animationOffset)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: animationOffset
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.gray.opacity(0.1))
                .cornerRadius(20)
            }
            
            Spacer(minLength: 50)
        }
        .onAppear {
            animationOffset = -3
        }
    }
}

#Preview {
    ChatView(chatManager: ChatManager())
}
