import Foundation
import SocketIO

class SocketConnectionManager {
    
    static let shared = SocketConnectionManager()
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private let socketURL = URL(string: URLConstants.socketURL)
    
    var onMessageReceived: ((String) -> Void)?
    var onConnectionError: ((String) -> Void)?
    var onDisconnect: ((String) -> Void)?
    
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5
    
    init() {
        guard let socketURL else { return }
        manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress, .reconnects(true)])
        socket = manager.defaultSocket
    }
    
    func connect() {
        
        guard socket.status != .connected else { return }
        
        socket.connect()
        
        socket.on(clientEvent: .connect) { data, ack in
            self.reconnectAttempts = 0
        }
        
        socket.on(clientEvent: .error) { data, ack in
            if let errorMessage = data.first as? String {
                self.onConnectionError?(errorMessage)
            }
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            if let disconnectMessage = data.first as? String {
                self.onDisconnect?(disconnectMessage)
            }
            if self.reconnectAttempts < self.maxReconnectAttempts {
                self.reconnectAttempts += 1
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5)) {
                    self.connect() // Attempt to reconnect after a delay
                }
            }
        }
        
        socket.on("message") { data, ack in
            if let message = data[0] as? String {
                self.onMessageReceived?(message)
            }
        }
    }
    
    func sendMessage(_ message: String) {
        socket.emit("message", message)
    }
    
    func disconnect() {
        if socket.status == .connected {
            socket.disconnect()
        }
    }
    
    deinit {
        socket.off(clientEvent: .connect)
        socket.off(clientEvent: .error)
        socket.off(clientEvent: .disconnect)
        socket.off("message")
    }
}
