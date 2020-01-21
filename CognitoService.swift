//
//  CognitoService.swift
//  Novagraph1
//
//  Created by Sophie on 12/3/18.
//  Copyright © 2018 Sophie Zhou. All rights reserved.
//

import Foundation
import AWSCognito
import AWSCognitoAuth
import AWSCognitoIdentityProvider

protocol SessionToken {

    var tokenString: String { get }

}

extension AWSCognitoAuthUserSessionToken: SessionToken {

}

extension AWSCognitoIdentityUserSessionToken: SessionToken {

}

class CognitoService {

    static let shared = CognitoService()

    let pool: AWSCognitoIdentityUserPool
    let auth: AWSCognitoAuth

    private static let CognitoClientID = "ig12n6g875gfrerhl9i2pj83t"
    private static let CognitoPoolID = "us-east-1_RCwMQ1tCf"
    private static let CognitoClientSecret = "1i0h7prbpng8o3b93gc5moif8vfr81bft0b29uh32h0ogtv4qo4q"
    private static let AWSRegion = AWSRegionType.USEast1

    private static let AWSCognitoPoolKey = "Sandbox"
    private static let AWSCognitoAuthKey = "Sandbox"

    init() {
        let serviceConfig = AWSServiceConfiguration(region: CognitoService.AWSRegion, credentialsProvider: nil)
        let poolConfig = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoService.CognitoClientID,
                                                                 clientSecret: CognitoService.CognitoClientSecret,
                                                                 poolId: CognitoService.CognitoPoolID)
        AWSCognitoIdentityUserPool.register(with: serviceConfig,
                                            userPoolConfiguration: poolConfig,
                                            forKey: CognitoService.AWSCognitoPoolKey)
        self.pool = AWSCognitoIdentityUserPool(forKey: CognitoService.AWSCognitoPoolKey)

        let configuration = AWSCognitoAuthConfiguration(appClientId: CognitoService.CognitoClientID,
                                                        appClientSecret: CognitoService.CognitoClientSecret,
                                                        scopes: ["profile", "openid", "aws.cognito.signin.user.admin"],
                                                        signInRedirectUri: "sandbox://sandbox.buildschool.io",
                                                        signOutRedirectUri: "",
                                                        webDomain: "https://build-sandbox.auth.us-east-1.amazoncognito.com",
                                                        identityProvider: "Facebook",
                                                        idpIdentifier: nil,
                                                        userPoolIdForEnablingASF: CognitoService.CognitoPoolID)

        AWSCognitoAuth.registerCognitoAuth(with: configuration, forKey: CognitoService.AWSCognitoAuthKey)
        self.auth = AWSCognitoAuth(forKey: CognitoService.AWSCognitoAuthKey)
    }

    func currentAccessToken(_ completionHandler: @escaping (SessionToken?) -> Void) {
        if let session = self.pool.currentUser()?.getSession() {
            session.continueWith { (session) -> Any? in
                completionHandler(session.result?.accessToken)
            }
        } else {
            self.auth.getSession { (session, error) in
                completionHandler(session?.accessToken)
            }
        }
    }

}


