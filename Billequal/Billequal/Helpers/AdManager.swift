//
//  AdManager.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 12/8/25.
//

import GoogleMobileAds
import UIKit

class AdManager: NSObject {

    static let shared = AdManager()
    private var interstitial: InterstitialAd?

    private override init() {
        super.init()
    }

    func loadAd() {
        let request = Request()
        InterstitialAd.load(
            with: "ca-app-pub-3940256099942544/4411468910",
            request: request
        ) { [weak self] ad, error in
            self?.interstitial = ad
        }
    }

    func showInterstitial(from vc: UIViewController) {
        if let ad = interstitial {
            ad.present(from: vc)
            loadAd()
        } else {
            loadAd()
        }
    }
}

