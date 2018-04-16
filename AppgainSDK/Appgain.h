//
//  AppGainTracker.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import <Foundation/Foundation.h>

/// import all model you need
#import "DataModels.h"
#import <Parse/Parse.h>

@interface Appgain : NSObject


//MARK: get current  user parser id
+(NSString*)getUserID;

//MARK: inialize sdk Data
+(void)initializeAppWithID:( NSString* )appID andApiKey :(NSString*)appApiKey  whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete ;

//MARK: register device token for notification
+(void)RegisterDeviceWithToken:(NSData*)deviceToken;

//MARK: used to trak user notification when recived that handle parser and appgain.io
+(void)handlePush:(NSDictionary *)userInfo forApplication : (UIApplication*) application;


//MARK: create smartlink for mobile
+(void)CreateSmartLinkWithObject:( SmartDeepLink*)linkObject whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;


//MARK: check match link for deep linking
+(void)CreateLinkMactcherWithUserID :(NSString *)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;

//MARK: create single and slider landing mobile page
+(void)createLandingPageWithObject:(MobileLandingPage *)landingPage whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;


//MARK: create trigger point for user
+(void)CreateAutomatorWithTrigger :(NSString*) trigger andUserId :(NSString*)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;

//MARK: sent notification status for server.
+(void)trackNotificationWithAction:(NSString*)action andUserInfo:(NSDictionary *) userInfo whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;
@end
