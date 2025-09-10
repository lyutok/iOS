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
    
    @IBOutlet var totalValueLabel: UILabel!
    @IBOutlet var leftValueLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textWithTipsLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bill = billValues {
            totalValueLabel.text = String(format: "%.2f", bill.total)
            
            textWithTipsLabel.text = "Tips, " + String(format: "%.0f", bill.tips) + "%"
            
            leftAmount = bill.total
            leftValueLabel.text = String(format: "%.2f", leftAmount)
        }
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    @IBAction func restartPressed(_ sender: UIButton) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        // TOT TEXT ADD appName
        // Text or data to share
        let textToShare = "Here’s \(String(format: "%.2f", billValues?.total ?? 0.0)) bill split: \(String(format: "%.2f", billValues?.eachToPay ?? 0.0)) 💸 each, \(String(format: "%.0f", billValues?.tips ?? 0.0))% included."
        
        ShareHelper.presentShareSheet(from: self, sender: sender, text: textToShare)
    }
    
    @IBAction func CalculatePressed(_ sender: UIButton) {
        let calculatorVC = CalculatorViewController()
            present(calculatorVC, animated: true, completion: nil)
    }
}

// TableView
extension CustomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billValues?.pplNumber ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CalculateCell
        
        cell.personLabel.text = "Person \(indexPath.row + 1)"
//        cell.personTextField.placeholder = "Person \(indexPath.row + 1)"
        
        cell.resultLabel.text = "0.00"
        cell.resultWithTipsLabel.text = "0.00"
        
        cell.delegate = self
        
        return cell
    }
}

// protocal for the cell to press Calculate button
extension CustomViewController: CalculateCellDelegate {
    
    func didTapCalculate(in cell: CalculateCell) {
        let calculatorVC = CalculatorViewController()
        present(calculatorVC, animated: true, completion: nil)
    }
}
