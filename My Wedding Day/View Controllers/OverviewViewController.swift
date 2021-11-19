//
//  OverviewViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/14/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase

class OverviewViewController: UIViewController {

    
    @IBOutlet var namesLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var venueLabel: UILabel!
    @IBOutlet var daysLeftLabel: UILabel!
    @IBOutlet var guestsConfirmed: UILabel!
    @IBOutlet var invitedGuestsLabel: UILabel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        guestConfirmed()
        guestInvited()
        loadUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }
    
    
    //MARK:Functions
    
    func loadUserData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("userInfo").child(uid).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String :  Any] {
                let partner1Name = dictionary["partner1Name"] as! String
                let partner2Name = dictionary["partner2Name"] as! String
                let dateOfEvent = dictionary["dateOfEvent"] as! String
                let venue = dictionary["venue"] as! String
                let location = dictionary["location"] as! String
                
                self.namesLabel.text = "\(partner1Name) & \(partner2Name)"
                self.dateLabel.text = "\(dateOfEvent)"
                self.venueLabel.text = venue
                self.locationLabel.text = location
                
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "MMM d, yyyy"
        
                let calendar = Calendar.current
                let date1 = calendar.startOfDay(for: Date())
                let date2 = calendar.startOfDay(for: dateFormater.date(from: dateOfEvent)!)
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                let daysLeft = components.day!

                self.daysLeftLabel.text = "\(daysLeft)"
        }
        }
    }
    
    func guestInvited(){
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("userInfo").child(uid!)
        ref.child("guests").queryOrdered(byChild: "invited").queryEqual(toValue: "invited").observe(.value) { snapshot in
            let numberOfguests = snapshot.childrenCount
            self.invitedGuestsLabel.text = "\(numberOfguests)"
            print(snapshot.childrenCount)

        }
    }
    
    func guestConfirmed(){
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("userInfo").child(uid!)
        ref.child("guests").queryOrdered(byChild: "attending").queryEqual(toValue: "attending").observe(.value) { snapshot in
            let numberOfguests = snapshot.childrenCount
            self.guestsConfirmed.text = "\(numberOfguests)"
            print(snapshot.childrenCount)

        }
        
    }
    
    
    //MARK: Buttons Actions
    
    @IBAction func editButton(_ sender: Any) {
        let editAlert = UIAlertController()
        editAlert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            let selectionVC = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! CreateProfileViewController
            self.present(selectionVC, animated: true, completion: nil)
            selectionVC.saveButton.isHidden = false
            selectionVC.startPlanningButton.isHidden = true
            selectionVC.backButton.isHidden = false
           
        }))
        
        editAlert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: {_ in
            self.signOutbuttonTapped()
        }))
        
        editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
        }))
        
        present(editAlert, animated: true)
        
    }
    
    //MARK: SignOutUser
    
    @objc private func signOutbuttonTapped(){
        do{
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error")
        }
    }
    
}
