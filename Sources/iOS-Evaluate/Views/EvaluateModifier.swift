//
//  EvaluateModifier.swift
//  Evaluate
//
//  SwiftUI ViewModifier for review prompts.
//

import SwiftUI
import StoreKit

/// A SwiftUI view modifier that presents the Evaluate review prompt.
///
/// Usage:
/// ```swift
/// ContentView()
///   .evaluateReviewPrompt(isPresented: $showReview)
/// ```
public struct EvaluateReviewModifier: ViewModifier {

  @Binding var isPresented: Bool
  let theme: EvaluateTheme

  public func body(content: Content) -> some View {
    content
      .fullScreenCover(isPresented: $isPresented) {
        evaluateView
          .background(ClearBackgroundView())
      }
  }

  @MainActor
  private var evaluateView: some View {
    let appName = Evaluate.appName ?? Bundle.appName

    return EvaluateReviewView(
      title: Evaluate.alertTitle ?? String(format: String.localize("Rate %@"), appName),
      message: Evaluate.alertMessage ?? String(format: String.localize("Rater.title"), appName),
      rateButtonTitle: Evaluate.alertRateAppTitle ?? String(format: String.localize("Rate %@"), appName),
      writeReviewButtonTitle: Evaluate.alertAppStoreTitle ?? String.localize("Write a review on App Store"),
      remindLaterButtonTitle: Evaluate.showRemindLaterButton
        ? (Evaluate.alertRemindLaterTitle ?? String.localize("Remind me later"))
        : nil,
      cancelButtonTitle: Evaluate.alertCancelTitle ?? String.localize("No, Thanks"),
      theme: theme,
      onRateApp: {
        if let scene = UIApplication.shared.connectedScenes
          .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
          AppStore.requestReview(in: scene)
        }
        isPresented = false
      },
      onWriteReview: {
        UIApplication.shared.rateAppInAppStore(using: Evaluate.appID)
        isPresented = false
      },
      onRemindLater: {
        UserPreferencesManager.default.saveReminderRequestDate()
        isPresented = false
      },
      onCancel: {
        UserPreferencesManager.default.isRateDone = true
        isPresented = false
      }
    )
  }
}

/// Transparent background helper for fullScreenCover.
private struct ClearBackgroundView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - View Extension

public extension View {
  /// Present the Evaluate review prompt with a custom theme.
  func evaluateReviewPrompt(
    isPresented: Binding<Bool>,
    theme: EvaluateTheme = .default
  ) -> some View {
    modifier(EvaluateReviewModifier(isPresented: isPresented, theme: theme))
  }
}
