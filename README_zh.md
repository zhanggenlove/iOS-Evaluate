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

// 配置触发规则
Evaluate.daysUntilAlertWillBeShown = 5
Evaluate.appUsesUntilAlertWillBeShown = 10
Evaluate.significantUsesUntilAlertWillBeShown = 3
Evaluate.numberOfDaysBeforeRemindingAfterCancelation = 7

// 开始追踪
Evaluate.start()
```

### SwiftUI — 原生修饰符

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
