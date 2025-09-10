//
//  ShareButtonHelper.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 9/10/25.
//

import UIKit

struct ShareHelper {
    static func presentShareSheet(from vc: UIViewController,
                                  sender: UIView?,
                                  text: String) {
        let items: [Any] = [text]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)

        // iPad support
        if let popover = activityVC.popoverPresentationController {
            if let sender = sender {
                popover.sourceView = sender
                popover.sourceRect = sender.bounds
            } else {
                popover.sourceView = vc.view
                popover.sourceRect = CGRect(x: vc.view.bounds.midX,
                                            y: vc.view.bounds.midY,
                                            width: 0,
                                            height: 0)
                popover.permittedArrowDirections = []
            }
        }

        vc.present(activityVC, animated: true, completion: nil)
    }
}



// struct ShareHelper {
//     static func presentShareSheet(from vc: UIViewController,
//                                   sender: UIView?,
//                                   text: String,
//                                   includeScreenshot: Bool = false) {
//
//         var items: [Any] = [text]
//
//         if includeScreenshot, let screenshot = vc.view.asImage() {
//             items.append(screenshot)
//         }
//
//         let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
//
////          iPad support
//         if let popover = activityVC.popoverPresentationController {
//             if let sender = sender {
//                 popover.sourceView = sender
//                 popover.sourceRect = sender.bounds
//             } else {
//                 popover.sourceView = vc.view
//                 popover.sourceRect = CGRect(x: vc.view.bounds.midX,
//                                             y: vc.view.bounds.midY,
//                                             width: 0,
//                                             height: 0)
//                 popover.permittedArrowDirections = []
//             }
//         }
//
//         vc.present(activityVC, animated: true, completion: nil)
//     }
// }
//
////  MARK: - UIView extension for screenshot
// extension UIView {
//     func asImage() -> UIImage? {
//         let renderer = UIGraphicsImageRenderer(bounds: bounds)
//         return renderer.image { rendererContext in
//             layer.render(in: rendererContext.cgContext)
//         }
//     }
// }

 
