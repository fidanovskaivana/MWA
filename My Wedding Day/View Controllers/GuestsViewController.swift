//
//  GuestsViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/15/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase

class GuestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{

    @IBOutlet var guestsTableView: UITableView!
    
    var refGuests:DatabaseReference!
    var guestsList = [GuestModel]()
    var filteredList = [GuestModel]()
    let uid = Auth.auth().currentUser?.uid
    let isClicked = true
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        guestsTableView.separatorStyle = .none
        guestsTableView.delegate = self
        guestsTableView.dataSource = self
        initSearchController()
        showGuests()
    }

    
    //-MARK: Functions
       

    func initSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        guestsTableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 0.475, blue: 0.475, alpha: 1)]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContent(searchText: self.searchController.searchBar.text!)
    }
    
    func setFilter(filterText: String){
        filteredList = guestsList.filter({ (guest) -> Bool in
           
            let attending = guest.attendingStatus
                 return (attending?.uppercased().contains(filterText.uppercased()))!
        })
    }
    
    func filteredContent(searchText: String){
        filteredList = guestsList.filter({ (user) -> Bool in
            let guestNamef = user.guestName
            let guestFamName = user.guestFamilyName
            let guestStatus = user.attendingStatus
            
            return (guestNamef?.lowercased().contains(searchText.lowercased()))! || (guestFamName?.lowercased().contains(searchText.lowercased()))! ||
                (guestStatus?.lowercased().contains(searchText.lowercased()))!
        })
        guestsTableView.reloadData()
    }
    
    
    func showGuests(){
        refGuests = Database.database().reference().child("userInfo").child(uid!).child("guests")
        refGuests.queryOrderedByKey().observe(.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.guestsList.removeAll()
                
                for guests in snapshot.children.allObjects as![DataSnapshot]{
                    let guestObject = guests.value as? [String: AnyObject]
                    let guestName = guestObject?["guestName"]
                    let guestFamilyName = guestObject?["guestFamilyName"]
                    let attendingStatus = guestObject?["attending"]
                    let menuStatus = guestObject?["menu"]
                    let ageStatus = guestObject?["age"]
                    let tableNo = guestObject?["tableNo"]
                    let id = guestObject?["id"]
                    let phoneNumber = guestObject?["guestPhoneNumber"]
                    let email = guestObject?["guestEmail"]
                    
                    let guest = GuestModel(guestName: guestName as? String, guestFamilyName: guestFamilyName as? String, attendingStatus: attendingStatus as? String, menuStatus: menuStatus as? String, ageStatus: ageStatus as? String, TableNo: tableNo as? String, id: id as? String, guestPhoneNumber: phoneNumber as? String, guestEmail: email as? String)
                    
                    self.guestsList.append(guest)
                }
                
                DispatchQueue.main.async {
                    self.guestsTableView.reloadData()
                }
            }
        }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredList.count
            
        }else{
            
        return guestsList.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath) as! GuestTableViewCell
        
        let guest: GuestModel
        if searchController.isActive && searchController.searchBar.text != "" {
            guest = filteredList[indexPath.row]
        }else{
            guest = guestsList[indexPath.row]
        }
        
        cell.guestNameLabel.text = guest.guestName! + " " + guest.guestFamilyName!
        cell.attendingLabel.text = guest.attendingStatus
        cell.menuLabel.text = guest.menuStatus
        cell.ageLabel.text = guest.ageStatus
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedGuest = guestsList[indexPath.row]
        let controller = self.storyboard?.instantiateViewController(identifier: "GuestDetail") as! GuestDetailsViewController
        controller.guestUser = selectedGuest
       self.present(controller, animated: true, completion: nil)
        guestsTableView.deselectRow(at: indexPath, animated: true)

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let guest = guestsList[indexPath.row]
            self.guestsList.remove(at: indexPath.row)
            self.guestsTableView.reloadData()
            self.deleteGuest(id: guest.id!)
        }
    }
    
    func deleteGuest(id: String){
        refGuests.child(id).setValue(nil)
        self.guestsTableView.reloadData()
    }
    

    //-MARK: Actions
    
    @IBAction func addGuestButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "addGuestSegue", sender: nil)
    }
}


    
    
