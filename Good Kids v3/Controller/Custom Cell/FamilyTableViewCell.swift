//
//  FamilyTableViewCell.swift
//  Good Kids v3
//
//  Created by Aleksandr Ozhogin on 12/3/20.
//  Copyright © 2020 Aleksandr Ozhogin. All rights reserved.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UILabel!  
    @IBOutlet weak var userTypeTextField: UILabel!
    @IBOutlet weak var scoreTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
}
