//
//  Untitled.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 1/7/26.
//

import UIKit
import UserMessagingPlatform

final class ConsentManager {

    static let shared = ConsentManager()

    func requestConsent(from viewController: UIViewController,
                        completion: @escaping () -> Void) {

        let parameters = RequestParameters()
        parameters.isTaggedForUnderAgeOfConsent = false

        ConsentInformation.shared.requestConsentInfoUpdate(
            with: parameters
        ) { error in
            if let error = error {
                print("Consent error: \(error)")
                completion()
                return
            }

            ConsentForm.load { form, _ in
                if let form = form,
                   ConsentInformation.shared.consentStatus == .required {
                    form.present(from: viewController) {_ in 
                        completion()
                    }
                } else {
                    completion()
                }
            }
        }
    }
}
