//
//  GuestListToTableTableViewCell.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 1/26/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import UIKit

class GuestListToTableTableViewCell: UITableViewCell {
    
    
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var attendingStatusLabel: UILabel!
    @IBOutlet var tableNoLabel: UILabel!
    
    var isClicked = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
