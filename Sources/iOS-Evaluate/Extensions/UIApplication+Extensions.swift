//
//  UIApplication+Extensions.swift
//  Evaluate
//
//  Modernized for iOS 26+
//

import UIKit
import StoreKit

extension UIApplication {
  var currentScene: UIWindowScene? {
    connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
  }

  func requestReview() {
    if let scene = UIApplication.shared.currentScene {
      AppStore.requestReview(in: scene)
    }
  }

  func isAvailableRequestReview() -> Bool {
    return true
  }

  func rateAppInAppStore(using appID: String?) {
    guard let appID = appID else { return }
    let reviewURL = "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review"
    guard let url = URL(string: reviewURL) else { return }
    UIApplication.shared.open(url)
  }
}
