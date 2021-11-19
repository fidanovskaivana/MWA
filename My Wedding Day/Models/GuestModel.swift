//
//  GuestModel.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 1/14/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import Foundation
import Firebase


class GuestModel {
    
    var guestName: String?
    var attendingStatus: String?
    var menuStatus: String?
    var ageStatus: String?
    var tableNo: String?
    var id: String?
    var guestFamilyName: String?
    var guestPhoneNumber: String?
    var guestEmail: String?
    var menu: Int?
    var key: String!
    var guestTableNo: String?
    
    
    init(guestName: String?, guestFamilyName: String?, attendingStatus: String?, menuStatus: String?, ageStatus: String?, TableNo: String?, id: String?, guestPhoneNumber: String?, guestEmail: String?){
        
        self.guestName = guestName
        self.guestFamilyName = guestFamilyName
        self.attendingStatus = attendingStatus
        self.menuStatus = menuStatus
        self.ageStatus = ageStatus
        self.tableNo = TableNo
        self.id = id
        self.guestEmail = guestEmail
        self.guestPhoneNumber = guestPhoneNumber
       
    }
    init(guestName: String?, guestFamilyName: String, guestPhoneNumber: String?, guestEmail: String?){
        self.guestName = guestName
        self.guestFamilyName = guestFamilyName
        self.guestPhoneNumber = guestPhoneNumber
        self.guestEmail = guestEmail
    }
    
    init(guestName: String?, guestFamilyName: String?, menu: String?, tableNo: String?){
        self.guestName = guestName
        self.guestFamilyName = guestFamilyName
        self.menuStatus = menu
        self.tableNo = tableNo
      //  self.guestTableNo = guestTableNo
    }
    init(guestName: String?) {
        self.guestName = guestName
    }
    init(menu: Int){
        self.menu = menu
    }
    
    init(key:String = "",
         guestName: String){
        self.key = key
        self.guestName = guestName
    }
    init(tableNo: String?){
        self.tableNo = tableNo
    }
}
