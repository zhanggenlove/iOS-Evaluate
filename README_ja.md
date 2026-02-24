<p align="right">
  <a href="README.md">English</a> · <a href="README_zh.md">简体中文</a> · <a href="README_ja.md">日本語</a> · <a href="README_ko.md">한국어</a>
</p>

# iOS-Evaluate

[![Swift](https://img.shields.io/badge/Swift-6.2-orange?logo=swift)](https://www.swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS_26+-blue?logo=apple)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen?logo=swift)](https://swift.org/package-manager/)

iOS 26+ 向けのモダンでスタイリッシュなアプリレビュー促進ライブラリ。**SwiftUI グラデーションデザイン**、**Swift 6 並行処理**、**30 以上の言語ローカライズ** に対応。

<br/>

<p align="center">
  <img src="Assets/preview.png" width="300" alt="iOS-Evaluate プレビュー" />
</p>

<br/>

## ✨ ハイライト

| 機能 | 説明 |
|---|---|
| 🎨 **グラデーション UI** | 鮮やかなグラデーションボタン、アニメーション付きゴールドスター、触覚フィードバック |
| 🎯 **スマートトリガー** | インストール日数、起動回数、重要イベントに基づいて自動表示 |
| 🔄 **SwiftUI + UIKit** | ネイティブ `.evaluateReviewPrompt()` モディファイア & `UIViewController` サポート |
| 🌍 **30 以上の言語** | アフリカーンス語からベトナム語まで完全ローカライズ |
| ⚡ **Swift 6 対応** | `@MainActor`、`Sendable`、`async/await` を全面採用 |
| 📳 **触覚フィードバック** | ボタン操作時に繊細な触覚応答を提供 |

<br/>

## 📦 インストール

### Swift Package Manager

1. Xcode で **File → Add Package Dependencies...** を選択
2. リポジトリ URL を入力：
   ```
   https://github.com/zhanggenlove/iOS-Evaluate.git
   ```
3. バージョンルールを選択し、ターゲットに追加。

<br/>

## 🛠 使い方

### 初期設定（AppDelegate / App init）

```swift
import Evaluate

// トリガールールを設定
Evaluate.daysUntilAlertWillBeShown = 5
Evaluate.appUsesUntilAlertWillBeShown = 10
Evaluate.significantUsesUntilAlertWillBeShown = 3
Evaluate.numberOfDaysBeforeRemindingAfterCancelation = 7

// トラッキング開始
Evaluate.start()
```

### SwiftUI — ネイティブモディファイア

```swift
import SwiftUI
import Evaluate

struct ContentView: View {
  @State private var showReview = false

  var body: some View {
    Button("タスク完了") {
      if Evaluate.isRateDone == false {
        showReview = true
      }
    }
    .evaluateReviewPrompt(isPresented: $showReview)
  }
}
```

### UIKit — 1 行で完了

```swift
import Evaluate

class MyViewController: UIViewController {
  func taskCompleted() {
    Evaluate.rateApp(in: self)
  }
}
```

<br/>

## 🎨 テーマカスタマイズ

`EvaluateTheme` でレビューカードの外観をカスタマイズ：

```swift
Evaluate.theme = EvaluateTheme(
  starColors:       [.yellow, .orange],
  primaryGradient:  [.blue, .purple],
  secondaryGradient:[.gray.opacity(0.1), .gray.opacity(0.15)],
  cornerRadius:     28
)
```

<br/>

## 🧪 デバッグモード

開発中にすべてのトリガー条件をバイパス：

```swift
Evaluate.activateDebugMode = true
```

> ⚠️ App Store にリリースする前に必ず無効にしてください。

<br/>

## 🌐 ローカライズ

iOS-Evaluate は **30 以上の言語** の翻訳を内蔵：

English、简体中文、繁體中文、日本語、한국어、Français、Deutsch、Español、Português、Italiano、Русский、العربية、हिन्दी、Tiếng Việt など。

ライブラリはシステム言語を自動検出します。追加設定は不要です。

<br/>

## 📋 要件

| 要件 | バージョン |
|---|---|
| iOS | 26.0+ |
| Swift | 6.2+ |
| Xcode | 26+ |

<br/>

## 📄 ライセンス

iOS-Evaluate は [MIT ライセンス](LICENSE) の下で公開されています。
