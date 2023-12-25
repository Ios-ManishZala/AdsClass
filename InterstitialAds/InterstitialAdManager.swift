//
//  InterstitialAdManager.swift
//  SantaCallTracker
//
//  Created by DREAMWORLD on 12/10/23.
//

import Foundation
import GoogleMobileAds
import ProgressHUD


final class InterstitialViewController: NSObject {
    
    var interstitial: GADInterstitialAd?
    static let shared = InterstitialViewController()
    var dismissInteritialAd:(()->()) = { }
    
    
    func loadIntestitialAdd(viewControlller:UIViewController){
        if !GoogleMobAd.shared.userSubscribeAvailable && GoogleMobAd.shared.isAdOn {
            let institialId = GoogleMobAd.shared.interstitialAdID
            let request = GADRequest()
            
            if institialId.isEmpty == false {
                ProgressHUD.colorBackground = .white
                ProgressHUD.show("Loading Ads",interaction: false)
            }
            
            GADInterstitialAd.load(withAdUnitID: institialId,
                                   request: request) { [self] ads,error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    self.dismissInteritialAd()
                    return
                }
                interstitial = ads
                interstitial?.fullScreenContentDelegate = self
                
                if GoogleMobAd.shared.isAdOn {
                    interstitial?.present(fromRootViewController: viewControlller)
                    GoogleMobAd.shared.isAppopenAdsShow_Hide = false
                }
            }
        }
    }
}



//MARK: - Delegate.

extension InterstitialViewController: GADFullScreenContentDelegate {

    //MARK: -Delegate Method from institial Google Add.

    // Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        JSN.log("Ad did fail to present full screen content.")
    }

    // Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        ProgressHUD.dismiss()
        JSN.log("Ad will present full screen content.")
    }

    // Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        JSN.log("Ad did dismiss full screen content.")
        ProgressHUD.dismiss()
        GoogleMobAd.shared.isAppopenAdsShow_Hide = true
        self.dismissInteritialAd()
    }

    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        JSN.log("Ads clicked ==>")
        GoogleMobAd.shared.isAppopenAdOn = false
    }

    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("adDidRecordImpression")
    }
}
