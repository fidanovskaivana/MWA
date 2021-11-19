//
//  TablesPlanCollectionViewCell.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 2/2/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import UIKit

class TablesPlanCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet var tableNoLabel: UILabel!
    @IBOutlet var tableName: UILabel!
    @IBOutlet var regularMenuLabel: UILabel!
    @IBOutlet var veganMenuLabel: UILabel!
    @IBOutlet var tableCapacityLabel: UILabel!
    
    @IBOutlet var checkMarkLabel: UILabel!
    
    var isInEditingMode: Bool = false {
        didSet {
            checkMarkLabel.isHidden = !isInEditingMode
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isInEditingMode{
                checkMarkLabel.text = isSelected ? "✓" : ""

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
