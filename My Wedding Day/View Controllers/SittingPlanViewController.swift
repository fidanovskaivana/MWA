//
//  SittingPlanViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/15/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase

class SittingPlanViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var tablesCollectionView: UICollectionView!
    @IBOutlet var partner1Label: UILabel!
    @IBOutlet var partner2Label: UILabel!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!

    
    var tables = [TableModel]()
    var refTables:DatabaseReference!
    let uid = Auth.auth().currentUser?.uid
    let cellIdentifier = "TablesPlanCollectionViewCell"
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isEnabled = false
        showTableDetails()
        tablesCollectionView.delegate = self
        tablesCollectionView.dataSource = self
        setUpCollectionView()
        partner1Guests()
        partner2Guests()
        labelsSetUp()
        setUpNavigationBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpCell()
    }
    
      //-MARK: Functions
    
    func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = editButtonItem
        UINavigationBar.appearance().backgroundColor = .clear
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func labelsSetUp(){
    partner1Label.layer.cornerRadius = 20
    partner2Label.layer.cornerRadius = 20
    partner1Label.layer.masksToBounds = true
    partner2Label.layer.masksToBounds = true
    }
    
    private func setUpCell(){
        if collectionViewFlowLayout == nil {
            let numberOfItemPerRow: CGFloat = 2
            let lineSpacing: CGFloat = 30
            let interItemSpacing: CGFloat = 30
            let width = (tablesCollectionView.frame.width - (numberOfItemPerRow - 1) * interItemSpacing) / numberOfItemPerRow
            let hight = width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: hight)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            tablesCollectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    private func setUpCollectionView(){
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tablesCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tablesCollectionView.allowsMultipleSelection = editing
        let indexPaths = tablesCollectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = tablesCollectionView.cellForItem(at: indexPath) as! TablesPlanCollectionViewCell
            cell.isInEditingMode = editing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TablesPlanCollectionViewCell
        
        let tableNo: TableModel
        tableNo = tables[indexPath.row]
        let menuList = tableNo.menus ?? [String]()
        let regularMenu = menuList.filter ({$0 == "regular"}).count
        let veganMenu = menuList.filter ({$0 == "vegan"}).count
        let capacity = tableNo.tableCapacity
        let seatedGuests = regularMenu + veganMenu
        
        cell.veganMenuLabel.text = "Vegan menu: \(veganMenu)"
        cell.regularMenuLabel.text = "Regular menu: \(regularMenu)"
        cell.tableName.text = tableNo.tableName
        cell.tableCapacityLabel.text = "Capacity:" + " \(seatedGuests)" + "/" + capacity!
        cell.tableNoLabel.text = tableNo.tableNo
        cell.layer.cornerRadius = min(cell.frame.size.height, cell.frame.size.width) / 2.0
        cell.isInEditingMode = isEditing

       if indexPath.row % 2 == 0 {
           cell.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 0.8509803922, alpha: 1)
       }else{
           cell.backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.8823529412, blue: 0.7803921569, alpha: 1)
       }
        return cell
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select: \(indexPath)")

        if !isEditing{
            deleteButton.isEnabled = false
            
            let selectedTable = tables[indexPath.row]
            let controller = self.storyboard?.instantiateViewController(identifier: "tableDetails") as! TableDetailsViewController
            
            controller.tableData = selectedTable
            
            self.present(controller, animated: true, completion: nil)
            
            tablesCollectionView.deselectItem(at: indexPath, animated: true)
            
        }else{
            deleteButton.isEnabled = true
        }
    }

      func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deleteButton.isEnabled = false
        }
    }

    func showTableDetails(){
        refTables = Database.database().reference().child("userInfo").child(uid!).child("tables")

        refTables.queryOrderedByKey().observe(.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.tables.removeAll()
                for tables in snapshot.children.allObjects as![DataSnapshot]{
                    let tableObject = tables.value as? [String : AnyObject]
                    let tableNo = tableObject?["tableNo"]
                    let tableName = tableObject?["tableName"]
                    let regularMenu = tableObject?["regularMenu"]
                    let veganMenu = tableObject?["veganMenu"]
                    let numberOfGuests = tableObject?["numberOfGuests"]
                    let tableCapacity = tableObject?["tableCapacity"]
                    let id = tableObject?["id"]
                    let guests = tableObject?["guestsOnTable"] as? [String]
                    let menus = tableObject?["menu"] as? [String]
                       
                    let table = TableModel(tableNo: tableNo as? String, tableName: tableName as? String, regularMenu: regularMenu as? String, veganMenu: veganMenu as? String, numberOfguests: numberOfGuests as? String, tableCapacity: tableCapacity as? String, id: id as? String, guests: guests, menus: menus)
                    
                    self.tables.append(table)

                }
                DispatchQueue.main.async {
                    self.tablesCollectionView.reloadData()
                }
            }
        }
    }
    
    func partner1Guests(){
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("userInfo").child(uid!)
        ref.child("guests").queryOrdered(byChild: "partnerSide").queryEqual(toValue: "partner1").observe(.value) { snapshot in
            
            let partner1guests = snapshot.childrenCount
            self.partner1Label.text = "Partner 1: \n\(partner1guests) guests invited"
            print(snapshot.childrenCount)
        }
    }
    
    func partner2Guests(){
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("userInfo").child(uid!)
        ref.child("guests").queryOrdered(byChild: "partnerSide").queryEqual(toValue: "partner2").observe(.value) { snapshot in
            let partner2guests = snapshot.childrenCount
            self.partner2Label.text = "Partner 2: \n\(partner2guests) guests invited"
            print(snapshot.childrenCount)
        }
    }
    
    func deleteTable(id: String){
              refTables.child(id).setValue(nil)
              self.tablesCollectionView.reloadData()
          }
 
    //-MARK: Actions
    @IBAction func deleteItem(_ sender: Any) {
        
        if let selectedCells = tablesCollectionView.indexPathsForSelectedItems{
            let items = selectedCells.map {$0.item}.sorted().reversed()
            var toDeleteIds = [String]()
    
            for item in items {
                
                let tableNo = tables[item]
                toDeleteIds.append(tableNo.id!)
                
                refTables = Database.database().reference().child("userInfo").child(uid!).child("tables")
                refTables.child(tableNo.id!).removeValue { error,arg  in
                   if error != nil {
                       print("error \(error)")
                   }
                 }
            }
            tables.removeAll {toDeleteIds.contains($0.id!)}
            deleteButton.isEnabled = false
            self.tablesCollectionView.reloadData()
        }
        
    }
    
    @IBAction func addTableButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "addTableSegue", sender: nil)
    }
}

extension String {
    var number: String {
        return filter { "0"..."9" ~= $0 }
    }
}





