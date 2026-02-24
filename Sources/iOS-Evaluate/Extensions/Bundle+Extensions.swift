//
//  Bundle+Extensions.swift
//  Evaluate
//
//  Created by zhanggen on 2026/02/24.
//

import UIKit

// MARK: - Bundle Extensions

extension Bundle {
  class var appName: String {
    let bundleDisplayname = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    let bundleName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    
    return bundleDisplayname ?? bundleName ?? "App"
  }
  
  class var appVersion: String {
    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0.0.0"
  }
  
  class var bundleID: String? {
    return Bundle.main.bundleIdentifier
  }
}
