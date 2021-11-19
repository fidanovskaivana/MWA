//
//  AddTableViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/17/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase

class AddTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    
    @IBOutlet var tableCapacityTextField: UITextField!
    @IBOutlet var guestLabel: UILabel!
    @IBOutlet var guestSeatedOnTableLabel: UILabel!
    @IBOutlet var tableNoLabel: UILabel!
    @IBOutlet var addTableLabel: UILabel!
    @IBOutlet var entertableNameTextField: UITextField!
    @IBOutlet var enterTableNumber: UITextField!
    
    
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var pinkLabel: UILabel!
    
    @IBOutlet var tableTableView: UITableView!
    
    let uid = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    var refGuest: DatabaseReference!

    var guestList = [GuestModel]()
    var guests = [GuestModel]()
    var filteredList = [GuestModel]()
    var indexArray: [String] = []
    var indexNameArray: [String] = []
    var indexMenu: [String] = []
//    var indexTableNo: [String] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTableView.separatorStyle = .none
        tableTableView.delegate = self
        tableTableView.dataSource = self
        showGuestList()
        labelsSetUp()
        initSearchController()
        setUpNavigationBar()
        showTableNo()
        self.tableTableView.allowsMultipleSelection = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }
    
    
    //MARK: Functions
    
    func getFirstChild() {
        let usersRef = self.ref.child("userInfo").child(uid!).child("guests")
        usersRef.observeSingleEvent(of: .childAdded, with: { snapshot in
            
            print(snapshot.key)
        })
    }

    
    func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        UINavigationBar.appearance().backgroundColor = .clear
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func initSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableTableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 0.475, blue: 0.475, alpha: 1)]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContent(searchText: self.searchController.searchBar.text!)
    }
    
    func setFilter(filterText: String){
        filteredList = guestList.filter({ (guest) -> Bool in
            
            let attending = guest.attendingStatus
            return (attending?.uppercased().contains(filterText.uppercased()))!
        })
    }
    
    func filteredContent(searchText: String){
        filteredList = guestList.filter({ (user) -> Bool in
            let guestNamef = user.guestName
            let guestFamName = user.guestFamilyName
            
            return (guestNamef?.lowercased().contains(searchText.lowercased()))! || (guestFamName?.lowercased().contains(searchText.lowercased()))!
        })
        tableTableView.reloadData()
    }
    
    func labelsSetUp(){
        greenLabel.layer.cornerRadius = 20
        pinkLabel.layer.cornerRadius = 20
        greenLabel.layer.masksToBounds = true
        pinkLabel.layer.masksToBounds = true
    }
        
    func addTable(){
        ref = Database.database().reference().child("userInfo").child(uid!).child("tables")
        
        //        var tableRef = ref
//        tableRef = Database.database().reference().child("userInfo").child(uid!).child("guests")
//
//        guard let tableKey = tableRef?.childByAutoId().key else {
//           return
//        }
//        let tableNo = ["tableNo" : enterTableNumber.text! as String]
//        let childUpdates = ["\(tableKey)" : tableNo]
//
        
        let key = ref.childByAutoId().key
        
        let table = ["id": key ?? "X", "tableName": entertableNameTextField.text! as String, "tableCapacity": tableCapacityTextField.text! as String, "tableNo": enterTableNumber.text! as String, "guestsOnTable" : indexArray as [String], "menu": indexMenu as [String]] as [String : Any]
        
       
        
      //  tableRef?.updateChildValues(childUpdates)
        ref.child(key!).setValue(table)
        
    }
    
    func showGuestList(){
        ref = Database.database().reference().child("userInfo").child(uid!).child("guests")
        ref.queryOrdered(byChild: "attending").queryEqual(toValue: "attending").observe(.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.guestList.removeAll()
                
                for guests in snapshot.children.allObjects as![DataSnapshot]{
                    let guestObject = guests.value as? [String: AnyObject]
                    let guestName = guestObject?["guestName"]
                    let guestFamilyName = guestObject?["guestFamilyName"]
                    let menu = guestObject?["menu"]
                    let tableNo = guestObject?["tableNo"]
                    let guest = GuestModel(guestName: guestName as? String, guestFamilyName: guestFamilyName as? String, menu: menu as? String, tableNo: tableNo as? String)
                    
                    self.guestList.append(guest)
                }
                DispatchQueue.main.async {
                    self.tableTableView.reloadData()
                }
            }
        }
    }
    
   

    
    func showTableNo(){
        ref = Database.database().reference().child("userInfo").child(uid!).child("tables").child("guestsOnTable")
        ref.queryOrderedByKey().observe(.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.guestList.removeAll()
                
                for guests in snapshot.children.allObjects as![DataSnapshot]{
                    let guestObject = guests.value as? [String: AnyObject]
                    let tableNo = guestObject?["tableNo"]
                    
                    let guest = GuestModel(tableNo: tableNo as? String)
                    
                    self.guestList.append(guest)
                }
                DispatchQueue.main.async {
                    self.tableTableView.reloadData()
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredList.count
            
        }else{
            
            return guestList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestListCell", for: indexPath) as! GuestListToTableTableViewCell
        var guest: GuestModel
        guest = guestList[indexPath.row]
        
        if searchController.isActive && searchController.searchBar.text != "" {
            guest = filteredList[indexPath.row]
        }else{
            guest = guestList[indexPath.row]
        }
        
        cell.fullNameLabel.text = guest.guestName! + " " + guest.guestFamilyName!
//        cell.tableNoLabel.text = guest.tableNo
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let guest:GuestModel
        guest = guestList[indexPath.row]
        
        let guestName = guest.guestName
        let familyName = guest.guestFamilyName
        let guestMenu = guest.menuStatus
//        let tableNoGuest = guest.tableNo
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        indexArray.append(guestName! + " " + familyName!)
        indexMenu.append(guestMenu!)
        indexNameArray.append(guestName!)
//        indexTableNo.append(tableNoGuest!)
    }
  
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
    }
    
   
    //MARK: Actions

    @IBAction func saveActionButton(_ sender: Any) {
        
        addTable()

        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}


