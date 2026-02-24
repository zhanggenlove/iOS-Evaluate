//
//  EvaluateReviewView.swift
//  Evaluate
//
//  iOS 26+ Glassmorphic Review Card
//

import SwiftUI
import StoreKit

/// A modern review prompt card with glassmorphic design.
struct EvaluateReviewView: View {

  let title: String
  let message: String
  let rateButtonTitle: String?
  let writeReviewButtonTitle: String
  let remindLaterButtonTitle: String?
  let cancelButtonTitle: String?
  let theme: EvaluateTheme

  var onRateApp: (() -> Void)?
  var onWriteReview: (() -> Void)?
  var onRemindLater: (() -> Void)?
  var onCancel: (() -> Void)?

  @State private var appeared = false
  @State private var starScale: [CGFloat] = [0, 0, 0, 0, 0]

  var body: some View {
    ZStack {
      // Dimmed background
      Color.black.opacity(appeared ? 0.4 : 0)
        .ignoresSafeArea()
        .onTapGesture { /* block dismiss */ }

      // Card
      VStack(spacing: 20) {
        // Stars header
        starsRow
          .padding(.top, 8)

        // Title
        Text(title)
          .font(theme.titleFont)
          .multilineTextAlignment(.center)
          .foregroundStyle(.primary)

        // Message
        Text(message)
          .font(theme.messageFont)
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)

        // Buttons
        VStack(spacing: 10) {
          if let rateTitle = rateButtonTitle {
            actionButton(rateTitle, role: .primary) {
              haptic(.success)
              onRateApp?()
            }
          }

          actionButton(writeReviewButtonTitle, role: .secondary) {
            haptic(.light)
            onWriteReview?()
          }

          if let remindTitle = remindLaterButtonTitle {
            textButton(remindTitle) {
              haptic(.light)
              onRemindLater?()
            }
          }

          if let cancelTitle = cancelButtonTitle {
            textButton(cancelTitle) {
              onCancel?()
            }
          }
        }
        .padding(.top, 4)
      }
      .padding(24)
      .frame(maxWidth: 320)
      .background {
        RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous)
          .fill(.ultraThinMaterial)
          .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
      }
      .overlay {
        RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous)
          .strokeBorder(
            LinearGradient(
              colors: [.white.opacity(0.4), .white.opacity(0.1)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 0.5
          )
      }
      .scaleEffect(appeared ? 1 : 0.8)
      .opacity(appeared ? 1 : 0)
    }
    .animation(.spring(duration: 0.5, bounce: 0.3), value: appeared)
    .onAppear {
      appeared = true
      animateStars()
    }
  }

  // MARK: - Star Rating Row

  private var starsRow: some View {
    HStack(spacing: 6) {
      ForEach(0..<5, id: \.self) { index in
        Image(systemName: "star.fill")
          .font(.title2)
          .foregroundStyle(theme.accentColor)
          .scaleEffect(starScale[index])
          .animation(
            .spring(duration: 0.4, bounce: 0.5)
              .delay(Double(index) * 0.08),
            value: starScale[index]
          )
      }
    }
  }

  private func animateStars() {
    for i in 0..<5 {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.08) {
        starScale[i] = 1.0
      }
    }
  }

  // MARK: - Button Components

  @ViewBuilder
  private func actionButton(_ title: String, role: ButtonRole, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text(title)
        .font(theme.buttonFont)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background {
          switch role {
          case .primary:
            RoundedRectangle(cornerRadius: 14, style: .continuous)
              .fill(.thinMaterial)
              .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                  .strokeBorder(.quaternary, lineWidth: 0.5)
              }
          case .secondary:
            RoundedRectangle(cornerRadius: 14, style: .continuous)
              .fill(.ultraThinMaterial)
              .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                  .strokeBorder(.quaternary, lineWidth: 0.5)
              }
          }
        }
        .foregroundStyle(.primary)
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  private func textButton(_ title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    .buttonStyle(.plain)
  }

  // MARK: - Haptics

  private func haptic(_ style: HapticStyle) {
    switch style {
    case .success:
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
    case .light:
      let generator = UIImpactFeedbackGenerator(style: .light)
      generator.impactOccurred()
    }
  }

  private enum HapticStyle {
    case success, light
  }

  private enum ButtonRole {
    case primary, secondary
  }
}
