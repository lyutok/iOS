//
//  TableViewCell.swift
//  Keyboard
//
//  Created by Lyudmila Tokar on 8/31/25.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet var calculationLable: UILabel!
    @IBOutlet var totalLable: UILabel!
    @IBOutlet var withTips: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
