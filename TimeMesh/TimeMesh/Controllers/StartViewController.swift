//
//  ViewController.swift
//  TimeMesh
//
//  Created by Lyudmila Tokar on 1/28/26.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var nowBlurView: UIVisualEffectView!
    @IBOutlet var workTimeConverter: UIVisualEffectView!
    
    @IBOutlet var workTimeTestField: UITextField!
    @IBOutlet var currentTimeTextField: UITextField!
    @IBOutlet var notifyMeButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        plusButton.layer.cornerRadius = (plusButton.bounds.width / 2) + 2
        plusButton.clipsToBounds = true
        
        nowBlurView.layer.cornerRadius = 20
        nowBlurView.clipsToBounds = true
        
        workTimeConverter.layer.cornerRadius = 20
        workTimeConverter.clipsToBounds = true
        
        workTimeTestField.layer.cornerRadius = workTimeTestField.bounds.height / 2
        workTimeTestField.clipsToBounds = true
        
        currentTimeTextField.layer.cornerRadius = currentTimeTextField.frame.height / 2
        currentTimeTextField.clipsToBounds = true
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        blur.frame = view.bounds
        blur.isUserInteractionEnabled = false
        view.insertSubview(blur, at: 0)
        
//        plusButton.tintColor = .white
//        plusButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        plusButton.layer.borderWidth = 2
        plusButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        nowBlurView.layer.borderWidth = 2
        nowBlurView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        nowBlurView.contentView.insertSubview(blur, at: 0)
        
        workTimeConverter.layer.borderWidth = 2
        workTimeConverter.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        workTimeConverter.contentView.insertSubview(blur, at: 0)
        
        notifyMeButton.layer.borderWidth = 2
        notifyMeButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
//        notifyMeButton.insertSubview(blur, at: 0)
        
//        
//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.isUserInteractionEnabled = false
//        
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        
//        notifyMeButton.insertSubview(blurView, at: 0)
//        NSLayoutConstraint.activate([
//            blurView.topAnchor.constraint(equalTo: notifyMeButton.topAnchor),
//            blurView.bottomAnchor.constraint(equalTo: notifyMeButton.bottomAnchor),
//            blurView.leadingAnchor.constraint(equalTo: notifyMeButton.leadingAnchor),
//            blurView.trailingAnchor.constraint(equalTo: notifyMeButton.trailingAnchor)
//        ])

        

    }
}

