//
//  EvaluateTheme.swift
//  Evaluate
//
//  Modernized for iOS 26+
//

import SwiftUI

/// Configuration for customizing the review prompt appearance.
public struct EvaluateTheme: Sendable {

  /// The image displayed at the top of the review card.
  public var headerImage: Image?

  /// Accent color used for primary action buttons.
  public var accentColor: Color

  /// Color for secondary/cancel actions.
  public var secondaryColor: Color

  /// Title text font.
  public var titleFont: Font

  /// Message body font.
  public var messageFont: Font

  /// Button label font.
  public var buttonFont: Font

  /// Card corner radius.
  public var cornerRadius: CGFloat

  /// Creates a theme with sensible defaults.
  public init(
    headerImage: Image? = Image(systemName: "star.fill"),
    accentColor: Color = .yellow,
    secondaryColor: Color = .secondary,
    titleFont: Font = .title2.bold(),
    messageFont: Font = .subheadline,
    buttonFont: Font = .body.weight(.medium),
    cornerRadius: CGFloat = 24
  ) {
    self.headerImage = headerImage
    self.accentColor = accentColor
    self.secondaryColor = secondaryColor
    self.titleFont = titleFont
    self.messageFont = messageFont
    self.buttonFont = buttonFont
    self.cornerRadius = cornerRadius
  }

  /// The default theme.
  public static let `default` = EvaluateTheme()
}
