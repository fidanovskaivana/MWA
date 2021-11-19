//
//  SignInViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/21/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: BaseViewController {
    
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        passwordTextField.isSecureTextEntry = true
        setUpNavigationBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }
    
    func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        UINavigationBar.appearance().backgroundColor = .clear
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Please create an account."
                print("Faild to sign in user up with error:", error.localizedDescription)
            }else{
                self.performSegue(withIdentifier: "signInToTabBarSegue", sender: nil)
                print("Succesfully logged user in")
            }
        }
    }
}
