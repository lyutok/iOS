//
//  AdManager.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 12/8/25.
//

import GoogleMobileAds
import UIKit

final class AdManager: NSObject {

    static let shared = AdManager()
    private var interstitial: InterstitialAd?

    private override init() {
        super.init()
    }

    func loadAd() {
        let request = Request()

        // 🔒 Force NON-personalized ads
        let extras = Extras()
        extras.additionalParameters = ["npa": "1"]
        request.register(extras)

        InterstitialAd.load(
            with: "ca-app-pub-6929888097109807/9050268785", // test ID -> ca-app-pub-3940256099942544/4411468910
            request: request
        ) { [weak self] ad, error in

            if let error = error {
                print("Interstitial load failed: \(error.localizedDescription)")
                self?.interstitial = nil
                return
            }

            self?.interstitial = ad
        }
    }

    func showInterstitial(from viewController: UIViewController) {
        guard let ad = interstitial else {
            loadAd()
            return
        }

        ad.present(from: viewController)
        interstitial = nil
        loadAd()
    }
}
