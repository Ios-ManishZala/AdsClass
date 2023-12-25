//
//  BannerAdManager.swift
//  DemoAdd
//
//  Created by DREAMWORLD on 26/07/23.
//

import Foundation
import UIKit
import GoogleMobileAds
import SkeletonView


//MARK: - bannerAdd Show.

extension UIViewController: GADBannerViewDelegate{
    
    func showBannerAdd(bannerView:GADBannerView){
        if !GoogleMobAd.shared.userSubscribeAvailable && GoogleMobAd.shared.isAdOn {
            bannerView.adUnitID = GoogleMobAd.shared.bannerAdID
            bannerView.rootViewController = self
            bannerView.delegate = self
            bannerView.load(GADRequest())
            bannerView.isHidden = false
            bannerView.isSkeletonable = true
            bannerView.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        }
        else{
            bannerView.isHidden = true
        }
    }
    
    func showStandardBannerAdd(bannerView:GADBannerView){
        if !GoogleMobAd.shared.userSubscribeAvailable && GoogleMobAd.shared.isAdOn {
            let customAdSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
            bannerView.adSize = customAdSize
            bannerView.isHidden = false
            bannerView.isSkeletonable = true
            bannerView.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
            bannerView.adUnitID = GoogleMobAd.shared.bannerAdID
            bannerView.rootViewController = self
            bannerView.delegate = self
            bannerView.load(GADRequest())
        }
        else{
            bannerView.isHidden = true
        }
    }
    
    //MARK: - Native ads rating -
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
    
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        NotificationCenter.default.post(name: Notification.Name("bannerAdsFaild"), object: nil)
    }
    
    public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        bannerView.hideSkeleton()
        print("bannerViewDidRecordImpression")
    }
    
    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    public func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
    
    public func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        print("bannerViewClick")
        GoogleMobAd.shared.isAppopenAdOn = false
    }
}
