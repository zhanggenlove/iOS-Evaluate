<p align="right">
  <a href="README.md">English</a> · <a href="README_zh.md">简体中文</a> · <a href="README_ja.md">日本語</a> · <a href="README_ko.md">한국어</a>
</p>

# iOS-Evaluate

[![Swift](https://img.shields.io/badge/Swift-6.2-orange?logo=swift)](https://www.swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS_26+-blue?logo=apple)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen?logo=swift)](https://swift.org/package-manager/)
[![CocoaPods](https://img.shields.io/cocoapods/v/iOS-Evaluate?logo=cocoapods&color=red)](https://cocoapods.org/pods/iOS-Evaluate)

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

### CocoaPods

`Podfile` に追加：

```ruby
pod 'iOS-Evaluate', '~> 2.0'
```

次に実行：

```bash
pod install
```

<br/>

## 🛠 使い方

### 初期設定（AppDelegate / App init）

```swift
import Evaluate

// ① 必須 — App Store ID を設定
Evaluate.appID = "123456789"

// ② 必須 — アプリ名を設定（プロンプトタイトルに使用）
Evaluate.appName = "マイアプリ"

// ③ トリガールールを設定（すべてオプション、任意の組み合わせ可能）
Evaluate.daysUntilAlertWillBeShown = 5                    // 初回起動からの日数
Evaluate.appUsesUntilAlertWillBeShown = 10                // アプリ起動回数
Evaluate.significantUsesUntilAlertWillBeShown = 3         // 重要イベント回数
Evaluate.numberOfDaysBeforeRemindingAfterCancelation = 7  //「後で通知」後の再プロンプト間隔日数

// ④ トラッキング開始（起動時に1回呼び出し）
Evaluate.start()
```

> [!TIP]
> `appID` を手動設定しない場合、ライブラリは Bundle ID を使用して iTunes Search API 経由で自動検出を試みます。ただし、信頼性のために**手動設定を強く推奨**します。

### 設定リファレンス

| プロパティ | 型 | デフォルト | 説明 |
|---|---|---|---|
| `appID` | `String?` | 自動検出 | App Store アプリ ID（App Store Connect で確認） |
| `appName` | `String?` | `CFBundleDisplayName` | プロンプトタイトルに表示されるアプリ名 |
| `alertTitle` | `String?` | ローカライズ | カスタムタイトルテキスト |
| `alertMessage` | `String?` | ローカライズ | カスタムメッセージ本文 |
| `alertRateAppTitle` | `String?` | ローカライズ | 「評価」ボタンラベル |
| `alertAppStoreTitle` | `String?` | ローカライズ | 「レビューを書く」ボタンラベル |
| `alertRemindLaterTitle` | `String?` | ローカライズ | 「後で通知」ボタンラベル |
| `alertCancelTitle` | `String?` | ローカライズ | 「キャンセル」ボタンラベル |
| `showRemindLaterButton` | `Bool` | `true` | 「後で通知」オプションの表示/非表示 |
| `resetEverythingWhenAppIsUpdated` | `Bool` | `true` | アプリバージョン変更時にトラッキングデータをリセット |
| `canShowLogs` | `Bool` | `false` | コンソールログを有効化 |
| `activateDebugMode` | `Bool` | `false` | 常にプロンプトを表示（すべてのルールをバイパス） |

### プロンプトを表示

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
