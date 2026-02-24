//
//  UIApplication+Extensions.swift
//  Evaluate
//
//  Created by Mister Grizzly on 12/17/20.
//

import UIKit
import StoreKit

extension UIApplication {
  var currentScene: UIWindowScene? {
    connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
  }
  
  func requestReview() {
    if let scene = UIApplication.shared.currentScene {
      SKStoreReviewController.requestReview(in: scene)
    }
  }
  
  func isAvailableRequestReview() -> Bool {
    return true
  }
  
  func rateAppInAppStore(using appID: String?) {
    #if arch(i386) || arch(x86_64)
    debugPrint("SIMULATOR NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
    #else
    guard let appID = appID else { return }
    let reviewURL = "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review";
    guard let url = URL(string: reviewURL) else { return }
      UIApplication.shared.open(url)
    #endif
  }
}
