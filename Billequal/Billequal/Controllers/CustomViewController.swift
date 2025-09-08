//
//  CustomViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/21/25.
//

import UIKit

class CustomViewController: UIViewController {
    
    var billValues: Bill?
    var billequalBrain = BillequalBrain()
    var leftAmount = 0.0
    
    @IBOutlet var totalTextField: UITextField!
    @IBOutlet var tipsTextField: UITextField!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bill = billValues {
            totalTextField.text = String(format: "%.2f", bill.total)
            tipsTextField.text = String(format: "%.0f", bill.tips) + "%"
            
            leftAmount = bill.total
            leftLabel.text = "Left: " + String(format: "%.2f", leftAmount)
        }
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // create toolbar to keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // create flexible space (to push Done button to the right)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // create Done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        doneButton.tintColor = #colorLiteral(red: 0.4117647059, green: 0.7098039216, blue: 0.7450980392, alpha: 1)
        toolbar.items = [flexSpace, doneButton]
            
        // assign toolbar to your textField
        totalTextField.inputAccessoryView = toolbar
        
        // to dismiss keybord
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Keyboard
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        total = Double(totalTextField.text!) ?? 0.0
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true) // closes keyboard for any active textField
    }
                                                                        
    @objc func dismissKeyboard() {
        view.endEditing(true)
        }
    @IBAction func restartPressed(_ sender: UIButton) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
    

extension CustomViewController: UITableViewDataSource, CalculateCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billValues?.pplNumber ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CalculateCell
        
        cell.personTextField.text = "Person \(indexPath.row + 1)"
        cell.personTextField.placeholder = "Person \(indexPath.row + 1)"
        
        cell.resultLabel.text = "00.00"
        cell.resultWithTips.text = "00.00"
        
        cell.delegate = self
        
        return cell
    }
    
    // text from textView of the custom cell and calculate total to pay, to pay with tips
    func didUpdateCalculationText(_ text: String, in cell: CalculateCell) {
        if let totalFromBrain = billequalBrain.evaluateExpression(text) {
            let totalWithTips = totalFromBrain + totalFromBrain * (billValues?.tips ?? 0.0) / 100
            leftAmount -= totalFromBrain
            cell.resultLabel.text = String(format: "%.2f", totalFromBrain)
            cell.resultWithTips.text = String(format: "%.2f", totalWithTips)
            leftLabel.text = "Left: " + String(format: "%.2f", leftAmount)
            cell.CalculationTextView.textColor = .label // reset to normal color
        } else {
            cell.CalculationTextView.textColor = .red
            cell.resultLabel.text = "Error"
            cell.resultWithTips.text = ""
            print("⚠️ Invalid expression")
        }
    }
}
