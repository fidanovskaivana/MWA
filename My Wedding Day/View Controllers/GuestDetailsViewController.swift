//
//  GuestDetailsViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 2/10/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class GuestDetailsViewController: UIViewController {
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneNoLabel: UILabel!
    
    var guestDetail = [GuestModel]()
    var guestUser: GuestModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false

        self.nameLabel.text = guestUser!.guestName
        self.phoneNoLabel.text = guestUser!.guestPhoneNumber
        self.emailLabel.text = guestUser!.guestEmail
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }
    
    func sendEmail(){
        
        let email = emailLabel.text!
        if let url = URL(string: "mailto:\(email)") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func makeCall(){
        let phoneNumber = phoneNoLabel.text
        if let callNumber = phoneNumber {

        let aURL = NSURL(string: "telprompt://\(callNumber)")
            if UIApplication.shared.canOpenURL(aURL! as URL) {
                UIApplication.shared.openURL(aURL! as URL)
            } else {
                print("error")
            }
         }
        else {
           print("error")}
    }

    @IBAction func sendEmailButtonAction(_ sender: Any) {
        sendEmail()
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        makeCall()
    }
    
}
