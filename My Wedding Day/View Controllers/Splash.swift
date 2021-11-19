//
//  Splash.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 2/3/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import UIKit
import Firebase

class Splash: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "splashToLoginSegue", sender: nil)
        }else{
            performSegue(withIdentifier: "splashToTabBarSegue", sender: nil)
        }
        
        
    }
    
}
