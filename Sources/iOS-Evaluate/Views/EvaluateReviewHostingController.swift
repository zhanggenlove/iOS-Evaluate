//
//  EvaluateReviewHostingController.swift
//  Evaluate
//
//  UIKit bridge for the SwiftUI review card.
//

import UIKit
import SwiftUI

/// A transparent hosting controller that presents the SwiftUI review prompt
/// over the current view controller using a custom modal presentation.
@MainActor
final class EvaluateReviewHostingController: UIViewController {

  private let reviewView: EvaluateReviewView

  init(reviewView: EvaluateReviewView) {
    self.reviewView = reviewView
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overFullScreen
    modalTransitionStyle = .crossDissolve
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear

    let hostingController = UIHostingController(rootView: reviewView)
    hostingController.view.backgroundColor = .clear

    addChild(hostingController)
    hostingController.view.frame = view.bounds
    hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(hostingController.view)
    hostingController.didMove(toParent: self)
  }
}
