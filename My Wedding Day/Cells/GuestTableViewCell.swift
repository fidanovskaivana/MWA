//
//  GuestTableViewCell.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 1/14/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import UIKit

class GuestTableViewCell: UITableViewCell {
    

    @IBOutlet var guestNameLabel: UILabel!
    @IBOutlet var attendingLabel: UILabel!
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var tableNo: UILabel!
    
      var isClicked = true
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}
