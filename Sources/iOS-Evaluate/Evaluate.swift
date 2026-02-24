//
//  Evaluate.swift
//  Evaluate
//
//  Created by Mister Grizzly on 12/8/20.
//  Modernized for iOS 26+ and Swift 6
//

import Foundation
import UIKit
import StoreKit
import SwiftUI

/// The main entry point for the Evaluate review prompt library.
///
/// Configure thresholds and call `Evaluate.start()` from your app launch,
/// then trigger `Evaluate.rateApp(in:)` at the right moment.
@MainActor
public final class Evaluate {

  // MARK: - Configuration

  /// Whether to use StoreKit's native review prompt.
  public static var useStoreKitIfAvailable: Bool = true

  /// Whether to show the "Remind me later" button.
  public static var showRemindLaterButton: Bool = true

  /// Country code for the iTunes lookup (e.g., "us", "jp").
  public static var countryCode: String?

  // MARK: - Text Customization

  /// Custom alert title. Defaults to localized "Rate {AppName}".
  public static var alertTitle: String?

  /// Custom alert message. Defaults to localized prompt text.
  public static var alertMessage: String?

  /// Custom cancel button title.
  public static var alertCancelTitle: String?

  /// Custom rate button title.
  public static var alertRateAppTitle: String?

  /// Custom "Write a review" button title.
  public static var alertAppStoreTitle: String?

  /// Custom "Remind me later" button title.
  public static var alertRemindLaterTitle: String?

  /// Custom app name override.
  public static var appName: String?

  // MARK: - Theme

  /// UI theme configuration. Uses `EvaluateTheme.default` if not set.
  public static var theme: EvaluateTheme = .default

  // MARK: - Debug & Behavior

  /// Enable console logging for debugging.
  public static var canShowLogs: Bool = false

  /// Reset all tracking data when the app version changes.
  public static var resetEverythingWhenAppIsUpdated: Bool = true

  // MARK: - State

  /// The app's App Store ID (auto-detected or manually set).
  public static var appID: String?

  /// Whether the user has already completed the rating flow.
  public static var isRateDone: Bool {
    UserPreferencesManager.default.isRateDone
  }

  // MARK: - Singleton

  /// Shared instance for internal use.
  public static let `default` = Evaluate()

  private init() {}

  // MARK: - Computed Text

  private var resolvedAppName: String {
    Self.appName ?? Bundle.appName
  }

  private var titleText: String {
    Self.alertTitle ?? String(format: String.localize("Rate %@"), resolvedAppName)
  }

  private var messageText: String {
    Self.alertMessage ?? String(format: String.localize("Rater.title"), resolvedAppName)
  }

  private var rateText: String {
    Self.alertRateAppTitle ?? String(format: String.localize("Rate %@"), resolvedAppName)
  }

  private var writeReviewText: String {
    Self.alertAppStoreTitle ?? String.localize("Write a review on App Store")
  }

  private var cancelText: String {
    Self.alertCancelTitle ?? String.localize("No, Thanks")
  }

  private var remindLaterText: String {
    Self.alertRemindLaterTitle ?? String.localize("Remind me later")
  }

  // MARK: - Threshold Configuration

  /// Number of days after first launch before prompting.
  public static var daysUntilAlertWillBeShown: Int {
    get { UserPreferencesManager.default.daysUntilAlertWillBeShown }
    set { UserPreferencesManager.default.daysUntilAlertWillBeShown = newValue }
  }

  /// Number of app launches before prompting.
  public static var appUsesUntilAlertWillBeShown: Int {
    get { UserPreferencesManager.default.appUsesUntilAlertWillBeShown }
    set { UserPreferencesManager.default.appUsesUntilAlertWillBeShown = newValue }
  }

  /// Number of significant events before prompting.
  public static var significantUsesUntilAlertWillBeShown: Int {
    get { UserPreferencesManager.default.significantUsesUntilAlertWillBeShown }
    set { UserPreferencesManager.default.significantUsesUntilAlertWillBeShown = newValue }
  }

  /// Number of days before re-prompting after "Remind me later".
  public static var numberOfDaysBeforeRemindingAfterCancelation: Int {
    get { UserPreferencesManager.default.numberOfDaysBeforeReminding }
    set { UserPreferencesManager.default.numberOfDaysBeforeReminding = newValue }
  }

  /// Enable debug mode (always shows the prompt).
  public static var activateDebugMode: Bool {
    get { UserPreferencesManager.default.isDebugModeEnabled }
    set { UserPreferencesManager.default.isDebugModeEnabled = newValue }
  }

  // MARK: - Public API

  /// Shows the review prompt if all configured conditions are met.
  ///
  /// - Parameter controller: The view controller to present the prompt from.
  public static func rateApp(in controller: UIViewController) {
    guard UserPreferencesManager.default.allConditionsHaveBeenMet else { return }

    let instance = Evaluate.default

    let reviewView = EvaluateReviewView(
      title: instance.titleText,
      message: instance.messageText,
      rateButtonTitle: instance.rateText,
      writeReviewButtonTitle: instance.writeReviewText,
      remindLaterButtonTitle: showRemindLaterButton ? instance.remindLaterText : nil,
      cancelButtonTitle: instance.cancelText,
      theme: theme,
      onRateApp: {
        // Use the modern environment-based review request
        if let scene = UIApplication.shared.connectedScenes
          .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
          AppStore.requestReview(in: scene)
        }
        controller.dismiss(animated: true)
      },
      onWriteReview: {
        UIApplication.shared.rateAppInAppStore(using: Evaluate.appID)
        controller.dismiss(animated: true)
      },
      onRemindLater: {
        UserPreferencesManager.default.saveReminderRequestDate()
        controller.dismiss(animated: true)
      },
      onCancel: {
        UserPreferencesManager.default.isRateDone = true
        controller.dismiss(animated: true)
      }
    )

    let hostingController = EvaluateReviewHostingController(reviewView: reviewView)
    controller.present(hostingController, animated: true)
  }

  /// Call this once during app launch to begin tracking usage.
  public static func start() {
    if resetEverythingWhenAppIsUpdated,
       Bundle.appVersion != UserPreferencesManager.default.appTrackingVersion {
      UserPreferencesManager.default.resetAllValues()
      UserPreferencesManager.default.appTrackingVersion = Bundle.appVersion
    }
    Evaluate.default.perform()
  }

  /// Resets all tracking data (usage counts, dates, rate status).
  public static func reset() {
    UserPreferencesManager.default.resetAllValues()
  }

  // MARK: - Internal

  func incrementAppUsagesCount() {
    UserPreferencesManager.default.incrementAppUsesCount()
  }

  /// Manually increment significant event counter.
  public func incrementSignificantUseCount() {
    UserPreferencesManager.default.incrementSignificantUsesCount()
  }

  // MARK: - Private

  private func perform() {
    if Self.appName != nil {
      incrementAppUsagesCount()
    } else {
      EvaluateHelper.default.startParsingData()
    }
  }
}
