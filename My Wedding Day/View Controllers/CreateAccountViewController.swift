//
//  CreateAccountViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/11/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin

class CreateAccountViewController: BaseViewController {
    
    @IBOutlet weak var Loader: NVActivityIndicatorView!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var familyNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var FBButton: UIButton!
    
    
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
    //-MARK: -Functions

    func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        UINavigationBar.appearance().backgroundColor = .clear
        self.navigationController?.navigationBar.isHidden = false
    }
    //Check the fields and validate - If OK data is correct - else returns error
    func validateUserInfo() -> String? {
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            familyNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" && emailTextField.text?.isValidEmail == true) ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
            
        } else if  Utilities.isPasswordValid(cleanedPassword) == false {

            return "Please make sure your password is at lieast 8 characters, contains a special character and a number"
            
        }

        return nil
    }
    
    //-MARK: -Actions
    
    @IBAction func createAnAccountButtonAction(_ sender: Any) {
        // validate
        Loader.startAnimating()
        let error = validateUserInfo()
        if error != nil {
            showError(error!)
        } else {
            // crete user
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let familyName = familyNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError("Error creating user")
                } else {
                   let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName":firstName, "familyName":familyName, "email":email, "password":password, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                        self.showError("error saving user data")
                        }
                    }
                    self.transitionToHome()
                }
            }
           
        }
        Loader.stopAnimating()
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? CreateProfileViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func facebookLoginButtonAction(_ sender: Any) {

        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(granted: _, declined: _, token: _):
                    print("Succesfully logged in  into Facebook")
                self.signIntoFirebase()
                self.transitionToHome()
            case .failed(let err):
                print(err)
            case .cancelled:
                print("canceled")
            }
            
        }
       
    }
    
    fileprivate func signIntoFirebase(){
        
        guard let authenticationToken = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signIn(with: credential) { (user, err) in
            if let err = err {
                print(err)
                return
            }
         print("Succesfuly authenticated with Firebase")
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
