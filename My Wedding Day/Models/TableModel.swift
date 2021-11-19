//
//  TableModel.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 1/21/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import Foundation

class TableModel {
    
    var tableNo: String?
    var tableName: String?
    var regularMenu: String?
    var veganMenu: String?
    var numberOfGuests: String?
    var tableCapacity: String?
    var id: String?
    var guests: [String]?
    var menus: [String]?
   
    init(guests: [String]?){
    self.guests = guests
    }
    
    init(menus: [String]?){
        self.menus = menus
    }
    
    init(tableNo: String?, tableName: String?, regularMenu: String?, veganMenu: String?, numberOfguests: String?, tableCapacity: String?, id: String?, guests: [String]?, menus: [String]?){
        
        self.tableNo = tableNo
        self.tableName = tableName
        self.regularMenu = regularMenu
        self.veganMenu = veganMenu
        self.numberOfGuests = numberOfguests
        self.tableCapacity = tableCapacity
        self.id = id
        self.guests = guests
        self.menus = menus
        
    }
    
}
