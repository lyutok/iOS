//
//  CalculateCell.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/25/25.
//

import UIKit

class CalculateCell: UITableViewCell {
    
    @IBOutlet var personTextField: UITextField!
    @IBOutlet var calculationLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var resultWithTips: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
