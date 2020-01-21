//
//  ChatInteractor.swift
//  Novagraph1
//
//  Created by Sophie on 12/17/18.
//  Copyright © 2018 Sophie Zhou. All rights reserved.
//

import Foundation
import Alamofire
import Novagraph

class ChatInteractor {

    func delete(message: Message, completionHandler:@escaping ((Error?) -> Void)) {
        let url = URL(string: "https://sandbox.buildschool.io/message")!
        let parameters = ["id": message.id]
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            completionHandler(response.error)
        }
    }

    func createMessage(sender: String, message: String, completionHandler:@escaping ((Message?, Error?) -> Void)) {
        let url = URL(string: "https://sandbox.buildschool.io/graph/post")!
        let data = ["sender": sender, "text": message]
        let queryDict = [
            "query": "mutation execute { message(data:\"\(data.jsonStringify())\") }"
        ]
        CognitoService.shared.currentAccessToken { (token) in
            guard let tokenString = token?.tokenString else { return }
            let header: HTTPHeaders = ["X-Token": tokenString, "Content-Type": "application/json"]
            Alamofire.request(url, method: .post, parameters: queryDict, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                if let json = response.result.value as? [String: Any] {
                    let messages = self.processObjects(dict: json)
                    completionHandler(messages.last, response.error)
                } else {
                    completionHandler(nil, response.error)
                }
            }
        }
    }

    func fetchMessages(completionHandler: @escaping (([Message], Error?) -> Void)) {
        let url = URL(string: "https://sandbox.buildschool.io/graph/get")!
        let queryDict = ["query": "query execute { message }" ]
        CognitoService.shared.currentAccessToken { token in
            guard let tokenString = token?.tokenString else { return }
            print(tokenString)
            let header: HTTPHeaders = ["X-Token": tokenString, "Content-Type": "application/json"]
            Alamofire.request(url, method: .post, parameters: queryDict, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                if let json = response.result.value as? [String: Any] {
                    let messages = self.processObjects(dict: json)
                    completionHandler(messages, response.error)
                } else {
                    completionHandler([], response.error)
                }
            }
        }
    }

    private func processObjects(dict: [String: Any]) -> [Message] {
        var messages: [Message] = []
        if let objectsDict = dict["objects"] as? [String: Any] {
            for (id, objectData) in objectsDict {
                if let objectDict = objectData as? [String: Any] {
                    if let type = objectDict["type"] as? String {
                        if type == "message" {
                            let message = Message.fetchOrCreate(with: id)
                            message.parse(data: objectDict)
                            messages.append(message)
                        }
                    }
                }
            }
        }
        return messages
    }

}
