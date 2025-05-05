//
//  MessageQueue.swift
//  NetomiAssignment
//
//  Created by Kirti on 5/5/25.
//

import Foundation

class MessageQueue {
    static let shared = MessageQueue()
    
    var failedMessages: [Message] = []
    
    // Simulate sending a message
    func sendMessage(_ message: Message, completion: @escaping (Bool) -> Void) {
        // Simulating failure or success based on the connection
//        if !Manager.shared.isConnected {
//            failedMessages.append(message)
//            print("Message failed to send, added to queue.")
//            completion(false)
//        } else {
//            print("Message sent: \(message.message)")
//            completion(true)
//        }
    }
    
    // Retry failed messages when back online
    func retryFailedMessages() {
        for message in failedMessages {
            sendMessage(message) { success in
                if success {
                    // Remove from queue if sent
                    self.failedMessages.removeAll { $0.id == message.id }
                }
            }
        }
    }
}
