//
//  CustomViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 8/21/25.
//

import UIKit

class CustomViewController: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    tableView.register(UINib(nibName: "CalculateCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
//        print("tableView is \(tableView)")
//        tableView.backgroundColor = .lightGray
             
    }

    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
    

extension CustomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        return 10
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! CalculateCell
        
        cell.personTextField.text = "Person \(indexPath.row + 1)"
        cell.personTextField.placeholder = "Person \(indexPath.row + 1)"
//        print("dequeueReusableCell")
//        cell.backgroundColor = .yellow
        return cell
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


