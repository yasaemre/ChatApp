//
//  ChatPresenter.swift
//  Novagraph1
//
//  Created by Sophie on 12/17/18.
//  Copyright © 2018 Sophie Zhou. All rights reserved.
//

import UIKit
import Foundation

class ChatPresenter {

    private weak var baseVC: UIViewController?
    private let interactor = ChatInteractor()

    init(baseVC: UIViewController) {
        self.baseVC = baseVC
    }

    func createMessage(title: String, text: String, completionHandler: @escaping ((Message?, Error?) -> Void)) {
        self.interactor.createMessage(sender: title, message: text) { (message, error) in
            self.presentAlert(title: "Success", text: "Successfully created message.")
            completionHandler(message,error)
        }
    }

    func deleteMessage(message: Message) {
        self.interactor.delete(message: message) { (error) in
            self.presentAlert(title: "Success", text: "Successfully deleted message!")
        }
    }

    func presentAlert(title: String, text: String) {
        let controller = UIAlertController(title: title,
                                           message: text,
                                           preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
        })
        controller.addAction(okAction)
        self.baseVC?.present(controller, animated: true, completion: nil)
    }

}
