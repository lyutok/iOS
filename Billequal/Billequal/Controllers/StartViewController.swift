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
    @IBOutlet var twentyPercSwitch: UISwitch!
    @IBOutlet var twentyFivePercSwitch: UISwitch!
    
    var switches: [UISwitch: Double] = [:]
    
    @IBOutlet var peopleUIPicker: UIPickerView!
    let options = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    var total = 0.0
    var pplNumber = 5
    var tips = 10.0
    var eachToPay = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        switches = [fivePercSwitch: 5.0, tenPercSwitch: 10.0, twentyPercSwitch: 20.0, twentyFivePercSwitch: 25.0]
        
        totalTextField.delegate = self
        
        peopleUIPicker.delegate = self
        peopleUIPicker.dataSource = self
        peopleUIPicker.selectRow(4, inComponent: 0, animated: false)
        
        // to dismiss keybord
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK: - Keyboard
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        total = Double(totalTextField.text!) ?? 0.0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        }
    
    //MARK: - UIPicker methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pplNumber = Int(options[row]) ?? 1
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
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        totalTextField.endEditing(true)
        eachToPay = total / Double(pplNumber) + (total / Double(pplNumber)) * (tips / 100)
        print(total)
        print(pplNumber)
        print(tips)
        print(totalTextField.text!)
        print(eachToPay)
        
        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.totalValue = total
            destinationVC.tipsValue = tips
            destinationVC.pplNumberValue = pplNumber
            destinationVC.eachToPayValue = eachToPay
    }
    
    }
}
