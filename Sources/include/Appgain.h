//
//  AppGainTracker.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import <Foundation/Foundation.h>

/// import all model you need
#import "DataModels.h"
 #import <sys/utsname.h>
#import "SdkKeys.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <iAd/iAd.h>
@interface Appgain : NSObject

//MARK: init sdk with app_id and api_key

/*
 #parameter
 1- appid --> String
 2- app api key --> string
 #response
 will be response for match link that call back every time app is run.
 # flow of this init method
 1- save appid and app_api_key for NSUserdefault
 if user id not found that mean that app first run or not set app data yet so-->
 1- call api to get app setting
 2- when sucess get data in NsUserdefault for parser setting
 3- then call parser server configuration if it is available for this app.
 else if app data setting before then
 1-  call matcherLink api for app to sent response feedback to user.
 
 */
//get app keys and configure data
//MARK: init sdk with response .
+(void)initialize:(NSString *)projectId apiKey:(NSString *)apiKey subDomain:(NSString *)subDomain trackUserForAdvertising :(BOOL) trackAdvertisingId whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
+(void)updateUserData:(NSDictionary *)userData whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
///is called only on the first app run if matching succeeded
+(void)updateMatchingData :(NSDictionary *)extra :(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
+(void)logPurchase:(NSString *)productName withAmount :(double ) amount forCurrency :(NSString*) currency whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
+(void)updateUserId:(NSString *)userId  whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
+(void)getUserData:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
+(void)matchLink:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
//MARK:Register device token for push notifiaction
/*
 parameter device token data
 */

+(void)RegisterDeviceWithToken:(NSData*)deviceToken;
    
    //MARK:handle recive remote notification to register status track for it
+(void)handlePush:(NSDictionary *)userInfo forApplication:(UIApplication *)application;
    

    ///create smartLink for app
    /*
     input parameter
     smart link object
     
     response in block
     */
+(void)createSmartLink:( SmartDeepLink*)linkObject whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
    
    //MARK : create LandingPage for user
+(void)createLandingPage:(MobileLandingPage *)landingPage whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;

+(void)fireAutomator:(NSString *)triggerPoint  personalizationData:(NSMutableDictionary*) personalizationData whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
+(void)cancelAutomator:(NSString *)triggerPoint whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;


//Mark track notification
/*
    input parameter
    1- notification user info
    2- action String (opend, recived, con..)
*/
+(void)recordPushStatus:(NSString*)action userInfo:(NSDictionary *) userInfo whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;
+(void)logEvent:(NSString *)event andAction:(NSString *)action extras:(NSDictionary*) extras whenFinish:(void (^)(NSURLResponse *response, NSMutableDictionary *result,NSError * error))onComplete;

//MARK: get parser user id
+(NSString *)getUserID;
    //MARK: enable and disable notification for user
+(void)enableNotifications:(BOOL)isEnabled forType : (NSString*) type whenFinish:(void (^)(NSURLResponse*response, NSMutableDictionary*result,NSError *))onComplete;
    //MARK: add new notification channel for different type of notification recieving
+(void)createNotificationChannel :(NSString *) type withData :(NSString*) data whenFinish:(void (^)(NSURLResponse*response, NSMutableDictionary*result,NSError *error))onComplete;

    //MARK: init sdk with response .
+(void)initialize:(NSString *)projectId apiKey:(NSString *)apiKey subDomain:(NSString *)subDomain trackUserForAdvertising :(BOOL) trackAdvertisingId ;
+(void)updateUserData:(NSDictionary *)userData ;
    ///is called only on the first app run if matching succeeded
+(void)logPurchase:(NSString *)productName withAmount :(double ) amount forCurrency :(NSString*) currency ;
+(void)updateUserId:(NSString *)userId  ;
+(void)matchLink;
+(void)fireAutomator:(NSString *)triggerPoint  personalizationData:(NSMutableDictionary*) personalizationData;
+(void)cancelAutomator:(NSString *)triggerPoint;

+(void)recordPushStatus:(NSString*)action userInfo:(NSDictionary *) userInfo ;
+(void)logEvent:(NSString *)event andAction:(NSString *)action extras:(NSDictionary*) extras ;
  //MARK: enable and disable notification for user
+(void)enableNotifications:(BOOL)isEnabled forType : (NSString*) type;
  //MARK: add new notification channel for different type of notification recieving
+(void)createNotificationChannel :(NSString *) type withData :(NSString*) data;
    @end
