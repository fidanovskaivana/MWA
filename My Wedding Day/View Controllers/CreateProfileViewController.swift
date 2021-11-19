//
//  CreateProfileViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/14/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase

class CreateProfileViewController: ViewController, UITextFieldDelegate {
    

    @IBOutlet var partner1TextField: UITextField!
    @IBOutlet var partner2TextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var venueTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var startPlanningButton: UIButton!
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    private var datePicker: UIDatePicker?
    let uid = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isHidden = true
        saveButton.isHidden = true
        datePicker = UIDatePicker()
        createDatePicker()
        
        ref = Database.database().reference()
     
        errorLabel.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }
    
    //MARK: Funtions
    
    func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    func createDatePicker() {
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createToolBar()
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
 
        self.dateTextField.text = dateFormatter.string(from: datePicker!.date)
        self.view.endEditing(true)
    }
    
    
    //-MARK: Actions
    
    @IBAction func startPlanningButtonAction(_ sender: Any) {
        
        if let partner1Name = partner1TextField.text,
            let partner2Name = partner2TextField.text,
            let dateOfEvent = dateTextField.text,
            let venue = venueTextField.text,
            let location = locationTextField.text {
            
            self.ref.child("userInfo").child(uid!).setValue(["partner1Name":partner1Name, "partner2Name":partner2Name, "dateOfEvent":dateOfEvent, "venue":venue, "location": location, "user":uid as Any])
            //show loader - hide loader
        }else{
            
            print("error user")
        }
        performSegue(withIdentifier: "toTabBar", sender: nil)
          
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        
       if let partner1Name = partner1TextField.text,
            let partner2Name = partner2TextField.text,
            let dateOfEvent = dateTextField.text,
            let venue = venueTextField.text,
            let location = locationTextField.text {
            
            self.ref.child("userInfo").child(uid!).updateChildValues(["partner1Name":partner1Name, "partner2Name":partner2Name, "dateOfEvent":dateOfEvent, "venue":venue, "location": location, "user":uid as Any])
        }else{
            
            print("error user")
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

