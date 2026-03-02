//
//  SetNotification.swift
//  TimeMesh
//
//  Created by Lyudmila Tokar on 1/30/26.
//

import UIKit

class SetNotificationVC: UIViewController {
    
    @IBOutlet var notificationOptionsView: UIVisualEffectView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        notificationOptionsView.layer.cornerRadius = 20
        notificationOptionsView.clipsToBounds = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationOptionsView.layer.borderWidth = 2
        notificationOptionsView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
    }

    @IBAction func confirmButton(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
}
