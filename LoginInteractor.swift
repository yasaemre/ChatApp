//
//  LoginInteractor.swift
//  NovagraphExample
//
//  Created by Sophie on 12/2/18.
//  Copyright © 2018 Buildschool. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCognitoIdentityProvider

class LoginInteractor {

    func login(email: String, password: String, completionHandler:@escaping ((Error?)-> Void)) {
        let user = CognitoService.shared.pool.getUser(email)
        user.getSession(email, password: password, validationData: nil).continueWith(block: { (task) -> Any? in
            DispatchQueue.main.async {
                completionHandler(task.error)
            }
            return nil
        })
    }

    func register(email: String, password: String, completionHandler:@escaping ((Error?)-> Void)) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        let emailAttribute = AWSCognitoIdentityUserAttributeType()!
        emailAttribute.name = "email"
        emailAttribute.value = email
        attributes.append(emailAttribute)

        CognitoService.shared.pool.signUp(email, password: password, userAttributes: attributes, validationData: nil).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }

}
