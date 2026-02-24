//
//  EvaluateReviewView.swift
//  Evaluate
//
//  iOS 26+ Premium Review Card
//

import SwiftUI
import StoreKit

/// A premium review prompt card with gradients, animations, and haptic feedback.
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
  @State private var shimmerOffset: CGFloat = -200

  var body: some View {
    ZStack {
      // Dimmed background with blur
      Color.black.opacity(appeared ? 0.45 : 0)
        .ignoresSafeArea()
        .onTapGesture { /* block dismiss */ }

      // Card
      VStack(spacing: 0) {
        // ── Stars ──
        starsRow
          .padding(.top, 28)
          .padding(.bottom, 16)

        // ── Title ──
        Text(title)
          .font(theme.titleFont)
          .multilineTextAlignment(.center)
          .foregroundStyle(.primary)
          .padding(.horizontal, 8)

        // ── Message ──
        Text(message)
          .font(theme.messageFont)
          .multilineTextAlignment(.center)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.top, 8)
          .padding(.horizontal, 4)

        // ── Action Buttons ──
        VStack(spacing: 12) {
          if let rateTitle = rateButtonTitle {
            primaryButton(rateTitle) {
              haptic(.success)
              onRateApp?()
            }
          }

          secondaryButton(writeReviewButtonTitle) {
            haptic(.light)
            onWriteReview?()
          }
        }
        .padding(.top, 24)

        // ── Text Links ──
        VStack(spacing: 4) {
          if let remindTitle = remindLaterButtonTitle {
            linkButton(remindTitle) {
              haptic(.light)
              onRemindLater?()
            }
          }

          if let cancelTitle = cancelButtonTitle {
            linkButton(cancelTitle) {
              onCancel?()
            }
            .opacity(0.6)
          }
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
      }
      .padding(.horizontal, 24)
      .frame(maxWidth: 330)
      .background { cardBackgroundView }
      .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous))
      .overlay {
        RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous)
          .strokeBorder(
            LinearGradient(
              colors: [.white.opacity(0.5), .white.opacity(0.1), .clear],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 0.5
          )
      }
      .shadow(color: .black.opacity(0.2), radius: 30, y: 15)
      .shadow(color: theme.primaryGradient.first?.opacity(0.15) ?? .clear, radius: 40, y: 20)
      .scaleEffect(appeared ? 1 : 0.85)
      .opacity(appeared ? 1 : 0)
    }
    .animation(.spring(duration: 0.55, bounce: 0.25), value: appeared)
    .onAppear {
      appeared = true
      animateStars()
    }
  }

  // MARK: - Card Background

  @ViewBuilder
  private var cardBackgroundView: some View {
    switch theme.cardBackground {
    case .glass:
      ZStack {
        Rectangle().fill(.ultraThinMaterial)
        // Subtle white gradient overlay for depth
        LinearGradient(
          colors: [.white.opacity(0.08), .clear],
          startPoint: .top,
          endPoint: .bottom
        )
      }
    case .solid(let color):
      Rectangle().fill(color)
    case .gradient(let colors):
      LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
  }

  // MARK: - Star Rating Row

  private var starsRow: some View {
    HStack(spacing: 8) {
      ForEach(0..<5, id: \.self) { index in
        Image(systemName: "star.fill")
          .font(.title)
          .foregroundStyle(
            LinearGradient(
              colors: theme.starColors,
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .shadow(color: theme.starColors.first?.opacity(0.4) ?? .clear, radius: 4, y: 2)
          .scaleEffect(starScale[index])
          .animation(
            .spring(duration: 0.45, bounce: 0.55)
              .delay(Double(index) * 0.07),
            value: starScale[index]
          )
      }
    }
  }

  private func animateStars() {
    for i in 0..<5 {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.07) {
        starScale[i] = 1.0
      }
    }
  }

  // MARK: - Primary Button (Gradient)

  @ViewBuilder
  private func primaryButton(_ title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text(title)
        .font(theme.buttonFont)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(
              LinearGradient(
                colors: theme.primaryGradient,
                startPoint: .leading,
                endPoint: .trailing
              )
            )
            .shadow(color: theme.primaryGradient.first?.opacity(0.35) ?? .clear, radius: 10, y: 5)
        }
    }
    .buttonStyle(ScaleButtonStyle())
  }

  // MARK: - Secondary Button

  @ViewBuilder
  private func secondaryButton(_ title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text(title)
        .font(theme.buttonFont)
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color(.systemBackground).opacity(0.6))
            .overlay {
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            }
        }
    }
    .buttonStyle(ScaleButtonStyle())
  }

  // MARK: - Link Button

  @ViewBuilder
  private func linkButton(_ title: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
    .buttonStyle(.plain)
  }

  // MARK: - Haptics

  private func haptic(_ style: HapticStyle) {
    switch style {
    case .success:
      UINotificationFeedbackGenerator().notificationOccurred(.success)
    case .light:
      UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
  }

  private enum HapticStyle { case success, light }
}

// MARK: - Scale Button Style

private struct ScaleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.96 : 1)
      .opacity(configuration.isPressed ? 0.85 : 1)
      .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
  }
}
