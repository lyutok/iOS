//
//  ViewController.swift
//  Dice
//
//  Created by Lyudmila Tokar on 7/30/25.
//

import UIKit

class ViewController: UIViewController {
    
    let diceArray = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "6")]
    
    @IBOutlet var DiceView1: UIImageView!
    @IBOutlet var DiceView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func RollButtonPressed(_ sender: UIButton) {
        DiceView1.image = diceArray.randomElement()
        DiceView2.image = diceArray.randomElement()
    }


}

