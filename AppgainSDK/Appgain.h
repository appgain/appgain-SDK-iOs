//
//  AppGainTracker.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import <Foundation/Foundation.h>

/// import all model you need
#import "DataModels.h"
#import <Parse/Parse.h>
#import "SdkKeys.h"

@interface Appgain : NSObject

//MARK: get current  user parser id
+(NSString*)getUserID;

//MARK: inialize sdk Data
+(void)initializeAppWithID:( NSString* )appID andApiKey :(NSString*)appApiKey automaticConfiguration :(BOOL)configureAutomatic  whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete ;

//MARK: inialize sdk Data with client id
//+(void)initializeAppWithClientID:( NSString* )clientId andAppId :(NSString*)appId andApiKey :(NSString*)appApiKey  whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete ;

//MARK: deinialize sdk Data

+(void)deInitializeApp ;

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

//MARK: create trigger point for user with custom extra parameter
+(void)CreateAutomatorWithTrigger:(NSString *)trigger andUserId:(NSString *)userID andParameters:(NSMutableDictionary*) Parameters whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;

//MARK: sent notification status for server.
+(void)trackNotificationWithAction:(NSString*)action andUserInfo:(NSDictionary *) userInfo whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete;


//MARK: update parser user id with app user id

+(void)updateUserId:(NSString*)userId ;

//MARK: create anoynomse user with default user name and passsword


+(void)createUserID;
//MARK: log item user purchase for his id

+(void)logPurchaseForItem:(PurchaseItem *)item whenFinish:(void (^)(BOOL, NSError*))onComplete;

//MARK: enable and disable notification for user
+(void)enableReciveNotification:(BOOL)enable forType :(NSString*) type whenFinish:(void (^)(BOOL, NSError*))onComplete;
//MARK: add new notification channel for different type of notification recieving
+(void)createNotificationChannelForType :(NSString *) notificationType andExtraItem :(NSString*) item whenFinish:(void (^)(BOOL, NSError*))onComplete;


//MARK: login in and register for sdk
+(void)loginWithEmail :(NSString *) email andPassword :(NSString*) password  whenFinish:(void (^)(PFUser*, NSError*))onComplete;
+(void)loginWithSocailAccountEmail :(NSString *) userEmail andId :(NSString*) userId  andUserName : (NSString *) userName whenFinish:(void (^)(BOOL, NSError*))onComplete;

+(void)signUpWithUser : (PFUser*) user whenFinish:(void (^)(BOOL, NSError*))onComplete;
+(void)skipUserLogin;
@end
