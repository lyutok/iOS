//
//  ViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/15/25.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var fivePercSwitch: UISwitch!
    @IBOutlet var tenPercSwitch: UISwitch!
    @IBOutlet var twentyPercSwitch: UISwitch!
    @IBOutlet var twentyFivePercSwitch: UISwitch!
    
    var switches: [UISwitch: Double] = [:]
    
    @IBOutlet var pepleUIPicker: UIPickerView!
    let options = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var pplNumber = 5
    var tips = 0.0
    
    override func viewDidLoad() {
        
        switches = [fivePercSwitch: 5.0, tenPercSwitch: 10.0, twentyPercSwitch: 20.0, twentyFivePercSwitch: 25.0]
        
        super.viewDidLoad()
        pepleUIPicker.delegate = self
        pepleUIPicker.dataSource = self
        pepleUIPicker.selectRow(4, inComponent: 0, animated: false)
    }

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
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        // one One, set others to Off
        for switcher in switches.keys {
            if switcher != sender {
                switcher.setOn(false, animated: true)
            }
        }
        
        tips = switches[sender] ?? 0.0
            
        }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        print(pplNumber)
        print(tips)
    }
}
