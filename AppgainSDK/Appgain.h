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



+(NSString*)getUserID;
+(void)initializeAppWithID:( NSString* )appID andApiKey :(NSString*)appApiKey  whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete ;

+(void)RegisterDeviceWithToken:(NSData*)deviceToken;

+(void)handlePush:(NSDictionary *)userInfo forApplication : (UIApplication*) application;

+(void)CreateSmartLinkWithObject:( SmartDeepLink*)linkObject whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;

+(void)CreateLinkMactcherWithUserID :(NSString *)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;
+(void)createLandingPageWithObject:(MobileLandingPage *)landingPage whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;
+(void)CreateAutomatorWithTrigger :(NSString*) trigger andUserId :(NSString*)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;


+(void)trackNotificationWithAction:(NSString*)action andUserInfo:(NSDictionary *) userInfo whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;
@end
