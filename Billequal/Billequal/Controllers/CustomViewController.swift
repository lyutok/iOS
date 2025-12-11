//
//  CustomViewController.swift
//  Billequal
//
//  Created by Liudmyla Tokar on 8/21/25.
//

import UIKit
import GoogleMobileAds

class CustomViewController: UIViewController {
  
    var billValues: Bill?
    var billequalBrain = BillequalBrain()
    var leftAmount = 0.0
    var tappedRow = 0 // index for the row of Calculate button tapped
    var shouldShowAd = true // show ad ONLY once per appearance
    
    var rowData: [PersonCalculation] = []
    
    @IBOutlet var totalValueLabel: UILabel!
    @IBOutlet var leftValueLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textWithTipsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bill = billValues {
            totalValueLabel.text = String(format: "%.2f", bill.total)
            
            textWithTipsLabel.text = "Tips: " + String(format: "%.0f", bill.tips) + "%"
            
            leftAmount = bill.total
            leftValueLabel.text = String(format: "%.2f", leftAmount)
            
        // initialize rows
        rowData = (0..<bill.pplNumber).map { index in
            PersonCalculation(
                name: "Person \(index + 1)",
                result: 0.0,
                resultWithTips: 0.0
            )
        }
        }
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    // Google ads
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load next ad
        AdManager.shared.loadAd()
        
        // Show ad ONCE
        if shouldShowAd {
            shouldShowAd = false
            AdManager.shared.showInterstitial(from: self)
        }
    }
    
    @IBAction func restartPressed(_ sender: UIButton) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        // Text or data to share
        var agregatedData = ""
        
        for data in rowData {
            agregatedData += "· \(data.name) — \(String(format: "%.2f", data.resultWithTips))\n"
        }
        
        let textToShare = """
                        Total: \(String(format: "%.2f", billValues?.total ?? 0.0))
                        \(String(format: "%.0f", billValues?.tips ?? 0.0))% included\n
                        Bill split:
                        \(agregatedData)
                        — Billequal • Making splits simple
                        """
        
        ShareHelper.presentShareSheet(from: self, sender: sender, text: textToShare)
    }
}

// TableView
extension CustomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CalculateCell
        
        cell.personLabel.text = rowData[indexPath.row].name
        cell.resultLabel.text = String(format: "%.2f", rowData[indexPath.row].result)
        cell.resultWithTipsLabel.text = String(format: "%.2f", rowData[indexPath.row].resultWithTips)
        
        cell.delegate = self
        
        return cell
    }
}

// protocol for the cell to press Calculate button
// Open Calculator VC, Send Person label to calculator VC
extension CustomViewController: CalculateCellDelegate {
    
    func tapCalculateOnCell(in cell: CalculateCell) {
        
        // Get the indexPath of the tapped row cell
        if let indexPath = tableView.indexPath(for: cell) {
            tappedRow = indexPath.row
        }
            
        let calculatorVC = CalculatorViewController()
            calculatorVC.delegate = self
     
        calculatorVC.personLabel.text = cell.personLabel.text ?? "Person"
        present(calculatorVC, animated: true, completion: nil)
    }
}

// Recieve and update data after Calculation done
extension CustomViewController: CalculatorViewControllerDelegate {
    func calculatorDidFinish(name: String, result: String) {
        
        let indexPath = IndexPath(row: tappedRow, section: 0)

        // Update model
        if !name.isEmpty {
            rowData[tappedRow].name = name
        }
        if let res = Double(result) {
            rowData[tappedRow].result = res
            if let tips = billValues?.tips {
                rowData[tappedRow].resultWithTips = rowData[tappedRow].calculateWithTips(tips: tips)
            }
        }

        // Sum results for leftAmount
        let sumResults = rowData.reduce(0) { $0 + $1.result }
        leftAmount = (billValues?.total ?? 0.0) - sumResults
        
        // Update UI on main thread
        DispatchQueue.main.async {
            // Update visible cell
            if let cellToChange = self.tableView.cellForRow(at: indexPath) as? CalculateCell {
                if !name.isEmpty {
                    cellToChange.personLabel.text = name
                }
                if let res = Double(result) {
                    cellToChange.resultLabel.text = String(format: "%.2f", res)
                    cellToChange.resultWithTipsLabel.text = String(format: "%.2f", self.rowData[self.tappedRow].resultWithTips)
                }
            } else {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            // Update left amount label
            self.leftValueLabel.text = String(format: "%.2f", self.leftAmount)
        }
    }
}

