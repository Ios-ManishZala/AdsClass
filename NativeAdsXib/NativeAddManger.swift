//
//  NativeAddManger.swift
//  DemoAdd
//
//  Created by DREAMWORLD on 26/07/23.
//

import Foundation
import UIKit
import GoogleMobileAds
import SkeletonView
import ProgressHUD


final class NativeViewController: NSObject {
    
    var nativeAdView: GADNativeAdView!
    var adLoader: GADAdLoader!
    
    static let shard = NativeViewController()
    
    //MARK: - Native AddRequest.
    
    func requestNativeAds(isSmallNative:Bool,viewController: UIViewController, nativeAdContainerView:UIView) {
        JSN.log("userSubscribeAvailable ==>%@", GoogleMobAd.shared.userSubscribeAvailable)
        
        if !GoogleMobAd.shared.userSubscribeAvailable && GoogleMobAd.shared.isAdOn && GoogleMobAd.shared.nativeAdID.isEmpty == false {
            if let nibObjects = Bundle.main.loadNibNamed(isSmallNative ? "GADTSmallTemplateView" : "GADNativeAdView", owner: nil, options: nil) {
                let adView = nibObjects.first as? GADNativeAdView
                
                nativeAdView = adView!
                nativeAdView.clipsToBounds = true
                nativeAdContainerView.isHidden = false
                nativeAdContainerView.subviews.first?.removeFromSuperview()
                
                self.showShimmerEffect()
                nativeAdContainerView.addSubview(nativeAdView)
                nativeAdView.translatesAutoresizingMaskIntoConstraints = false
                
                // Layout constraints for positioning the native ad view to stretch the entire width and height of the nativeAdPlaceholder.
                
                let viewDictionary = ["_nativeAdView": nativeAdView]
                nativeAdContainerView.addConstraints(
                    NSLayoutConstraint.constraints(
                        withVisualFormat: "H:|[_nativeAdView]|",
                        options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary as [String : Any])
                )
                nativeAdContainerView.addConstraints(
                    NSLayoutConstraint.constraints(
                        withVisualFormat: "V:|[_nativeAdView]|",
                        options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary as [String : Any])
                )
                
                adLoader = GADAdLoader( adUnitID: GoogleMobAd.shared.nativeAdID, rootViewController: viewController, adTypes: [.native], options: nil)
                adLoader.delegate = self
                adLoader.load(GADRequest())
            }
        }
        else{
            nativeAdContainerView.isHidden = true
        }
    }
        
    
    // MARK: - GADAdLoaderDelegate methods.
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("native ad failed to load: \(error.localizedDescription)")
    }
    
    
    // MARK: - Show ShimmerEffect.
    
    func showShimmerEffect(){
        nativeAdView.headlineView?.isSkeletonable = true
        nativeAdView.headlineView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        
        nativeAdView.mediaView?.isSkeletonable = true
        nativeAdView.mediaView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        
        nativeAdView.bodyView?.isSkeletonable = true
        nativeAdView.bodyView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        
        nativeAdView.callToActionView?.isSkeletonable = true
        nativeAdView.callToActionView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        
        nativeAdView.iconView?.isSkeletonable = true
        nativeAdView.iconView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        
        nativeAdView.starRatingView?.isSkeletonable = true
        nativeAdView.starRatingView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        
        nativeAdView.storeView?.isSkeletonable = true
        nativeAdView.storeView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        
        nativeAdView.priceView?.isSkeletonable = true
        nativeAdView.priceView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
        
        nativeAdView.advertiserView?.isSkeletonable = true
        nativeAdView.advertiserView?.showAnimatedGradientSkeleton(usingGradient: gradient,animation: animation)
    }
}



// Mark: - GADNativeAdLoaderDelegate.
extension NativeViewController: GADNativeAdDelegate , GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        
        nativeAdView.hideSkeleton()

        print("Received native ad: \(nativeAd)")
        nativeAd.delegate = self
        
        nativeAdView.layer.cornerRadius = 10
        
        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        
        if nativeAd.icon?.image == nil {
            NSLayoutConstraint.activate([
                nativeAdView.headlineView!.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 10)
            ])
        }
        else{
            NSLayoutConstraint.activate([
                nativeAdView.headlineView!.leadingAnchor.constraint(equalTo: nativeAdView.iconView!.trailingAnchor,constant: 10)
            ])
        }
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
         nativeAdView.bodyView?.isHidden = nativeAd.body == nil
       
        
        (nativeAdView.callToActionView as? UIButton)?.setButtonTitleAndFunctionality(nativeAd.callToAction ?? "install")
         nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
         nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        
        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
         nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
         nativeAdView.storeView?.isHidden = nativeAd.store == nil
        
        
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
         nativeAdView.priceView?.isHidden = nativeAd.price == nil
        
        
//        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
//        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad viewsz
        nativeAdView.nativeAd = nativeAd
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        // The native ad was shown.
    }
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("The native ad was clicked on.")
        GoogleMobAd.shared.isAppopenAdOn = false
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        // The native ad will present a full screen view.
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        // The native ad will dismiss a full screen view.
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        // The native ad did dismiss a full screen view.
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
        // The native ad will cause the application to become inactive and
        // open a new application.
    }
    
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
}



