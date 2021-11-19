//
//  ToDoEventModel.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 2/4/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import Foundation
class ToDoEventModel {
    
    var event: String?
    var id: String?
    var toDoDate: String?
   
    init(eventName: String?, id: String?, toDoDate: String?){
        self.event = eventName
        self.id = id
        self.toDoDate = toDoDate
      
    }
    
}
