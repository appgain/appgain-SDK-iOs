# CLAUDE.md — Appgain iOS SDK

## Repository overview

This is the **Appgain iOS SDK** (`appgain/appgain-SDK-iOs`), an Objective-C library that integrates iOS apps with the [Appgain.io](https://appgain.io) cloud platform. It is distributed both as a CocoaPod and via Swift Package Manager (SPM).

**Current versions**
- Pod version: `4.0.0` (Appgain.podspec)
- SDK runtime version constant: `4.4.0` (defined in `Sources/include/UrlData.h`)

---

## Repository structure

```
appgain-SDK-iOs/
├── Sources/               # Core SDK — Appgain target
│   ├── include/           # Public headers (.h)
│   └── *.m                # Implementations
├── Sources-rich/          # Rich-push add-on — Appgain-rich target
│   ├── include/           # Public header (AppgainRich.h)
│   ├── CarouselNotificationHandler/  # Carousel push-notification UI
│   └── AppgainRich.m
├── Appgain-rich/          # Legacy CocoaPod sources for Appgain-rich
│   ├── Appgain--Rich.h
│   └── Appgain--Rich.m
├── Package.swift          # SPM manifest (swift-tools-version 5.1)
├── Appgain.podspec        # Core pod spec (iOS 9.0+)
├── Appgain-Rich.podspec   # Rich-push pod spec
└── .deepsource.toml       # DeepSource static-analysis config
```

### SPM products/targets

| Product | Target | Source path |
|---------|--------|-------------|
| `Appgain` | `Appgain` | `Sources/` |
| `Appgain-rich` | `Appgain-rich` | `Sources-rich/` |

---

## Core SDK — `Sources/`

### Public API (`Sources/include/Appgain.h`)

All public methods are **class methods** on the `Appgain` singleton-style class. There are two variants of every method: one with a completion block and one fire-and-forget.

| Method | Purpose |
|--------|---------|
| `+initialize:apiKey:subDomain:trackUserForAdvertising:whenFinish:` | Bootstrap the SDK — must be the first call |
| `+updateUserData:whenFinish:` | Push user properties to the backend |
| `+updateUserId:whenFinish:` | Associate a custom user ID |
| `+getUserData:` | Fetch user record from the server |
| `+matchLink:` | Resolve a deferred deep link on first launch |
| `+updateMatchingData::` | Upload attribution data after first match |
| `+RegisterDeviceWithToken:` | Register APNs device token for push |
| `+handlePush:forApplication:` | Track received push notification |
| `+recordPushStatus:userInfo:whenFinish:` | Track push status (opened/received/conversion) |
| `+createSmartLink:whenFinish:` | Create a Smart Deep Link |
| `+createLandingPage:whenFinish:` | Create a Mobile Landing Page |
| `+fireAutomator:personalizationData:whenFinish:` | Trigger an Automator rule |
| `+cancelAutomator:whenFinish:` | Cancel an Automator rule |
| `+logEvent:andAction:extras:whenFinish:` | Log a custom event |
| `+logPurchase:withAmount:forCurrency:whenFinish:` | Log a purchase event |
| `+enableNotifications:` | Toggle push notification opt-in/out |
| `+createNotificationChannel:withData:whenFinish:` | Register a notification channel |
| `+getUserID` | Return the Appgain user ID (NSUserDefaults) |

### Key supporting classes

| Class | File | Role |
|-------|------|------|
| `SdkKeys` | `Sources/SdkKeys.m` | NSUserDefaults wrapper — persists appID, apiKey, userID, device token, ADID, etc. |
| `ServiceLayer` | `Sources/ServiceLayer.m` | NSURLSession HTTP client; `requestWithURL:httpWay:` (GET/DELETE) and `postRequestWithURL:withBodyData:withParameters:` |
| `UrlData` | `Sources/UrlData.m` | URL factory — all API endpoint strings; also defines the `sdkVersion` constant (`@"4.4.0"`) |
| `SmartDeepLink` | `Sources/SmartDeepLink.m` | Model for creating smart links |
| `MobileLandingPage` | `Sources/MobileLandingPage.m` | Model for landing page creation |
| `NotificationStatus` | `Sources/NotificationStatus.m` | Constants: `Received`, `Opened`, `Conversion` |
| `NotificationType` | `Sources/NotificationType.m` | Push notification type constants |
| `TargetPlatform` | `Sources/TargetPlatform.m` | Platform constants |

### Data models (`Sources/include/DataModels.h`)

Aggregated header that re-exports `SmartDeepLink.h`, `MobileLandingPage.h`, `MobileLandingPageButton.h`, `SocialmediaSettings.h`, `UrlData.h`.

---

## Rich push add-on — `Sources-rich/`

Provides carousel-style rich push notification UI.

| File | Role |
|------|------|
| `AppgainRich.m` / `include/AppgainRich.h` | Entry point for the rich-push extension |
| `CarouselHandler.m/.h` | Handles carousel notification rendering |
| `CarouselCollectionViewCell.m/.h` | UICollectionViewCell for a single carousel slide |

---

## Platform requirements

- **iOS deployment target**: 9.0 (CocoaPod) / not constrained in Package.swift
- **Frameworks**: UIKit, CoreTelephony, StoreKit, AdServices
- **ATT (App Tracking Transparency)**: requested at runtime when `trackAdvertisingId = YES`; falls back gracefully on iOS < 14

---

## Installation

### CocoaPods

```ruby
pod 'Appgain', :git => 'https://github.com/appgain/appgain-SDK-iOs.git', :tag => '4.0.0'
# For rich push:
pod 'Appgain-rich', :git => 'https://github.com/appgain/appgain-SDK-iOs.git', :tag => '4.0.0'
```

### Swift Package Manager

Add the GitHub URL `https://github.com/appgain/appgain-SDK-iOs.git` and select the products `Appgain` and/or `Appgain-rich`.

Full integration steps: [docs.appgain.io](https://docs.appgain.io/SDK/ios/installAppgainSDK/)

---

## SDK initialisation flow

1. App calls `+initialize:apiKey:subDomain:trackUserForAdvertising:whenFinish:`.
2. If this is the **first run** (no stored user ID in `SdkKeys`):
   - Optionally request ATT permission (iOS 14+).
   - Call `initUser` → POST `/users/init` → store `userId` and `isReturningUser` in `SdkKeys`.
   - Call `updateUserData:` to sync device metadata.
   - Call `fetchAttributionData` to retrieve Apple Ads attribution (iOS 14.3+).
3. If the user is **returning** (user ID already stored):
   - Call `updateUserData:` to sync the latest device metadata (token, OS version, session flag, etc.).
4. The completion block fires in both cases with the API response.

---

## Conventions

- **All public methods are class methods** — there is no instance to manage.
- **Two signatures per method** — one with `whenFinish:` callback, one without. Fire-and-forget variants simply call the callback version with an empty block.
- **NSUserDefaults persistence** is handled entirely by `SdkKeys`. Never write SDK state directly to NSUserDefaults; go through `SdkKeys`.
- **HTTP is handled by `ServiceLayer`** — do not use NSURLSession directly in `Appgain.m`.
- **URL construction** lives in `UrlData` — keep all endpoint strings there.
- **GCD dispatch to main queue** for all completion blocks that touch UI or that are called from background URL session callbacks.
- **Session tracking**: the module-level `logSession` boolean ensures the `session` flag is sent only on the first update per app launch.
- **Static variables** (`campaignId`, `campaignName`, `smartLinkId`, `logSession`) are module-level in `Appgain.m`; reset them only inside `Appgain.m`.

---

## Build & test

There is no test scheme or test target in this repository. Validation is done by integrating the SDK into a host app.

To lint/build via CocoaPods:
```bash
pod lib lint Appgain.podspec
pod lib lint Appgain-Rich.podspec
```

DeepSource runs static analysis automatically on push (see `.deepsource.toml`).

---

## Branching & releases

- Default branch: `master`
- Releases are tagged with the pod version string (e.g., `4.0.0`).
- Both pod specs reference `s.version.to_s` as the git tag.

---

## Common tasks for AI assistants

### Adding a new API method

1. Add the method signature to `Sources/include/Appgain.h` (both `whenFinish:` and fire-and-forget variants).
2. Add the URL to `Sources/include/UrlData.h` and `Sources/UrlData.m`.
3. Implement in `Sources/Appgain.m` using `ServiceLayer` for networking.
4. Dispatch the callback on the main queue if the caller expects UI work.

### Bumping the SDK version

1. Update `sdkVersion` in `Sources/include/UrlData.h`.
2. Update `s.version` in `Appgain.podspec` and `Appgain-Rich.podspec`.
3. Tag the commit with the new version string.

### Understanding a network call

All requests go through `ServiceLayer`. The URL is built by `UrlData`. Authentication / user-ID parameters are injected from `SdkKeys` inside `Appgain.m` before the request is dispatched.
