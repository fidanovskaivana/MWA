//
//  AddGuestViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/15/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase


class AddGuestViewController: UIViewController {
    
    
    @IBOutlet var guestNameTextField: UITextField!
    @IBOutlet var guestFamilyNameTextField: UITextField!
    @IBOutlet var guestEmailTextField: UITextField!
    @IBOutlet var guestPhoneNumberTextField: UITextField!
    
    @IBOutlet var attendingSwitch: UISwitch!
    @IBOutlet var invitedSwitch: UISwitch!
    
    @IBOutlet var sideSegmentedControl: UISegmentedControl!
    @IBOutlet var tableStatusSegmentedControl: UISegmentedControl!
    @IBOutlet var ageSegmentedControl: UISegmentedControl!
    @IBOutlet var menuSegmentedControl: UISegmentedControl!
    
    let uid = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSegmentControl()

        ref = Database.database().reference().child("userInfo").child(uid!).child("guests")
        setUpNavigationBar()
        
    }
    
    
    func setUpNavigationBar(){
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           self.navigationController?.navigationBar.shadowImage = UIImage()
           self.navigationController?.navigationBar.isTranslucent = true
           UINavigationBar.appearance().backgroundColor = .clear
           self.navigationController?.navigationBar.isHidden = false
       }

    func setUpSegmentControl(){
        sideSegmentedControl.isEnabled = false
        tableStatusSegmentedControl.isEnabled = false
        ageSegmentedControl.isEnabled = false
        menuSegmentedControl.isEnabled = false
    }
    
    func addGuest(){
        let key = ref.childByAutoId().key
        let partnerSide = sideSegmentedControl.selectedSegmentIndex == 0 ? "partner1" : "partner2"
        let tableStatus = tableStatusSegmentedControl.selectedSegmentIndex == 0 ? "seated" : "notSeated"
        let age = ageSegmentedControl.selectedSegmentIndex == 0 ? "adult" : "child"
        let menu = menuSegmentedControl.selectedSegmentIndex == 0 ? "vegan" : "regular"
        let attending = attendingSwitch.isOn == false ? "notAttending" : "attending"
        let invited = invitedSwitch.isOn == false ? "notInvited" : "invited"
        
        let guest = ["id": key,
                     "guestName": guestNameTextField.text! as String,
                     "guestFamilyName": guestFamilyNameTextField.text! as String, "guestEmail": guestEmailTextField.text! as String, "guestPhoneNumber": guestPhoneNumberTextField.text! as String, "partnerSide" :  partnerSide, "tableStatus" : tableStatus, "age" : age, "menu" : menu, "attending" : attending, "invited" : invited,"tableNo":""]
        
        ref.child(key!).setValue(guest)
    }
    
    func addGuestNotAttending(){
        let key = ref.childByAutoId().key
        let attending = attendingSwitch.isOn == false ? "notAttending" : "attending"
        let invited = invitedSwitch.isOn == false ? "notInvited" : "invited"
         let guest = ["id": key, "guestName": guestNameTextField.text! as String,
         "guestFamilyName": guestFamilyNameTextField.text! as String, "guestEmail": guestEmailTextField.text! as String, "guestPhoneNumber": guestPhoneNumberTextField.text! as String, "attending" : attending, "invited" : invited]
        ref.child(key!).setValue(guest)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if attendingSwitch.isOn{
           addGuest()
        }else{
            addGuestNotAttending()
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

        self.tabBarController?.tabBar.isHidden = false
   }
    
    @IBAction func selectSide(_ sender: Any) {
      
    }
    
    @IBAction func selectTableStatus(_ sender: Any) {
        
    }
    
    @IBAction func selectAgeStatus(_ sender: Any) {
       
    }
    
    @IBAction func selectManu(_ sender: Any) {
     
    }
    
    @IBAction func attendingSwichAction(_ sender: UISwitch) {
        
        if attendingSwitch.isOn {
            sideSegmentedControl.isEnabled = true
            tableStatusSegmentedControl.isEnabled = true
            ageSegmentedControl.isEnabled = true
            menuSegmentedControl.isEnabled = true
        }else{
            setUpSegmentControl()
        }
    }
    @IBAction func invitedSwitchAction(_ sender: UISwitch) {
        
    }
    
}
