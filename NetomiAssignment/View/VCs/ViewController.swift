//
//  ChatTableViewCell.swift
//  NetomiAssignment
//
//  Created by Kirti on 5/5/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private var emptyStateLabel: UILabel?
    private let viewModel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chats"
        view.backgroundColor = .white
        
        DispatchQueue.main.async { [self] in
            showEmptyState()
        }
        
        // Set up table view
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        view.addSubview(tableView)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        viewModel.onNewMessageReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onConnectionErrorReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.showError(message: "There was a problem with the connection.")
                self?.updateUI()
            }
        }
        
        viewModel.onDisconnection = { [weak self] in
            DispatchQueue.main.async {
                self?.showError(message: "The connection is disconnected.")
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        if viewModel.chats.isEmpty {
            showEmptyState()
        } else {
            showEmptyState(false)
            tableView.reloadData()
        }
    }
    
    func showEmptyState(_ show: Bool = true) {
        if show {
            if emptyStateLabel == nil {
                let label = UILabel()
                label.text = "No chats available."
                label.textAlignment = .center
                label.frame = view.bounds
                emptyStateLabel = label
                view.addSubview(label)
            }
        } else {
            emptyStateLabel?.removeFromSuperview()
            emptyStateLabel = nil
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: Table View Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Safely dequeuing the custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let chat = viewModel.chats[indexPath.row]
        cell.titleLabel.text = chat.sender
        cell.subtitleLabel.text = chat.message.last
        cell.titleLabel.textColor = chat.isRead ? .black : .blue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update chat to be marked as read
        viewModel.chats[indexPath.row].isRead = true
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

