//
//  ViewController.swift
//  BaseExam
//
//  Created by Sophie Zhou on 9/19/17.
//  Copyright © 2017 Sophie Zhou. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageCellDelegate {

    var messages: [Message] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    private let interactor = ChatInteractor()
    private lazy var chatPresenter = ChatPresenter(baseVC: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Buildschool Chat"
        self.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)

        let nib = UINib(nibName: "MessageCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MessageCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self

        interactor.fetchMessages { (messages, error) in
            self.messages = messages
            self.messages.sort(by: { $0.date > $1.date })
            self.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        let message = self.messages[indexPath.row]
        cell.delegate = self
        cell.label.text = "\(message.sender): \(message.message)"
        return cell
    }

    // MARK: - MessageCellDelegate

    func messageCellDidTapDelete(cell: MessageCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let message = self.messages[indexPath.row]
        chatPresenter.deleteMessage(message: message)
        self.interactor.fetchMessages { (messages, error) in
            self.messages = messages
            self.messages.sort(by: { $0.date > $1.date })
            self.tableView.reloadData()
        }
    }

    func messageCellDidTapDuplicate(cell: MessageCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let message = self.messages[indexPath.row]

        chatPresenter.createMessage(title: "DUPE", text: message.message) { (message, error) in
            self.interactor.fetchMessages { (messages, error) in
                self.messages = messages
                self.messages.sort(by: { $0.date > $1.date })
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Action handlers

    @objc func sendButtonPressed(_ button: UIButton) {
        chatPresenter.createMessage(title: nameTextField.text!, text: messageTextField.text!) { (message, error) in
            self.interactor.fetchMessages { (messages, error) in
                self.messages = messages
                self.messages.sort(by: { $0.date > $1.date })
                self.tableView.reloadData()
            }
        }
    }

}

