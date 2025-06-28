import SwiftUI

struct ContentView: View {
    @StateObject private var chatManager = ChatManager()
    @State private var showingSidebar = false
    
    var body: some View {
        NavigationSplitView {
            SidebarView(chatManager: chatManager)
        } detail: {
            if let _ = chatManager.selectedChat {
                ChatView(chatManager: chatManager)
            } else {
                WelcomeView(chatManager: chatManager)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            chatManager.checkAIAvailability()
            if chatManager.chats.isEmpty {
                chatManager.createNewChat()
            }
        }
    }
}

struct WelcomeView: View {
    let chatManager: ChatManager
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue.gradient)
                
                Text("Apin Chat")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Made by dk865")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                Text("Welcome to Apin Chat")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Your intelligent AI companion powered by Apple Intelligence")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: chatManager.isAIAvailable ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(chatManager.isAIAvailable ? .green : .orange)
                    
                    Text(chatManager.getAIStatusMessage())
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                if !chatManager.isAIAvailable {
                    Text("Some features may be limited without Apple Intelligence")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: {
                chatManager.createNewChat()
            }) {
                HStack {
                    Image(systemName: "plus.message")
                    Text("Start New Chat")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue.gradient)
                .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    ContentView()
}
