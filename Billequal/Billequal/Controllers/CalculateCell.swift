//
//  CalculateCell.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/25/25.
//

import UIKit

protocol CalculateCellDelegate: AnyObject {
    func didTapCalculate(in cell: CalculateCell)
}

class CalculateCell: UITableViewCell {
    
    @IBOutlet var personLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var resultWithTipsLabel: UILabel!
    
    weak var delegate: CalculateCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        delegate?.didTapCalculate(in: self)
    }
}


