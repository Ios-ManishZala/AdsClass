//
//  GoogleAdvertiseModel.swift
//  DemoAdd
//
//  Created by DREAMWORLD on 26/07/23.
//

import Foundation
import UIKit
import SkeletonView


let gradient = SkeletonGradient(baseColor: UIColor.lightGray.withAlphaComponent(0.30))
let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
var darkMode:Bool = false


class GoogleMobAd {
    
    static let shared = GoogleMobAd()
    
    var isAppopenAdsShow_Hide:Bool = true
    var messageCountForUser:Int = 0
    
    var interCounter = 3
    
    var interstitialAdID:String = ""
    var appOpenAdID_Splash:String = ""
    var appOpenAdID_Resume:String = ""
    var bannerAdID:String = ""
    var nativeAdID:String = ""
    
    var isAdOn:Bool = true
    var isAppopenAdOn:Bool = true
    
    var userSubscribeAvailable:Bool = false
    let Santa_proID = "Santa_pro"
}
