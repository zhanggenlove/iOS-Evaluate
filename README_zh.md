<p align="right">
  <a href="README.md">English</a> · <a href="README_zh.md">简体中文</a> · <a href="README_ja.md">日本語</a> · <a href="README_ko.md">한국어</a>
</p>

# iOS-Evaluate

[![Swift](https://img.shields.io/badge/Swift-6.2-orange?logo=swift)](https://www.swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS_26+-blue?logo=apple)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen?logo=swift)](https://swift.org/package-manager/)

一个现代化、精美的 iOS 应用评分弹窗库，专为 iOS 26+ 打造。基于 **SwiftUI 渐变设计**、**Swift 6 并发安全** 和 **30+ 语言本地化** 支持。

<br/>

<p align="center">
  <img src="Assets/preview.png" width="300" alt="iOS-Evaluate 预览" />
</p>

<br/>

## ✨ 亮点

| 特性 | 描述 |
|---|---|
| 🎨 **渐变 UI** | 渐变色按钮、动态金色星星图标、触觉反馈 |
| 🎯 **智能触发** | 基于安装天数、启动次数或重要事件自动触发 |
| 🔄 **SwiftUI + UIKit** | 原生 `.evaluateReviewPrompt()` 修饰符及 `UIViewController` 支持 |
| 🌍 **30+ 语言** | 内置从南非语到越南语的完整本地化 |
| ⚡ **Swift 6 就绪** | 全面使用 `@MainActor`、`Sendable`、`async/await` |
| 📳 **触觉反馈** | 按钮交互时提供细腻的触觉响应 |

<br/>

## 📦 安装

### Swift Package Manager

1. 在 Xcode 中，前往 **File → Add Package Dependencies...**
2. 输入仓库地址：
   ```
   https://github.com/zhanggenlove/iOS-Evaluate.git
   ```
3. 选择版本规则并添加到你的 Target。

<br/>

## 🛠 使用方法

### 初始化配置（AppDelegate / App init）

```swift
import Evaluate

// ① 必填 — 设置你的 App Store ID
Evaluate.appID = "123456789"

// ② 必填 — 设置应用名称（用于弹窗标题）
Evaluate.appName = "我的应用"

// ③ 配置触发规则（均为可选，可任意组合）
Evaluate.daysUntilAlertWillBeShown = 5                    // 首次启动后的天数
Evaluate.appUsesUntilAlertWillBeShown = 10                // 应用启动次数
Evaluate.significantUsesUntilAlertWillBeShown = 3         // 重要事件次数
Evaluate.numberOfDaysBeforeRemindingAfterCancelation = 7  // 点击"稍后提醒"后的再次提示间隔天数

// ④ 开始追踪（启动时调用一次）
Evaluate.start()
```

> [!TIP]
> 如果未手动设置 `appID`，库会通过 iTunes Search API 根据 Bundle ID 自动检测。但**强烈建议手动设置**以确保可靠性。

### 配置参考

| 属性 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `appID` | `String?` | 自动检测 | App Store 应用 ID（在 App Store Connect 中查看） |
| `appName` | `String?` | `CFBundleDisplayName` | 弹窗标题中显示的应用名称 |
| `alertTitle` | `String?` | 本地化文本 | 自定义标题 |
| `alertMessage` | `String?` | 本地化文本 | 自定义消息内容 |
| `alertRateAppTitle` | `String?` | 本地化文本 | "评分"按钮文字 |
| `alertAppStoreTitle` | `String?` | 本地化文本 | "撰写评论"按钮文字 |
| `alertRemindLaterTitle` | `String?` | 本地化文本 | "稍后提醒"按钮文字 |
| `alertCancelTitle` | `String?` | 本地化文本 | "取消"按钮文字 |
| `showRemindLaterButton` | `Bool` | `true` | 是否显示"稍后提醒"选项 |
| `resetEverythingWhenAppIsUpdated` | `Bool` | `true` | 应用版本更新时重置所有追踪数据 |
| `canShowLogs` | `Bool` | `false` | 启用控制台日志输出 |
| `activateDebugMode` | `Bool` | `false` | 始终显示弹窗（跳过所有条件判断） |

### 触发弹窗

```swift
import SwiftUI
import Evaluate

struct ContentView: View {
  @State private var showReview = false

  var body: some View {
    Button("完成任务") {
      if Evaluate.isRateDone == false {
        showReview = true
      }
    }
    .evaluateReviewPrompt(isPresented: $showReview)
  }
}
```

### UIKit — 一行代码

```swift
import Evaluate

class MyViewController: UIViewController {
  func taskCompleted() {
    Evaluate.rateApp(in: self)
  }
}
```

<br/>

## 🎨 主题定制

通过 `EvaluateTheme` 自定义评分卡片外观：

```swift
Evaluate.theme = EvaluateTheme(
  starColors:       [.yellow, .orange],
  primaryGradient:  [.blue, .purple],
  secondaryGradient:[.gray.opacity(0.1), .gray.opacity(0.15)],
  cornerRadius:     28
)
```

<br/>

## 🧪 调试模式

在开发阶段跳过所有触发条件：

```swift
Evaluate.activateDebugMode = true
```

> ⚠️ 发布到 App Store 前请记得关闭此选项。

<br/>

## 🌐 本地化

iOS-Evaluate 内置 **30+ 语言** 翻译，包括：

English、简体中文、繁體中文、日本語、한국어、Français、Deutsch、Español、Português、Italiano、Русский、العربية、हिन्दी、Tiếng Việt 等。

库会自动检测系统语言，无需额外配置。

<br/>

## 📋 要求

| 要求 | 版本 |
|---|---|
| iOS | 26.0+ |
| Swift | 6.2+ |
| Xcode | 26+ |

<br/>

## 📄 许可证

iOS-Evaluate 基于 [MIT 许可证](LICENSE) 开源。
