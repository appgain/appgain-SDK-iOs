//
//  UrlData.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import <Foundation/Foundation.h>

#import "SdkKeys.h"


@interface UrlData : NSObject


+ (NSString*) getAppKeysUrlWithID :(NSString*)appID ;

+ (NSString*) getSmartUrl;
+ (NSString*) getmatcherUrlWithUserID :(NSString*)userID;
+ (NSString*) getLandingPageUrl;
+ (NSString*) getnotificationTrackUrl;
+ (NSString*) getAutomatorUrlWithTriggerPoint :(NSString*)trigger;
+ (NSString*) getbaseServerUrl;
+ (NSString*) getLogEventUrl;


@end

