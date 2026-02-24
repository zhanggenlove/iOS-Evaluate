//
//  EvaluateTheme.swift
//  Evaluate
//
//  Modernized for iOS 26+
//

import SwiftUI

/// Configuration for customizing the review prompt appearance.
public struct EvaluateTheme: Sendable {

  /// The star icon gradient colors (left → right).
  public var starColors: [Color]

  /// Primary action button gradient colors.
  public var primaryGradient: [Color]

  /// Secondary action button gradient colors.
  public var secondaryGradient: [Color]

  /// Card background style.
  public var cardBackground: CardBackground

  /// Title text font.
  public var titleFont: Font

  /// Message body font.
  public var messageFont: Font

  /// Button label font.
  public var buttonFont: Font

  /// Card corner radius.
  public var cornerRadius: CGFloat

  /// Available card background styles.
  public enum CardBackground: Sendable {
    /// Ultra-thin material blur.
    case glass
    /// Solid color background.
    case solid(Color)
    /// Gradient background.
    case gradient([Color])
  }

  /// Creates a theme with vibrant defaults.
  public init(
    starColors: [Color] = [.yellow, .orange],
    primaryGradient: [Color] = [
      Color(red: 0.35, green: 0.50, blue: 1.0),
      Color(red: 0.55, green: 0.35, blue: 1.0)
    ],
    secondaryGradient: [Color] = [
      Color(red: 0.95, green: 0.95, blue: 0.97),
      Color(red: 0.90, green: 0.90, blue: 0.95)
    ],
    cardBackground: CardBackground = .glass,
    titleFont: Font = .title2.bold(),
    messageFont: Font = .subheadline,
    buttonFont: Font = .body.weight(.semibold),
    cornerRadius: CGFloat = 28
  ) {
    self.starColors = starColors
    self.primaryGradient = primaryGradient
    self.secondaryGradient = secondaryGradient
    self.cardBackground = cardBackground
    self.titleFont = titleFont
    self.messageFont = messageFont
    self.buttonFont = buttonFont
    self.cornerRadius = cornerRadius
  }

  /// The default theme with vibrant gradients.
  public static let `default` = EvaluateTheme()
}
