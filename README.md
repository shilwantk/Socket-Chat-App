# Chat Application

This is a simple chat application that allows users to send and receive messages in real-time using Socket.IO for communication. The app is structured with the Model-View-ViewModel (MVVM) pattern, providing a clean separation of concerns between the data, UI, and business logic. The app also includes basic empty state handling when no chats are available.

---

## Project Structure

Here’s a breakdown of the key components and their files in this project:

### 1. **AppDelegate.swift / SceneDelegate.swift**
- **Purpose**: This file sets up the initial view controller, embeds it inside a `UINavigationController`, and handles socket connection setup during app launch.
- **Key Actions**:
  - Configures the app window.
  - Embeds the main view controller (`ViewController`) in a navigation controller.
  - Connects to the socket using `SocketConnectionManager.shared.connect()`.

### 2. **ViewController.swift**
- **Purpose**: The primary view controller that contains the table view for displaying chat messages.
- **Key Actions**:
  - Displays a list of chat messages using a `UITableView`.
  - Handles empty state when no messages are available.
  - Listens to updates from the `ChatViewModel` via a callback (`onNewMessageReceived`).
  - Updates the UI when new messages are received.
  - Calls `SocketConnectionManager` for socket communication.
  
### 3. **ChatViewModel.swift**
- **Purpose**: The ViewModel that handles chat-related data and logic.
- **Key Actions**:
  - Receives new messages from the socket via the `SocketConnectionManager`.
  - Updates the `chats` array with new messages.
  - Notifies the view controller via the `onNewMessageReceived` closure when the data is updated.

### 4. **CustomTableViewCell.swift**
- **Purpose**: A custom table view cell with two labels: one for the title (sender) and one for the subtitle (message).
- **Key Actions**:
  - Displays the sender's name in the `titleLabel`.
  - Displays the message in the `subtitleLabel`.
  - Configures layout using Auto Layout for responsive design.

### 5. **SocketConnectionManager.swift**
- **Purpose**: Manages the socket connection and communication.
- **Key Actions**:
  - Manages the connection to the Socket.IO server.
  - Receives messages and forwards them to the `ChatViewModel`.
  - Sends messages to the server when required.

### 6. **Message.swift**
- **Purpose**: Defines the `Message` model used to represent individual messages.
- **Key Actions**:
  - Contains properties like `id`, `sender`, `message`, `timestamp`, and `isRead`.

---

## How it Works

1. **Socket Communication**:
   - The app connects to a Socket.IO server using `SocketConnectionManager`.
   - When a new message is received, it is forwarded to the `ChatViewModel`, which updates the list of chats.

2. **MVVM Pattern**:
   - The `ViewController` is the **View** in the MVVM pattern and is responsible for displaying the UI.
   - The `ChatViewModel` is the **ViewModel** and handles business logic, including updating chat messages and notifying the view when new messages are available.

3. **Table View**:
   - The `UITableView` displays the list of messages, and each message is represented by a custom cell (`CustomTableViewCell`).
   - The table view is dynamically updated when new messages are added.

4. **Empty State**:
   - If no messages are available, an empty state is displayed with the text “No chats available.”

---

## Missing Features

- **Message Sending Functionality**: 
  - The current version of the app does not yet include the functionality to send messages from the client to the server. Future updates should implement this feature to allow users to send their own messages in the chat.
  
- **Test Cases**:
  - The app currently lacks automated unit and UI test cases. Adding test cases for message handling, socket communication, and UI updates would be beneficial for ensuring the robustness and stability of the app.

---

## Installation

Follow the steps below to set up and run the app locally:

### Prerequisites

- Xcode (latest version recommended).
- CocoaPods for dependency management.

### Steps

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/your-username/chat-app.git
    cd chat-app
    ```

2. **Install Dependencies**:
   If you're using CocoaPods to manage dependencies (if applicable):

    ```bash
    pod install
    ```

3. **Open the Project**:
   Open the `.xcworkspace` file to ensure you're working with the correct workspace:

    ```bash
    open ChatApp.xcworkspace
    ```

4. **Run the App**:
   Select the appropriate device or simulator and click **Run** in Xcode to build and launch the app.

### Socket Server

Make sure you have a running Socket.IO server. The app is configured to connect to a `localhost:8080` server by default. You can modify the URL in the `SocketConnectionManager` if needed.

## Features

- **Real-time chat**: Messages are received and sent in real time using Socket.IO.
- **Dynamic table view**: The list of messages automatically updates when a new message is received.
- **Empty state handling**: Displays a "No chats available" message when no chats exist.
- **Read/Unread messages**: Mark messages as read when tapped.

---

## Future Enhancements

- **Message Sending**: Implement the ability to send messages from the client to the server.
- **Message Formatting**: Add support for formatting the messages (e.g., rich text, images, links).
- **User Authentication**: Implement user authentication for a more personalized experience.
- **Persistent Storage**: Store messages locally (using CoreData or Realm) for offline access.
- **Push Notifications**: Implement push notifications for new messages.

---

## License

This project is open source and available under the [MIT License](LICENSE).

   
