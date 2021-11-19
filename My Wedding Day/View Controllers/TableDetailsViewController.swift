//
//  TableDetailsViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 3/28/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import UIKit
import Firebase

class TableDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet var tableNoLabel: UILabel!
    @IBOutlet var tableNameLabel: UILabel!
    @IBOutlet var regularMenuLabel: UILabel!
    @IBOutlet var veganMenuLabel: UILabel!
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    
    @IBOutlet var guestsOnTableTableView: UITableView!
    
    var guestLists = [GuestModel]()
    var guestList = [String]()
    var menuList = [String]()
    var tableData: TableModel?
    var refGuests:DatabaseReference!
    var refGuestsMenu:DatabaseReference!
    let uid = Auth.auth().currentUser?.uid
    var updatedGuestList: [String] = []
    
  //  var ref: DatabaseReference!
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guestsOnTableTableView.delegate = self
        guestsOnTableTableView.dataSource = self
        viewSetUp()
        tableNameAndNo()
        menuCount()
        guestList = tableData?.guests ?? [String]()
        self.navigationController?.navigationBar.isHidden = false
        reloadTableView()
       // guestsOnTableTableView.reloadData()
        guestsOnTableTableView.separatorStyle = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }
    
    func tableNameAndNo(){
        
        let tableNo = tableData?.tableNo
        let tableName = tableData?.tableName
        tableNoLabel.text = "Table No." + " " + tableNo!
        tableNameLabel.text = tableName!
        
    }
    
    func menuCount(){
        menuList = tableData?.menus ?? [String]()
        let regularMenu = menuList.filter ({$0 == "regular"}).count
        let veganMenu = menuList.filter ({$0 == "vegan"}).count
        regularMenuLabel.text = "Regular menu: \(regularMenu)"
        veganMenuLabel.text = "Vegan menu: \(veganMenu)"
    }
    
    func viewSetUp(){
        firstView.layer.cornerRadius = 20
        secondView.layer.cornerRadius = 20
        firstView.layer.masksToBounds = true
        secondView.layer.masksToBounds = true
    }
    
    func reloadTableView() {
        guestList.removeAll()
        if let tableId = tableData?.id {
            
            Database.database().reference().child("userInfo").child(uid!).child("tables").child(tableId).child("guestsOnTable").queryOrderedByKey().observe(.value) { (snapshot) in
                if snapshot.childrenCount>0 {
                    self.guestList.removeAll()
                    
                    for guest in snapshot.children.allObjects as![DataSnapshot]{
                        if let guestObject = guest.value as? String{
                            self.guestList.append(guestObject)
                        }
                    }
                    DispatchQueue.main.async {
                        self.guestsOnTableTableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestsCell", for: indexPath) as! GuestListOnTableTableViewCell
        
        let guest = guestList[indexPath.row]
        
        cell.guestNameLabel.text = guest
        return cell
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete from table"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
         
            
            let guestName = guestList[indexPath.row]
            let guestMenu = menuList[indexPath.row]
            if let tableId = tableData?.id{
                refGuests = Database.database().reference().child("userInfo").child(uid!).child("tables").child(tableId).child("guestsOnTable")
                refGuests.observe(.value) { (snapshot, error) in
                    
                    if let error = error {
                        print(error.description)
                    }
                    if let guests = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        
                        for (index,guest) in guests.enumerated() {
                            if let guestObject = guest.value as? String {
                                if guestObject == guestName {
                                    self.guestList.remove(at: index)
                                    self.refGuests.setValue(self.guestList)
                                    DispatchQueue.main.async {
                                        self.guestsOnTableTableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
                refGuestsMenu = Database.database().reference().child("userInfo").child(uid!).child("tables").child(tableId).child("menu")
                refGuestsMenu.observe(.value) { (snapshot, error) in
                    
                    if let error = error {
                        print(error.description)
                    }
                    if let guests = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        
                        for (index1,guest) in guests.enumerated() {
                            if let guestObject = guest.value as? String {
                                if guestObject == guestMenu {
                                    self.menuList.remove(at: index1)
                                    self.refGuestsMenu.setValue(self.menuList)
                                    
                                }
                            }
                        }
                    }
                }
            }
    }
}
}
