//
//  ChatViewModel.swift
//  NetomiAssignment
//
//  Created by Kirti on 5/5/25.
//
import Foundation

class ChatViewModel {
    
    var chats: [Message] = [] {
        // Whenever the chats array is updated, notify the view controller to update the UI
        didSet {
            onNewMessageReceived?()
        }
    }
    
    var onNewMessageReceived: (() -> Void)?
    var onConnectionErrorReceived: (() -> Void)?
    var onDisconnection: (() -> Void)?
    
    init() {
        SocketConnectionManager.shared.onMessageReceived = { [weak self] message in
            self?.updateChatWithNewMessage(message)
        }
        
        SocketConnectionManager.shared.onConnectionError = { [weak self] error in
            self?.updateViewOnConnectionError()
        }
        
        SocketConnectionManager.shared.onDisconnect = { [weak self] error in
            self?.updateViewOnCDisconnection()
        }
    }
    
    deinit {
        SocketConnectionManager.shared.disconnect()
    }
    
    private func updateChatWithNewMessage(_ message: String) {
        let messageArray = message.split(separator: ",")
        guard messageArray.count > 1 else { return }
        
        guard let room = messageArray[0].split(separator: ":").last else { return }
        guard let messageContent = messageArray[1].split(separator: ":").last else { return }
        
        if let index = chats.firstIndex(where: { $0.sender == String(room) }) {
            // If chat exists, update the message
            chats[index].message.append(String(messageContent))
        } else {
            // If chat doesn't exist, create a new one
            let newMessage = Message(id: UUID().uuidString,
                                     sender: String(room),
                                     message: [String(messageContent)],
                                     timestamp: Date.now,
                                     isRead: false)
            chats.append(newMessage)
        }
    }
    
    private func updateViewOnConnectionError() {
        self.onConnectionErrorReceived?()
    }
    
    private func updateViewOnCDisconnection() {
        self.onConnectionErrorReceived?()
    }
}

