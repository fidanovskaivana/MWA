//
//  BudgetViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/15/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase

class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var availableBudgetLabel: UILabel!
    @IBOutlet var spentBudget: UILabel!
    @IBOutlet var budgetLabel: UILabel!
    
    @IBOutlet var eventsTableView: UITableView!
    
    var budgetList = [BudgetModel]()
    let uid = Auth.auth().currentUser?.uid
    var ref:DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        eventsTableView.separatorStyle = .none
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        showBudgetList()
        ref = Database.database().reference().child("userInfo").child(uid!).child("budgetEvents")
        eventsTableView.rowHeight = 90
        showBudget()
        labelsSetUp()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }

   
    func labelsSetUp(){
    spentBudget.layer.cornerRadius = 20
    availableBudgetLabel.layer.cornerRadius = 20
    spentBudget.layer.masksToBounds = true
    availableBudgetLabel.layer.masksToBounds = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! BudgetTableViewCell
        
        let budgetEvent: BudgetModel
        budgetEvent = budgetList[indexPath.row]
        cell.nameEventLabel.text = budgetEvent.eventName
        
        if let spent = budgetEvent.spentBudget {
            cell.spentBudgetLabel.text = spent
       }else{
            print("spent budget is empty")
        }
        let totalSpent = budgetList.compactMap{ Int($0.spentBudget!) }.reduce(0, +)
        self.spentBudget.text = String("$ \(totalSpent)")
        let budget = budgetLabel.text
        let allBudget = Int(budget!.number)
        let avaibleBudget = allBudget! - totalSpent
        self.availableBudgetLabel.text = "$ \(avaibleBudget)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budgetEvent = budgetList[indexPath.row]
            self.budgetList.remove(at: indexPath.row)
            eventsTableView.reloadData()
            self.deleteBudgetEvent(id: budgetEvent.id!)
        }
    }
    func deleteBudgetEvent(id: String){
        ref.child(id).setValue(nil)
        self.eventsTableView.reloadData()
    }
    
    
    func showBudget(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("userInfo").child(uid).child("budget").observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String :  Any] {
                let budget = dictionary["budget"] as! String
                self.budgetLabel.text = ("$ \(budget)")
            }
        }
    }
    
    func showBudgetList(){
        ref = Database.database().reference().child("userInfo").child(uid!).child("budgetEvents")
        ref.queryOrderedByKey().observe(.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.budgetList.removeAll()
                
                for budgetEvents in snapshot.children.allObjects as! [DataSnapshot]{
                    let budgetObject = budgetEvents.value as? [String: AnyObject]
                    let budgetEventName = budgetObject?["nameEvent"]
                    let spent = budgetObject?["spentBudget"]
                    let id = budgetObject?["id"]
                    let list = BudgetModel(eventName: budgetEventName as? String, spentBudget: spent as? String, id: id as? String)
                    
                    self.budgetList.append(list)
                }
                DispatchQueue.main.async {
                    self.eventsTableView.reloadData()
                }
                
            }
        }
        
    }
    
    func showBudgetAlert(){
        
        let addEvent = UIAlertController(title: "Add Event", message: "Add a new event", preferredStyle: .alert)
        let subview = (addEvent.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        let shapes = UIView()
        shapes.layer.cornerRadius = 30
        shapes.layer.borderWidth = 5
        shapes.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 0.8509803922, alpha: 1)
        subview.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9333333333, blue: 0.9176470588, alpha: 1)
        subview.tintColor = #colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 0.8509803922, alpha: 1)
        addEvent.view.tintColor = #colorLiteral(red: 0.4431372549, green: 0.4431372549, blue: 0.4431372549, alpha: 1)
        addEvent.addTextField()
        addEvent.addTextField()
        addEvent.textFields![0].placeholder = "Enter event"
        addEvent.textFields![1].placeholder = "Enter amount"
        addEvent.textFields![1].keyboardType = .numberPad
        
        
        let addEventAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if  let newEvent = addEvent.textFields![0].text, let spentBudget = addEvent.textFields![1].text, newEvent.count > 0 {
                
                let key = self.ref.childByAutoId().key
                let events = ["id": key, "nameEvent": newEvent, "spentBudget": spentBudget]
                
                self.ref.child(key!).setValue(events)
                self.budgetList.append(contentsOf: self.budgetList)
                self.eventsTableView.reloadData()
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        addEvent.addAction(addEventAction)
        addEvent.addAction(cancelAction)
        
        present(addEvent, animated: true, completion: nil)
    }
    
    
    @IBAction func addEventBudget(_ sender: Any) {
        showBudgetAlert()
    }
    
    @IBAction func editBidgetButtonAction(_ sender: Any) {
        
        let addBudget = UIAlertController(title: "Add Budget", message: "Enter your available budget", preferredStyle: .alert)
        addBudget.addTextField()
        
        let subview = (addBudget.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        let shapes = UIView()
        shapes.layer.cornerRadius = 30
        shapes.layer.borderWidth = 5
        shapes.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 0.8509803922, alpha: 1)
        subview.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9333333333, blue: 0.9176470588, alpha: 1)
        subview.tintColor = #colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 0.8509803922, alpha: 1)
        addBudget.view.tintColor = #colorLiteral(red: 0.4431372549, green: 0.4431372549, blue: 0.4431372549, alpha: 1)
        
        let addBudgetAction = UIAlertAction(title: "Done", style: .default) { (action) in
            if  let newBudget = addBudget.textFields?.first?.text, newBudget.count > 0 {
                self.ref = Database.database().reference().child("userInfo").child(self.uid!).child("budget")
                let key = self.ref.childByAutoId().key
                self.ref.updateChildValues(["id": key!, "budget": newBudget])
                self.eventsTableView.reloadData()
                self.budgetLabel.text = newBudget
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        addBudget.addAction(addBudgetAction)
        addBudget.addAction(cancelAction)
        
        present(addBudget, animated: true, completion: nil)
    }
}



