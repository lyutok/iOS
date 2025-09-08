//
//  ViewController.swift
//  Keyboard
//
//  Created by Lyudmila Tokar on 8/31/25.
//

import UIKit
import IQKeyboardManagerSwift

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
//    @IBOutlet var topView: UIView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.removeAll()

        // Disable only for a specific top view if needed
        // (Usually unnecessary if it's pinned to safe area)

        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("TableView frame: \(tableView.frame)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        
        return cell
}

    @IBAction func calculateButton(_ sender: UIButton) {
        print("tableView frame2: \(tableView.frame)")
    }
}
