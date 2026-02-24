//
//  UIViewController+Extensions.swift
//  Evaluate
//
//  Modernized for iOS 26+
//

import UIKit

extension UIViewController {

  /// Present the Evaluate review prompt from any UIKit view controller.
  ///
  /// This is a convenience wrapper around `Evaluate.rateApp(in:)`.
  public func showEvaluatePrompt() {
    Evaluate.rateApp(in: self)
  }
}
