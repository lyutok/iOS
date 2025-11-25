//
//  ViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/15/25.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var totalTextField: UITextField!
    
    @IBOutlet var fivePercSwitch: UISwitch!
    @IBOutlet var tenPercSwitch: UISwitch!
    @IBOutlet var fifteenPercSwitch: UISwitch!
    @IBOutlet var twentyPercSwitch: UISwitch!
    @IBOutlet var twentyFivePercSwitch: UISwitch!
    
    var switches: [UISwitch: Double] = [:]
    let numbersForUIPicker = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]
    
    var brain = BillequalBrain()
    
    var total: Double = 0.0
    var pplNumber: Int = 5
    var tips: Double = 10.0

    
    @IBOutlet var peopleUIPicker: UIPickerView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        switches = [fivePercSwitch: 5.0, tenPercSwitch: 10.0, fifteenPercSwitch: 15.0, twentyPercSwitch: 20.0, twentyFivePercSwitch: 25.0]
        
        totalTextField.delegate = self
        
        peopleUIPicker.delegate = self
        peopleUIPicker.dataSource = self
        peopleUIPicker.selectRow(4, inComponent: 0, animated: false)
        
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
        total = Double(totalTextField.text!) ?? 0.0
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true) // closes keyboard for any active textField
    }
                                                                        
    @objc func dismissKeyboard() {
        view.endEditing(true)
        }
    
    // MARK: - UIPicker methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbersForUIPicker.count
    }

    // Appearance
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = numbersForUIPicker[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "MainFontColor") ?? UIColor.black,
            .font: UIFont.systemFont(ofSize: 18)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pplNumber = Int(numbersForUIPicker[row]) ?? 1
    }

    
    //MARK: - IBActions
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        totalTextField.endEditing(true)
        // one One, set others to Off
        for switcher in switches.keys {
            if switcher != sender {
                switcher.setOn(false, animated: true)
            }
            }
            if sender.isOn {
                tips = switches[sender] ?? 0.0
            } else {
                tips = 0.0
            }
        }
    
    @IBAction func equalSplitButtonPressed(_ sender: UIButton) {
        totalTextField.endEditing(true)
        brain.createBill(total: total, pplNumber: pplNumber, tips: tips)
        
        performSegue(withIdentifier: K.calculateSegueIdentifier, sender: self)
    }
    
    
    @IBAction func customButtonPressed(_ sender: UIButton) {
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
