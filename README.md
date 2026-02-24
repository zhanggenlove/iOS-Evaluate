<p align="right">
  <a href="README.md">English</a> · <a href="README_zh.md">简体中文</a> · <a href="README_ja.md">日本語</a> · <a href="README_ko.md">한국어</a>
</p>

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

// ① Required — Set your App Store ID
Evaluate.appID = "123456789"

// ② Required — Set your app name (used in the prompt title)
Evaluate.appName = "MyApp"

// ③ Configure trigger rules (all optional, set any combination)
Evaluate.daysUntilAlertWillBeShown = 5                    // Days since first launch
Evaluate.appUsesUntilAlertWillBeShown = 10                // Number of app launches
Evaluate.significantUsesUntilAlertWillBeShown = 3         // Significant events count
Evaluate.numberOfDaysBeforeRemindingAfterCancelation = 7  // Re-prompt delay after "Remind me later"

// ④ Start tracking (call once at launch)
Evaluate.start()
```

> [!TIP]
> If you don't set `appID` manually, the library will attempt to auto-detect it via the iTunes Search API using your app's Bundle ID. However, **setting it explicitly is recommended** for reliability.

### Configuration Reference

| Property | Type | Default | Description |
|---|---|---|---|
| `appID` | `String?` | Auto-detected | Your App Store app ID (found in App Store Connect) |
| `appName` | `String?` | `CFBundleDisplayName` | App name shown in the prompt title |
| `alertTitle` | `String?` | Localized | Custom title text |
| `alertMessage` | `String?` | Localized | Custom message body |
| `alertRateAppTitle` | `String?` | Localized | "Rate" button label |
| `alertAppStoreTitle` | `String?` | Localized | "Write a review" button label |
| `alertRemindLaterTitle` | `String?` | Localized | "Remind me later" button label |
| `alertCancelTitle` | `String?` | Localized | "No thanks" button label |
| `showRemindLaterButton` | `Bool` | `true` | Show/hide the "Remind me later" option |
| `resetEverythingWhenAppIsUpdated` | `Bool` | `true` | Reset all tracking data on app version change |
| `canShowLogs` | `Bool` | `false` | Enable console logging for debugging |
| `activateDebugMode` | `Bool` | `false` | Always show the prompt (bypass all rules) |

### Show the Prompt

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
