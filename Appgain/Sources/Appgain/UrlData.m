//
//  UrlData.m
//  AppGainSDKCreator
//
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import "UrlData.h"



@implementation UrlData

+(NSString *)getbaseServerUrl{
   
    return @"appgain.io/";
}
//MARK: url for get product setting and data
+(NSString *)getAppKeysUrlWithID:(NSString *)appID{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@%@", @"https://api.",[UrlData getbaseServerUrl], appID, @"/initSDK"];
    return urlString;
}

//Mark : init user
+(NSString *)initUser{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",[[SdkKeys new] getParseServerUrl],@"/functions/initUser"];
       return urlString;
}
+(NSString *)updateUser{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",[[SdkKeys new] getParseServerUrl],@"/functions/updateUser"];
    return urlString;
}
+(NSString *)createNotificationChannels{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",[[SdkKeys new] getParseServerUrl],@"/functions/setupNotificationChannels"];
    return urlString;
}
+(NSString *)updateMatchingData{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",[[SdkKeys new] getParseServerUrl],@"/functions/updateMatchingData"];
    return urlString;
}
+(NSString *)logPurchase{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",[[SdkKeys new] getParseServerUrl],@"/functions/logPurchase"];
    return urlString;
}

+(NSString *)updateUserId{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",[[SdkKeys new] getParseServerUrl],@"/functions/updateUserID"];
    return urlString;
}
+(NSString *)getUserInfo{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",[[SdkKeys new] getParseServerUrl],@"/functions/getUserInfo"];
    return urlString;
}
+(NSString *)getEnableNotifications{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",[[SdkKeys new] getParseServerUrl],@"/functions/toggleNotifications"];
    return urlString;
}



//MARK: get matche link
+ (NSString*) getmatcherLink {
    SdkKeys *temp = [SdkKeys new];
  
    NSString *urlStringg  = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", @"https://", [temp getAppSubDomainName], @".",[UrlData getbaseServerUrl],@"smartlinks/match?isfirstRun=" , [temp getFirstRun] , @"&userId=",[temp getUserID]];
    return urlStringg;
}


//MARK:get smart link
+ (NSString*) getSmartUrl{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@%@%@", @"https://api.",[UrlData getbaseServerUrl],@"/apps/", [[SdkKeys new] getAppID], @"/smartlinks"];
    return urlString;
}

//MARK: get matche link
+ (NSString*) getmatcherUrlWithUserID :(NSString*)userID{
    SdkKeys *temp = [SdkKeys new];
    NSString *userIDD = userID;
    if ( [userID isEqualToString:@""]){
        userIDD = [temp getUserID];
    }
    
    NSString *urlStringg  = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", @"https://", [temp getAppSubDomainName], @".",[UrlData getbaseServerUrl],@"smartlinks/match?isfirstRun=" , [temp getFirstRun] , @"&userId=",userIDD];
    return urlStringg;
}

//MARK : get create landing  page url.
+ (NSString*) getLandingPageUrl{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@%@%@", @"https://api.",[UrlData getbaseServerUrl],@"apps/", [[SdkKeys new] getAppID], @"/landingpages"];
    return urlString;
}

//MARK: notification track url.
+ (NSString*) getnotificationTrackUrl{
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@%@", @"https://notify.",[UrlData getbaseServerUrl], [[SdkKeys new] getAppID], @"/recordstatus"];
    return urlString;
}

//MARK: Get automator url.
+ (NSString*) getAutomatorUrlWithTriggerPoint:(NSString *)trigger{
    SdkKeys *temp = [SdkKeys new];
    NSString *urlString =  [NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"https://automator.",[UrlData getbaseServerUrl],@"automessages/", [temp getAppID], @"/firevent/",trigger,@"/7FJwH6P2Cf"];
   // NSString *urlString =  [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", @"https://automator.",[UrlData getbaseServerUrl],@"automessages/", [temp getAppID], @"/firevent/",trigger,@"/",[temp getUserID]];
    return urlString;
}

+(NSString*)getLogEventUrl{
    SdkKeys *temp = [SdkKeys new];
       NSString *urlString =  [NSString stringWithFormat:@"%@%@%@%@", @"https://api.appgain.io/user_log_event/", [temp getAppID],@"/",[temp getUserID]];
       return urlString;
}
@end
