import SwiftUI

struct MessageInputView: View {
    @Binding var messageText: String
    let isLoading: Bool
    let isAIAvailable: Bool
    let onSend: () -> Void
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if !isAIAvailable {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    
                    Text("AI features limited - Apple Intelligence not available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            
            HStack(spacing: 12) {
                HStack {
                    TextField("Message Apin...", text: $messageText, axis: .vertical)
                        .textFieldStyle(.plain)
                        .focused($isTextFieldFocused)
                        .lineLimit(1...6)
                        .disabled(isLoading)
                        .onSubmit {
                            if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                onSend()
                            }
                        }
                    
                    if !messageText.isEmpty && !isLoading {
                        Button(action: {
                            messageText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.gray.opacity(0.1))
                .cornerRadius(25)
                
                Button(action: onSend) {
                    Group {
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                        }
                    }
                    .foregroundColor(canSend ? .blue : .gray)
                }
                .disabled(!canSend || isLoading)
            }
            .padding()
        }
        .background(.ultraThinMaterial)
    }
    
    private var canSend: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    VStack {
        Spacer()
        MessageInputView(
            messageText: .constant("Hello there!"),
            isLoading: false,
            isAIAvailable: true,
            onSend: {}
        )
    }
}
