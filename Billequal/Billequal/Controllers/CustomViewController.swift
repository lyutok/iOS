//
//  CustomViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/21/25.
//

import UIKit

class CustomViewController: UIViewController {
    
    var billValues: Bill?
    var leftAmount = 0.0
    
    @IBOutlet var totalTextField: UITextField!
    
    @IBOutlet var tipsTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bill = billValues {
            totalTextField.text = String(format: "%.2f", bill.total)
            tipsTextField.text = String(format: "%.0f", bill.tips)
        }
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
             
    }

    @IBAction func goBackPressed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
    

extension CustomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        return billValues?.pplNumber ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CalculateCell
        
        cell.personTextField.text = "Person \(indexPath.row + 1)"
        cell.personTextField.placeholder = "Person \(indexPath.row + 1)"
        
        cell.resultLabel.text = "00.00"
        cell.resultWithTips.text = "00.00"
        
        return cell
    }
    
}
