//
//  TabBarViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/14/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit

class TabBarViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
           self.setupNavigationBar(hasBackButton: true, leftNavigationImage: nil)
           self.tabBarItem = UITabBarItem(title: "Overview", image: nil, tag: 0)

     
    }
    
}
