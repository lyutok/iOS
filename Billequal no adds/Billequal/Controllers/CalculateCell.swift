//
//  CalculateCell.swift
//  Billequal
//
//  Created by Liudmyla Tokar on 8/25/25.
//

import UIKit

protocol CalculateCellDelegate: AnyObject {
    func tapCalculateOnCell(in cell: CalculateCell)
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
    
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.string = """
            \(personLabel.text ?? "")
            Subtotal: \(resultLabel.text ?? "")
            With tips: \(resultWithTipsLabel.text ?? "")
            
            — Billequal • Making splits simple
            """
        // Animate to "Copied ☑️"
            UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve) {
                sender.setTitle("☑️", for: .normal)
            }

        // Reset after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve) {
                sender.setTitle("Copy", for: .normal)
            }
        }
    }
    
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        delegate?.tapCalculateOnCell(in: self)
    }
}


