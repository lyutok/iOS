//
//  ViewController.swift
//  Billequal
//
//  Created by Liudmyla Tokar on 8/15/25.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var totalTextField: UITextField!
    @IBOutlet var addTipsLabel: UILabel!
    @IBOutlet var percButtons: [UIButton]!
    @IBOutlet var customPercTextField: UITextField!
    @IBOutlet var pplTextField: UITextField!
    
    var brain = BillequalBrain()
    
    var total: Double = 0.0
    var pplNumber: Int = 1
    var tips: Double = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // apply textFields styles
        styleTextField(customPercTextField)
        styleTextField(pplTextField)
        customPercTextField.font = UIFont(name: "OpenSans-Semibold", size: 17)
        pplTextField.font = UIFont(name: "OpenSans-Semibold", size: 22)
        
        // apply % buttons style
        stylePercButtons()
        
        totalTextField.delegate = self
        customPercTextField.delegate = self
        pplTextField.delegate = self
        
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
        customPercTextField.inputAccessoryView = toolbar
        pplTextField.inputAccessoryView = toolbar
        
        // to dismiss keybord
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK: - Style of Buttons %
    func stylePercButtons() {
        for button in percButtons {
            // Rounded corners
            button.layer.cornerRadius = 12
            button.clipsToBounds = true
            
//            applyGradient(to: button)
            
            // Border
            button.layer.borderWidth = 1
            button.layer.borderColor = #colorLiteral(red: 0.4117647059, green: 0.7098039216, blue: 0.7450980392, alpha: 1)
            
            // Background color
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            // Title color
            button.setTitleColor(UIColor(named: K.customMainFontColor), for: .normal)
            
            // Font
            button.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 17)
        }
    }
    
    //MARK: - Style of TextField
    
    func styleTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.4117647059, green: 0.7098039216, blue: 0.7450980392, alpha: 1)
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.textColor = UIColor(named: K.customMainFontColor)
        // placeholder color
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [
                .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            ]
        )

    }
    
    //MARK: - Get tips from the string
    
    func extractTip(_ labelText: String) -> Double {
        let number = labelText
            .replacingOccurrences(of: "Add Tips: ", with: "")
            .replacingOccurrences(of: " %", with: "")
        return Double(number) ?? 0
    }
    
    //MARK: - Keyboard
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set curson to the end when editing
        let endPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        
        if textField == customPercTextField {
            customPercTextField.text = ""    // Clears previous value
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // If custom percentage field was edited
        if textField == customPercTextField {
            if let value = Int(customPercTextField.text!) {
                addTipsLabel.text = "Add Tips: \(value) %"
                customPercTextField.text = "\(value) %"
                
                // Reset all buttons to default color
                for button in percButtons {
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                customPercTextField.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.8274509804, blue: 0.8509803922, alpha: 1)
            }
        }
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true) // closes keyboard for any active textField
    }
                                                                        
    @objc func dismissKeyboard() {
        view.endEditing(true)
        }
    
    //MARK: - Actions
    
    @IBAction func percButtonPressed(_ sender: UIButton) {
        // Reset CustomField
        customPercTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        customPercTextField.text = ""
        
        if sender.backgroundColor == #colorLiteral(red: 0.6470588235, green: 0.8274509804, blue: 0.8509803922, alpha: 1){
            sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addTipsLabel.text = "Add Tips: 0 %"
        } else {
            
            for button in percButtons {
                // Reset all buttons to default color
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            
            // Highlight the pressed button
            sender.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.8274509804, blue: 0.8509803922, alpha: 1)
            addTipsLabel.text = "Add Tips: \(sender.titleLabel!.text!)"
        }
    }

    @IBAction func equalSplitButtonPressed(_ sender: UIButton) {
        // get values
        total = Double(totalTextField.text!) ?? 0.0
        pplNumber = Int(pplTextField.text!) ?? 1
        tips = extractTip(addTipsLabel.text ?? "Add Tips: 0 %")
        
        view.endEditing(true)   // hides keyboard for ANY active field
        
        brain.createBill(total: total, pplNumber: pplNumber, tips: tips)
        
        performSegue(withIdentifier: K.calculateSegueIdentifier, sender: self)
    }
    
    
    @IBAction func customButtonPressed(_ sender: UIButton) {
        // get values
        total = Double(totalTextField.text!) ?? 0.0
        pplNumber = Int(pplTextField.text!) ?? 1
        tips = extractTip(addTipsLabel.text ?? "Add Tips: 0 %")
        
        brain.createBill(total: total, pplNumber: pplNumber, tips: tips)
        performSegue(withIdentifier: K.customSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.calculateSegueIdentifier {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.billValues = brain.bill
        } else if segue.identifier == K.customSegueIdentifier {
            let destinationVC = segue.destination as! CustomViewController
            destinationVC.billValues = brain.bill
        }
    }
}
