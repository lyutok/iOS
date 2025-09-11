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
    var tappedRow = 0 // index for the row of Calculate button tapped
    
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
        // TOT TEXT ADD appName!!!!
        // Text or data to share
        let textToShare = "Here’s \(String(format: "%.2f", billValues?.total ?? 0.0)) bill split: \(String(format: "%.2f", billValues?.eachToPay ?? 0.0)) 💸 each, \(String(format: "%.0f", billValues?.tips ?? 0.0))% included."
        
        ShareHelper.presentShareSheet(from: self, sender: sender, text: textToShare)
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
        cell.resultLabel.text = "0.00"
        cell.resultWithTipsLabel.text = "0.00"
        
        cell.delegate = self
        
        return cell
    }
}

// protocol for the cell to press Calculate button
// Open Calculator VC, Send Person label to calculator VC
extension CustomViewController: CalculateCellDelegate {
    
    func tapCalculateOnCell(in cell: CalculateCell) {
        
        // Get the indexPath of the tapped cell
        if let indexPath = tableView.indexPath(for: cell) {
            tappedRow = indexPath.row
            print("Tapped row button in row: \(tappedRow)")
        }
            
        let calculatorVC = CalculatorViewController()
            calculatorVC.delegate = self
     
        calculatorVC.personLabel.text = cell.personLabel.text ?? "Person "
        present(calculatorVC, animated: true, completion: nil)
    }
}

// Recieve and update data after Calculation done
extension CustomViewController: CalculatorViewControllerDelegate {
    func calculatorDidFinish(name: String, result: String) {
        print("Got back: \(name), \(result)")
        
        let indexPath = IndexPath(row: tappedRow, section: 0)

        if let cellToChange = tableView.cellForRow(at: indexPath) as? CalculateCell {
            // update visible cell directly
            if !name.isEmpty {
                cellToChange.personLabel.text = name
            }
            
            if let res = Double(result), let tips = billValues?.tips {
                cellToChange.resultLabel.text = String(format: "%.2f", res)
                
                let withTips = res + (res * tips / 100)
                cellToChange.resultWithTipsLabel.text = String(format: "%.2f", withTips)
                leftAmount -= res
            }
        } else {
            // If cell is off-screen, just reload the row
                tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        leftValueLabel.text = String(format: "%.2f", leftAmount)
    }
}

func updateLeftLabel (for person: Int, amountToPay: Double) -> Double {
    
    return 0.0
}
