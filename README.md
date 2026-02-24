# iOS-Evaluate

[![Swift](https://img.shields.io/badge/Swift-6.2-orange?logo=swift)](https://www.swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS_26+-blue?logo=apple)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen?logo=swift)](https://swift.org/package-manager/)

A modern, beautiful app review prompt library for iOS 26+. Built with **SwiftUI gradient design**, **Swift 6 concurrency**, and full **localization** support (30+ languages).

<br/>

<p align="center">
  <img src="Assets/preview.png" width="300" alt="iOS-Evaluate Preview" />
</p>

<br/>

## ✨ Highlights

| Feature | Description |
|---|---|
| 🎨 **Gradient UI** | Vibrant gradient buttons, animated gold star icons, and haptic feedback |
| 🎯 **Smart Triggers** | Prompt based on days installed, app launches, or significant events |
| 🔄 **SwiftUI + UIKit** | Native `.evaluateReviewPrompt()` modifier AND `UIViewController` support |
| 🌍 **30+ Languages** | Ships with localization for Afrikaans to Vietnamese |
| ⚡ **Swift 6 Ready** | `@MainActor`, `Sendable`, `async/await` throughout |
| 📳 **Haptic Feedback** | Subtle tactile responses on button interactions |

<br/>

## 📦 Installation

### Swift Package Manager

1. In Xcode, go to **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/zhanggenlove/iOS-Evaluate.git
   ```
3. Choose version rule and add to your target.

<br/>

## 🛠 Usage

### Setup (AppDelegate / App init)

```swift
import Evaluate

// Configure trigger rules
Evaluate.daysUntilAlertWillBeShown = 5
Evaluate.appUsesUntilAlertWillBeShown = 10
Evaluate.significantUsesUntilAlertWillBeShown = 3
Evaluate.numberOfDaysBeforeRemindingAfterCancelation = 7

// Start tracking
Evaluate.start()
```

### SwiftUI — Native Modifier

```swift
import SwiftUI
import Evaluate

struct ContentView: View {
  @State private var showReview = false

  var body: some View {
    Button("Complete Task") {
      if Evaluate.isRateDone == false {
        showReview = true
      }
    }
    .evaluateReviewPrompt(isPresented: $showReview)
  }
}
```

### UIKit — One Line

```swift
import Evaluate

class MyViewController: UIViewController {
  func taskCompleted() {
    Evaluate.rateApp(in: self)
  }
}
```

<br/>

## 🎨 Theming

Customize the review card appearance with `EvaluateTheme`:

```swift
Evaluate.theme = EvaluateTheme(
  starColors:       [.yellow, .orange],
  primaryGradient:  [.blue, .purple],
  secondaryGradient:[.gray.opacity(0.1), .gray.opacity(0.15)],
  cornerRadius:     28
)
```

<br/>

## 🧪 Debug Mode

Bypass all trigger rules during development:

```swift
Evaluate.activateDebugMode = true
```

> ⚠️ Remember to disable this before releasing to the App Store.

<br/>

## 🌐 Localization

iOS-Evaluate ships with translations for **30+ languages** including:

English, 简体中文, 繁體中文, 日本語, 한국어, Français, Deutsch, Español, Português, Italiano, Русский, العربية, हिन्दी, Tiếng Việt, and many more.

The library auto-detects the user's system language. No additional setup required.

<br/>

## 📋 Requirements

| Requirement | Version |
|---|---|
| iOS | 26.0+ |
| Swift | 6.2+ |
| Xcode | 26+ |

<br/>

## 📄 License

iOS-Evaluate is available under the [MIT License](LICENSE).
