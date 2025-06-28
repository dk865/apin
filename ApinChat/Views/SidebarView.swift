import SwiftUI

struct SidebarView: View {
    @ObservedObject var chatManager: ChatManager
    @State private var showingDeleteAlert = false
    @State private var chatToDelete: Chat?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Apin Chat")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Made by dk865")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    chatManager.createNewChat()
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            
            Divider()
            
            // AI Status
            HStack {
                Image(systemName: chatManager.isAIAvailable ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(chatManager.isAIAvailable ? .green : .orange)
                    .font(.caption)
                
                Text(chatManager.getAIStatusMessage())
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            
            Divider()
            
            // Chat List
            List {
                ForEach(chatManager.chats) { chat in
                    ChatRowView(
                        chat: chat,
                        isSelected: chatManager.selectedChatId == chat.id,
                        onSelect: {
                            chatManager.selectChat(chat)
                        },
                        onDelete: {
                            chatToDelete = chat
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .listStyle(.sidebar)
        }
        .navigationTitle("Chats")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Chat", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let chat = chatToDelete {
                    chatManager.deleteChat(chat)
                }
            }
        } message: {
            Text("Are you sure you want to delete this chat? This action cannot be undone.")
        }
    }
}

struct ChatRowView: View {
    let chat: Chat
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(chat.title)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(isSelected ? .blue : .primary)
                    
                    if let lastMessage = chat.messages.last {
                        Text(lastMessage.content)
                            .font(.caption)
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                    } else {
                        Text("No messages yet")
                            .font(.caption)
                            .foregroundColor(.tertiary)
                    }
                    
                    Text(formatDate(chat.lastMessageAt))
                        .font(.caption2)
                        .foregroundColor(.tertiary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
        .background(isSelected ? .blue.opacity(0.1) : .clear)
        .cornerRadius(8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    NavigationSplitView {
        SidebarView(chatManager: ChatManager())
    } detail: {
        Text("Detail View")
    }
}
