//
//  ToDoViewController.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 12/15/20.
//  Copyright © 2020 Fidanovska. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet var toDoTableView: UITableView!
    
    var ref: DatabaseReference!
    let uid = Auth.auth().currentUser?.uid
    var toDos = [ToDoEventModel]()
    let setDatePicker = UIDatePicker()
    var tableSource = [String]()
    var toDoAlert: UIAlertController = UIAlertController()
    let dateFormatter = DateFormatter()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        toDoTableView.separatorStyle = .none
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.rowHeight = 90
        ref = Database.database().reference().child("userInfo").child(uid!).child("ToDoList")
        showToDos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stopLoader(loader: loader)
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
            1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDos.count
           
       }
   
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! ToDoTableViewCell
        
        let toDo: ToDoEventModel
        toDo = toDos[indexPath.row]
        cell.taskLabel.text = toDo.event
        cell.dateLabel.text = toDo.toDoDate
        
        return cell
        
       }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDo = toDos[indexPath.row]
            toDos.remove(at: indexPath.row)
            toDoTableView.reloadData()
            self.deleteToDoTask(id: toDo.id!)
            
        }
    }
    
    func deleteToDoTask(id: String){
        ref.child(id).setValue(nil)
        self.toDoTableView.reloadData()
    }
    
    func showToDos(){
        ref = Database.database().reference().child("userInfo").child(uid!).child("ToDoList")
        ref.queryOrderedByKey().observe(.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.toDos.removeAll()
                
                for toDoEvents in snapshot.children.allObjects as! [DataSnapshot]{
                    let toDoObject = toDoEvents.value as? [String: AnyObject]
                    let toDoEvent = toDoObject?["toDo"]
                    let id = toDoObject?["id"]
                    let toDoDate = toDoObject?["toDoDate"]
                    
                    let toDo = ToDoEventModel(eventName: toDoEvent as? String, id: id as? String, toDoDate: toDoDate as? String)
                    
                    self.toDos.append(toDo)
                }
                DispatchQueue.main.async {
                    self.toDoTableView.reloadData()
                }
                
            }
    }
    }
    

    @IBAction func addNewTaskButtonAction(_ sender: Any) {
        
        toDoAlert = UIAlertController(title: "Add ToDo", message: "Add a new task", preferredStyle: .alert)

        toDoAlert.addTextField()
        toDoAlert.addTextField { textField in

           textField.inputView = self.setDatePicker
            self.setDatePicker.preferredDatePickerStyle = .wheels
        
           let toolBar = UIToolbar()
           toolBar.barStyle = .default
           toolBar.isTranslucent = true
           toolBar.isUserInteractionEnabled = true
           toolBar.sizeToFit()

           let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onClickDoneButton))
            toolBar.setItems([doneButton], animated: true)
            textField.inputAccessoryView = toolBar

            self.toDoAlert.textFields![1].placeholder = "Set date"
           
       }

        let subview = (toDoAlert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView

        let shapes = UIView()
        shapes.layer.cornerRadius = 30
        shapes.layer.borderWidth = 5
        shapes.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 0.8509803922, alpha: 1)
        subview.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9333333333, blue: 0.9176470588, alpha: 1)
        subview.tintColor = #colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 0.8509803922, alpha: 1)
        toDoAlert.view.tintColor = #colorLiteral(red: 0.4431372549, green: 0.4431372549, blue: 0.4431372549, alpha: 1)

        let addToDoAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if  let newToDo = self.toDoAlert.textFields![0].text, let toDoDate = self.toDoAlert.textFields![1].text, newToDo.count > 0 {
                let key = self.ref.childByAutoId().key
                let toDo = ["id":key, "toDo": newToDo, "toDoDate" : toDoDate]
                self.ref.child(key!).setValue(toDo)
                self.toDos.append(contentsOf: self.toDos)
                self.toDoTableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        toDoAlert.addAction(addToDoAction)
        toDoAlert.addAction(cancelAction)

        present(toDoAlert, animated: true, completion: nil)
    }
    
    @objc func onClickDoneButton() {

        self.dateFormatter.dateFormat = "dd-MM-yyyy HH:mm a"

        toDoAlert.textFields?.last?.text = dateFormatter.string(from: setDatePicker.date)
        
        self.view.endEditing(true)
    }
    
}
