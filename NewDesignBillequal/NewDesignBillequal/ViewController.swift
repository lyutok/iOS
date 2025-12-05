//
//  ViewController.swift
//  NewDesignBillequal
//
//  Created by Lyudmila Tokar on 11/25/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var middleView: UIStackView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!

    private let gradientTop = CAGradientLayer()
    private let gradientBottom = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopGradient()
        setupBottomGradient()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Keep frames updated after AutoLayout
//        gradientTop.frame = topView.bounds
        gradientBottom.frame = bottomView.bounds
    }

    private func setupTopGradient() {
        gradientTop.colors = [
            #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1).cgColor,
            #colorLiteral(red: 0.6470588235, green: 0.8274509804, blue: 0.8509803922, alpha: 1).cgColor,
            UIColor.white.cgColor
           
        ]
        
        gradientTop.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientTop.endPoint   = CGPoint(x: 0.5, y: 1.0)
        
        topView.layer.insertSublayer(gradientTop, at: 0)
    }

    private func setupBottomGradient() {
        gradientBottom.colors = [
            #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor,
            #colorLiteral(red: 0.6470588235, green: 0.8274509804, blue: 0.8509803922, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        
        gradientBottom.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientBottom.endPoint   = CGPoint(x: 0.5, y: 0.0)
        
        bottomView.layer.insertSublayer(gradientBottom, at: 0)
    }
}

