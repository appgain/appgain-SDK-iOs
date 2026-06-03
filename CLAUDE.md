# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the **Appgain iOS SDK** — an Objective-C library that integrates iOS apps with the [Appgain.io](https://appgain.io) platform. It provides push notifications, smart deep links, mobile landing pages, user analytics/event tracking, attribution, and marketing automation.

The SDK is distributed as two separate CocoaPods and Swift Package Manager targets:
- **`Appgain`** (v4.0.0, iOS 9.0+) — core SDK in `Sources/`
- **`Appgain-Rich`** (v3.3.0, iOS 10.0+) — notification service/content extension support in `Sources-rich/`

## Distribution

**CocoaPods:**
```ruby
pod 'Appgain', '~> 4.0.0'
pod 'Appgain-Rich', '~> 3.3.0'  # for Notification Service/Content Extensions
```

**Swift Package Manager:** `Package.swift` defines both targets — `Appgain` (path: `Sources`) and `Appgain-rich` (path: `Sources-rich`).

Versioning is managed by updating `s.version` in `Appgain.podspec` / `Appgain-Rich.podspec`, and by adding a matching git tag before publishing to CocoaPods trunk.

There is no build script, test suite, or CI configuration in this repository. Building is validated by integrating the SDK into a host app project in Xcode.

## Architecture

### Core SDK (`Sources/`)

The SDK follows a flat structure with a single public facade class and supporting models:

**`Appgain` (facade)** — all public API methods are class methods (`+`). The initialization flow:
1. `+initialize:apiKey:subDomain:trackUserForAdvertising:` — saves credentials to `NSUserDefaults` via `SdkKeys`, requests ATT permission (iOS 14+), calls `initUser` to register the device, then calls `updateUserData` / `fetchAttributionData`.
2. On subsequent launches (when `userId` already exists), calls `updateUserData` immediately.

**`SdkKeys`** — thin `NSUserDefaults` wrapper. All persisted state (userId, deviceToken, IDFA, appId, apiKey, subdomain, flags) lives here. Constants are `#define` macros at the top of the header.

**`ServiceLayer`** — HTTP client wrapping `NSURLSession`. All requests include `appApiKey` and `appId` headers. GET requests also fetch a real `User-Agent` string via an ephemeral `WKWebView` before sending. Both methods guard against calls before `initUser` completes (returns an error with code 123 if `userId` is empty).

**`UrlData`** — URL factory. The SDK version string (`sdkVersion`) is a static in this header. All API URLs are built from the app's subdomain: `https://<subdomain>.appgain.io/`. Different service hostnames are used per feature:
- Main SDK endpoints: `https://<subdomain>.appgain.io/sdk/<appId>/...`
- Notification tracking: `https://notify.appgain.io/<appId>/recordstatus`
- Automator: `https://automator.appgain.io/automessages/<appId>/firevent/...`
- Event logging: `https://api.appgain.io/user_log_event/<appId>/<userId>` (subdomain replaces `api` if set)
- Smart links / landing pages: `https://<subdomain>.appgain.io/apps/<appId>/...`

**Data models** (`SmartDeepLink`, `MobileLandingPage`, `MobileLandingPageButton`, `SocialmediaSettings`, `TargetPlatform`) — plain `NSObject` subclasses with `dictionaryValue` serialization for POST bodies. `DataModels.h` is a convenience umbrella that imports all of them.

**`NotificationStatus` / `NotificationType`** — enum-like classes returning constant strings (`Opened`, `Received`, `Dismissed`, `Conversion` / `Mobile`, `Sms`, `Email`).

### Rich Notification Extension (`Sources-rich/`)

Designed to be embedded in a **Notification Service Extension** and a **Notification Content Extension** (separate app targets in the host app).

**`AppgainRich`** — two class methods:
- `+didReceiveNotificationRequest:andNotificationContent:withContentHandler:` — downloads the image at `userInfo[@"image-url"]` and attaches it to the notification (used in the Service Extension target).
- `+didReceiveNotification:inViewController:` — renders rich media inside the notification content view based on `userInfo[@"type"]`: `photo`, `gif`, `webView`, `htmlWebView`, `video`, `carousel`.

**`CarouselHandler`** — `UICollectionView`-based carousel for the `carousel` notification type, introduced in the most recent feature branch. Initialized with the `carousel` array from `userInfo` and a host `UIViewController`.

### `Appgain-rich/` directory

Contains a duplicate copy of `AppgainRich.h/.m` (matching `Sources-rich/`). This appears to be a legacy artifact; `Package.swift` and `Appgain-Rich.podspec` both point to `Sources-rich/`.

## Key Conventions

- Every public `Appgain` method has two variants: one that accepts a completion block `whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*, NSError*))` and a fire-and-forget version without a callback.
- All completion blocks are dispatched back to the main queue via `dispatch_async(dispatch_get_main_queue(), ...)`.
- `ServiceLayer` silently drops all requests (returns error 123) if `userId` is empty — `+initialize:` must complete successfully before any other API call will work.
- The `Appgain-rich` SPM target path is `Sources-rich`, but the directory inside is also named `Sources-rich`. The `Appgain-rich/` directory at the root is not included in any build target.
- Static campaign state (`campaignId`, `campaignName`, `smartLinkId`) is held in file-scope statics on `Appgain.m` — these persist for the lifetime of the app process and are updated by `recordPushStatus` / `matchLink`.

## Updating the SDK Version

1. Update `sdkVersion` static in `Sources/include/UrlData.h`.
2. Update `s.version` in `Appgain.podspec` (and `Appgain-Rich.podspec` if the rich extension changed).
3. Commit, tag the commit with the new version string, push tag.
4. Run `pod trunk push Appgain.podspec` (and `Appgain-Rich.podspec`) to publish.
