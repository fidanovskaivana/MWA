//
//  BaseViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/11/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import Foundation
import UIKit

enum LeftNavigationOption{
    case backButton
    case customButton
}

protocol BaseViewControllerDelegate {
    func leftNavigationButtonTapped()
    func rightNavigationButtonTapped()
}

class BaseViewController: UIViewController {
    
    var leftNavigationOption:LeftNavigationOption?
    var delegate:BaseViewControllerDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func rightButtonSetup(title:String){
        let rightButton = UIButton(type: .system)
        rightButton.setTitle(title, for: .normal)
        rightButton.titleLabel?.font = UIFont(name: "Roboto-Regular.ttf", size: 12)
        rightButton.setTitleColor(.gray, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        rightButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        rightButton.addTarget(self, action: #selector(rightNavigationTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    func setupNavigationBar(hasBackButton : Bool, leftNavigationImage : UIImage?, rightNavigationImage : UIImage?){
    
       leftNavigationOption = hasBackButton == true ? .backButton : .customButton
       if leftNavigationImage != nil || hasBackButton == true{
           let leftButton = UIButton(type: .system)
           let width = (self.view.frame.width * 65) / 100
           let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 22))
           if hasBackButton == true{
               leftButton.setImage(#imageLiteral(resourceName: "backIMG").withRenderingMode(.alwaysOriginal), for: .normal)
            
           } else if let leftImage = leftNavigationImage{
            
            leftButton.setImage(leftImage.withRenderingMode(.alwaysOriginal), for: .normal)
            label.backgroundColor = .clear // da se sredi da se napravi clear background na tabbar
           }
        
           leftButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
           leftButton.contentMode = .scaleAspectFit
           leftButton.addTarget(self, action: #selector(leftNavigationTapped), for: .touchUpInside)
           navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
       }else if hasBackButton == false{
        
           navigationItem.hidesBackButton = true
       }
        
        if let rightImage = rightNavigationImage {
            let rightButton = UIButton(type: .system)
            rightButton.setImage(rightImage.withRenderingMode(.alwaysOriginal), for: .normal)
            rightButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            rightButton.contentMode = .scaleAspectFit
            rightButton.addTarget(self, action: #selector(rightNavigationTapped), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        }
    }
    
    @objc func leftNavigationTapped(){
    navigationItem.leftBarButtonItem?.isEnabled = false
    if leftNavigationOption == .backButton {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    self.delegate?.leftNavigationButtonTapped()
    navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    @objc func rightNavigationTapped(){
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.delegate?.rightNavigationButtonTapped()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

}
