//
//  BudgetTableViewCell.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 2/1/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {
    
    
    @IBOutlet var nameEventLabel: UILabel!
    @IBOutlet var spentBudgetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
