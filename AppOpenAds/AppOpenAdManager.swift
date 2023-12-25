

import GoogleMobileAds
import ProgressHUD


final class AppOpenAdManager: NSObject, GADFullScreenContentDelegate {
    
    var appOpenAd: GADAppOpenAd?
    var loadTime = Date()
    var dismissAppopenAds:(()->()) = { }
    static let shared = AppOpenAdManager()
    
    func requestAppOpenAd(isFromSplash:Bool = false) {
        if !GoogleMobAd.shared.userSubscribeAvailable && GoogleMobAd.shared.isAdOn && GoogleMobAd.shared.isAppopenAdOn {
            let request = GADRequest()
            let appopenId = isFromSplash == true ? GoogleMobAd.shared.appOpenAdID_Splash : GoogleMobAd.shared.appOpenAdID_Resume
            GADAppOpenAd.load(withAdUnitID: appopenId,
                              request: request,
                              orientation: UIInterfaceOrientation.portrait,
                              completionHandler: { (appOpenAdIn, error ) in
                if let error = error {
                    print("Failed to load Appopen ads with error: \(error.localizedDescription)")
                    self.dismissAppopenAds()
                    return
                }
                self.appOpenAd = appOpenAdIn
                self.appOpenAd?.fullScreenContentDelegate = self
                self.loadTime = Date()
                print("[OPEN AD] Ad is ready")
            })
        }
    }
    
    func tryToPresentAd(viewController: UIViewController) {
        if let gOpenAd = self.appOpenAd, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
            gOpenAd.present(fromRootViewController: viewController)
        }
        else {
            self.requestAppOpenAd()
        }
    }
    
    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }
}


//MARK: -- AppOpen delegate --

extension AppOpenAdManager {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("[OPEN AD] Failed: \(error)")
        requestAppOpenAd()
        self.dismissAppopenAds()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestAppOpenAd()
        print("[OPEN AD] Ad dismissed")
        self.dismissAppopenAds()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("[OPEN AD] Ad Will present")
    }
}
