//
//  String+Extensions.swift
//  Evaluate
//
//  Created by Mister Grizzly on 12/17/20.
//

import Foundation

extension String {
  static func localize(_ key: String) -> String {
#if SWIFT_PACKAGE
    let bundle = Bundle.module
#else
    let bundle = Bundle(for: Evaluate.self)
#endif
    return NSLocalizedString(key, tableName: "EvaluateLocalization", bundle: bundle, comment: "")
  }
  
  var localize: String {
#if SWIFT_PACKAGE
    let bundle = Bundle.module
#else
    let bundle = Bundle(for: Evaluate.self)
#endif
    return NSLocalizedString(self, tableName: "EvaluateLocalization", bundle: bundle, comment: "")
  }
}
