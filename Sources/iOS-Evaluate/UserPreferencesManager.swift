//
//  UserPreferencesManager.swift
//  Evaluate
//
//  Created by Mister Grizzly on 12/8/20.
//  Modernized for iOS 26+ and Swift 6
//

import Foundation

@MainActor
final class UserPreferencesManager {

  // MARK: - Constants

  static let kUDInvalidValue = -1

  private enum Keys: String {
    case appRateDone
    case appTrackingVersion
    case appFirstUseDate
    case alertReminderRequestDate
    case appUsesCount
    case appSignificantEventCount
  }

  // MARK: - Singleton

  static let `default` = UserPreferencesManager()

  // MARK: - Properties

  private let userDefaults: UserDefaults

  var daysUntilAlertWillBeShown: Int = kUDInvalidValue
  var appUsesUntilAlertWillBeShown: Int = kUDInvalidValue
  var significantUsesUntilAlertWillBeShown: Int = kUDInvalidValue
  var numberOfDaysBeforeReminding: Int = kUDInvalidValue

  var showLaterButton: Bool = true
  var isDebugModeEnabled: Bool = false

  // MARK: - Persisted Properties

  var isRateDone: Bool {
    get { userDefaults.bool(forKey: Keys.appRateDone.rawValue) }
    set { userDefaults.set(newValue, forKey: Keys.appRateDone.rawValue) }
  }

  var appTrackingVersion: String {
    get { userDefaults.string(forKey: Keys.appTrackingVersion.rawValue) ?? "" }
    set { userDefaults.set(newValue, forKey: Keys.appTrackingVersion.rawValue) }
  }

  private var firstUseDate: TimeInterval {
    let value = userDefaults.double(forKey: Keys.appFirstUseDate.rawValue)
    if value == 0 {
      let now = Date().timeIntervalSince1970
      userDefaults.set(now, forKey: Keys.appFirstUseDate.rawValue)
      return now
    }
    return value
  }

  private var reminderTimeRequestToRate: TimeInterval {
    get { userDefaults.double(forKey: Keys.alertReminderRequestDate.rawValue) }
    set { userDefaults.set(newValue, forKey: Keys.alertReminderRequestDate.rawValue) }
  }

  private var usesCount: Int {
    get { userDefaults.integer(forKey: Keys.appUsesCount.rawValue) }
    set { userDefaults.set(newValue, forKey: Keys.appUsesCount.rawValue) }
  }

  private var significantEventCount: Int {
    get { userDefaults.integer(forKey: Keys.appSignificantEventCount.rawValue) }
    set { userDefaults.set(newValue, forKey: Keys.appSignificantEventCount.rawValue) }
  }

  // MARK: - Init

  private init() {
    self.userDefaults = .standard
    userDefaults.register(defaults: [
      Keys.appFirstUseDate.rawValue: 0,
      Keys.appUsesCount.rawValue: 0,
      Keys.appSignificantEventCount.rawValue: 0,
      Keys.appRateDone.rawValue: false,
      Keys.appTrackingVersion.rawValue: "",
      Keys.alertReminderRequestDate.rawValue: 0
    ])
  }

  // MARK: - Condition Evaluation

  var allConditionsHaveBeenMet: Bool {
    guard !isDebugModeEnabled else {
      log("Debug mode active — showing prompt")
      return true
    }

    guard !isRateDone else {
      log("Already rated — skipping")
      return false
    }

    if reminderTimeRequestToRate == 0 {
      // Days since first launch
      if daysUntilAlertWillBeShown != Self.kUDInvalidValue {
        let elapsed = Date().timeIntervalSince(Date(timeIntervalSince1970: firstUseDate))
        let required = TimeInterval(60 * 60 * 24 * daysUntilAlertWillBeShown)
        if elapsed >= required { return true }
      }

      // App use count
      if appUsesUntilAlertWillBeShown != Self.kUDInvalidValue {
        if usesCount > appUsesUntilAlertWillBeShown { return true }
      }

      // Significant events
      if significantUsesUntilAlertWillBeShown != Self.kUDInvalidValue {
        if significantEventCount > significantUsesUntilAlertWillBeShown { return true }
      }
    } else {
      // Reminder delay
      if numberOfDaysBeforeReminding != Self.kUDInvalidValue {
        let elapsed = Date().timeIntervalSince(Date(timeIntervalSince1970: reminderTimeRequestToRate))
        let required = TimeInterval(60 * 60 * 24 * numberOfDaysBeforeReminding)
        if elapsed >= required { return true }
      }
    }

    return false
  }

  // MARK: - Mutation

  func resetAllValues() {
    userDefaults.set(0, forKey: Keys.appFirstUseDate.rawValue)
    userDefaults.set(0, forKey: Keys.appUsesCount.rawValue)
    userDefaults.set(0, forKey: Keys.appSignificantEventCount.rawValue)
    userDefaults.set(false, forKey: Keys.appRateDone.rawValue)
    userDefaults.set(0, forKey: Keys.alertReminderRequestDate.rawValue)
  }

  func incrementAppUsesCount() {
    usesCount += 1
  }

  func incrementSignificantUsesCount() {
    significantEventCount += 1
  }

  func saveReminderRequestDate() {
    reminderTimeRequestToRate = Date().timeIntervalSince1970
  }

  // MARK: - Logging

  private func log(_ message: String) {
    guard Evaluate.canShowLogs else { return }
    print("[Evaluate] \(message)")
  }
}
