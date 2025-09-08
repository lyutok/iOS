//
//  ViewController.swift
//  My Calculator
//
//  Created by Lyudmila Tokar on 9/7/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openCalculatorPressed(_ sender: UIButton) {
        let calculatorVC = CalculatorViewController()
            present(calculatorVC, animated: true, completion: nil)
    }
    
}

