//
//  ContentStore.swift
//  Novagraph1
//
//  Created by Sophie on 12/5/18.
//  Copyright © 2018 Sophie Zhou. All rights reserved.
//

import UIKit

class ContentStore: NSObject {

    static let shared = ContentStore()

    var messages: [String: Message] = [:]

}
