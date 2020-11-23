//
//  AppgainRich.h
//  AppGainSDKCreator
//
//  Created by Ragaie Alfy on 6/8/19.
//  Copyright © 2019 Ragaie Alfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <UserNotifications/UserNotifications.h>
#import <AVKit/AVKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AppgainRich : NSObject
//MARK : for rich notification

///for rich notification service target
+ (void)didReceiveNotificationRequest:(UNNotificationRequest* _Nullable)request andNotificationContent :(UNMutableNotificationContent* _Nullable) bestAttemptContent withContentHandler:(void (^_Nullable)(UNNotificationContent * _Nonnull))contentHandler ;
// for rich notification content view
+ (void)didReceiveNotification:(UNNotification* _Nullable )notification inViewController : (UIViewController*_Nullable) viewController;



@end

NS_ASSUME_NONNULL_END
