//
//  CalculateCell.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/25/25.
//

import UIKit

protocol CalculateCellDelegate: AnyObject {
    func didUpdateCalculationText(_ text: String, in cell: CalculateCell)
}

class CalculateCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var personTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var resultWithTips: UILabel!
    
    @IBOutlet var CalculationTextView: UITextView!
    weak var delegate: CalculateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CalculationTextView.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didUpdateCalculationText(textView.text ?? "", in: self)
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class NoMenuTextView: UITextView {
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return false // disables all actions (copy/paste/select/etc.)
        }
    }

    
}
