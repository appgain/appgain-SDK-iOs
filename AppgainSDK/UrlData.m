//
//  UrlData.m
//  AppGainSDKCreator
//
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import "UrlData.h"



@implementation UrlData

//MARK: url for get product setting and data
+(NSString *)getAppKeysUrlWithID:(NSString *)appID{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@", @"https://api.appgain.io/", appID, @"/initSDK"];
    return urlString;
}
//MARK:get smart link
+ (NSString*) getSmartUrl{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@", @"https://api.appgain.io/apps/", [[SdkKeys new] getAppID], @"/smartlinks"];
    return urlString;
}

//MARK: get matche link
+ (NSString*) getmatcherUrlWithUserID :(NSString*)userID{
    SdkKeys *temp = [SdkKeys new];
    NSString *userIDD = userID;
    if ( [userID isEqualToString:@""]){
        userIDD = [temp getParserUserID];
    }
 
    NSString *urlStringg  = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"https://", [temp getAppSubDomainName], @".appgain.io/smartlinks/match?isfirstRun=" , [temp getFirstRun] , @"&userId=",userIDD];
    return urlStringg;
}

//MARK : get create landing  page url.
+ (NSString*) getLandingPageUrl{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@", @"https://api.appgain.io/apps/", [[SdkKeys new] getAppID], @"/landingpages"];
    return urlString;
}

//MARK: notification track url.
+ (NSString*) getnotificationTrackUrl{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@", @"https://notify.appgain.io/", [[SdkKeys new] getAppID], @"/recordstatus"];
    return urlString;
}

//MARK: Get automator url.
+ (NSString*) getAutomatorUrlWithTriggerPoint:(NSString *)trigger{
    SdkKeys *temp = [SdkKeys new];
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@%@%@%@", @"https://automator.appgain.io/automessages/", [temp getAppID], @"/firevent/",trigger,@"/",[temp getParserUserID]];
    return urlString;
}


@end
