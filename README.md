# iOS-Evaluate

`iOS-Evaluate` is a modern, flexible, and powerful Swift Package designed to prompt your iOS app users to rate and review your app on the App Store when the conditions are just right. If they decline the rating, it allows reminding them later based on intelligent rules. 

<br/>

## 🌟 Features

- **Rule-Based Triggers**: Ask for a review only after the user has engaged with your app contextually. Check against days installed, app launches, or significant events (like completing a level or making a purchase).
- **Concurrency & Modern Support**: Built using `async/await` network checks and iOS 14+ `SKStoreReviewController.requestReview(in: windowScene)` API.
- **Deeply Customizable UI**: You can reconfigure title, message, and button texts, and customize the visual appeal of custom UIAlertControllers.
- **Fully Localized**: Ships out-of-the-box with support for over 30+ languages. 

<br/>

## 📦 Installation

### Swift Package Manager (SPM)

1. Open your project in Xcode.
2. Go to **File > Add Packages...**
3. Enter the GitHub repository URL setup for this package:
   ```text
   git@github.com:zhanggenlove/iOS-Evaluate.git
   ```
4. Choose the dependency rule (e.g., `Up to Next Major Version`) and select your app target.

<br/>

## 🛠 Usage

Integrating `Evaluate` is extremely straightforward. It is recommended to perform setup configurations in your `AppDelegate` or upon app launch, and then request evaluations at the most engaging moments in your application context.

### 1. Basic Setup

In your `SceneDelegate.swift` or `AppDelegate.swift`:

```swift
import Evaluate

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Set your exact App ID (Available in App Store Connect)
    Evaluate.appID = "YOUR_APP_ID"
    
    // Setup rules BEFORE calling Evaluate.start()
    // e.g., prompt user only after 5 days of usage
    Evaluate.daysUntilAlertWillBeShown = 5
    // OR prompt after 10 app launches
    Evaluate.appUsesUntilAlertWillBeShown = 10
    // OR prompt after 3 "significant events" manually recorded
    Evaluate.significantUsesUntilAlertWillBeShown = 3
    
    // Setup reminder delay (if user clicked 'Remind me later')
    Evaluate.numberOfDaysBeforeRemindingAfterCancelation = 7

    // Start tracking usages and prepare fetching App Store data asynchronously
    Evaluate.start()
    
    return true
}
```

### 2. Triggering the Rating Prompt

Show the prompt at a user-friendly moment (e.g., after the user completes a task, wins a game, finishes an edit, etc.). It will **only** display if the rules defined during setup are met.

```swift
import Evaluate

class ProfileViewController: UIViewController {
    
    func userDidCompleteAction() {
        // Evaluate will display the StoreKit review controller if the user has 
        // fulfilled the launch/day/event requirements and hasn't rated yet.
        Evaluate.rateApp(in: self)
    }
}
```

### 3. Tracking Significant Events

If you rely on `Evaluate.significantUsesUntilAlertWillBeShown`, you can manually increment the counter every time the user performs a high-value action. 

```swift
// Example: user uploaded a photo successfully
Evaluate.default.incrementSignificantUseCount()
```

<br/>

## 🎨 Customizing the Alert 

`Evaluate` allows you to customize the alert text shown to your users. Simply assign custom localized strings to its properties during setup:

```swift
// Example of customized string configurations
Evaluate.alertTitle = "Enjoying Our App?"
Evaluate.alertMessage = "If you like our app, please take a moment to leave a review!"
Evaluate.alertRateAppTitle = "Rate 5 Stars"
Evaluate.alertAppStoreTitle = "Write a Review"
Evaluate.alertRemindLaterTitle = "Maybe Later"
Evaluate.alertCancelTitle = "No, Thanks"
```

<br/>

## 🧑‍💻 Debugging
During development, if you want to bypass all logic rules and continually display the rating alert for testing the UI, turn on the debug flag:
```swift
Evaluate.activateDebugMode = true
```
> **❗️ Note:** Make sure to turn this `= false` (or remove it) before shipping your app to production!

<br/>

## ⚙️ App Store Checking Notes
`EvaluateHelper` connects via `async/await` to iTunes to fetch and track real app data (version logic vs bundle check). It requires an active internet connection to pre-fetch App ID validation.

---

*Powered by [iOS-Evaluate](https://github.com/zhanggenlove/iOS-Evaluate).*
