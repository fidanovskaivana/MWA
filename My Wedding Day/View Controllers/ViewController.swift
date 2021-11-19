//
//  ViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/11/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class ViewController: UIViewController{

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet weak var Loading: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
 //-MARK: Functions
    
    
//MARK: - Actions
    
    @IBAction func createAnAccountButtonAction(_ sender: Any) {
        Loading.startAnimating()
        performSegue(withIdentifier: "logInToCreateAnAccountSegue", sender: nil)
        Loading.stopAnimating()
       
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        Loading.stopAnimating()
        performSegue(withIdentifier: "signInSegue", sender: nil)
        Loading.stopAnimating()
    }
}

