//
//  LoginViewController.swift
//  Firebase1
//
//  Created by Sophie on 3/23/18.
//  Copyright © 2018 Sophie Zhou. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bottomTextField.isSecureTextEntry = true

        self.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        self.registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
    }

    @objc func loginButtonPressed(_ button: UIButton) {
        // TODO: Fill this out.
    }

    @objc func registerButtonPressed(_ button: UIButton) {
        // TODO: Fill this out.
    }

}
