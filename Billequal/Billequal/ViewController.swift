//
//  ViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/15/25.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var pepleUIPicker: UIPickerView!
    let options = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    override func viewDidLoad() {
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
}

//import UIKit
//
//class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
//
//    @IBOutlet weak var picker: UIPickerView! // соединить с Storyboard
//
//    let options = ["Option 1", "Option 2", "Option 3"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        picker.delegate = self
//        picker.dataSource = self
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return options.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return options[row]
//    }
//}
