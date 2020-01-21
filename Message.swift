//
//  Message.swift
//  Firebase1
//
//  Created by Sophie on 3/23/18.
//  Copyright © 2018 Sophie Zhou. All rights reserved.
//

import UIKit
import CoreData
import Novagraph

@objc(Message)
class Message: NSManagedObject, FetchOrCreatable {

    typealias T = Message

    @NSManaged var id: String
    @NSManaged var message: String
    @NSManaged var sender: String
    @NSManaged var date: Date

    func parse(data: [String: Any]) {
        if let id = data["id"] as? String {
            self.id = id
        }
        if let dataDict = data["data"] as? [String: Any] {
            if let text = dataDict["text"] as? String {
                self.message = text
            }
            if let sender = dataDict["sender"] as? String {
                self.sender = sender
            }
        }

        if let creationDate = data["time_created"] as? String {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            self.date = formatter.date(from: creationDate)!
        }
    }

}
