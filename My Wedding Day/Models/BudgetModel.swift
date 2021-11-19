//
//  BudgetModel.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 2/1/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import Foundation

class BudgetModel {
    var id: String?
    var eventName: String?
    var spentBudget: String?
    
    init(eventName: String?, spentBudget: String?, id: String?){
        self.eventName = eventName
        self.spentBudget = spentBudget
        self.id = id
    }
    
}
