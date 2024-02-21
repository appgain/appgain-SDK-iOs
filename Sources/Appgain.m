//
//  AppGainTracker.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import "Appgain.h"

@implementation  Appgain


static  NSString  *campaignId;
static  NSString  *campaignName = @"" ;
static  NSString  *smartLinkId;
static  bool  logSession = NO;
static void  (^initDone)(NSURLResponse*, NSMutableDictionary*,NSError * );

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
+(void)initialize:(NSString *)projectId
           apiKey:(NSString *)apiKey
           subDomain:(NSString *)subDomain
trackUserForAdvertising :(BOOL) trackAdvertisingId
       whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError *))onComplete{
    
    initDone =  onComplete;
    //if no project or parser server is done sent to get parser server data
    if ([[[SdkKeys new] getUserID]  isEqual: @""] ) {
        [Appgain requestUserPermissionForUDID:trackAdvertisingId];
        SdkKeys* tempSdkKeys = [SdkKeys new];
        [tempSdkKeys setAppApiKey:apiKey];
        [tempSdkKeys setAppID:projectId];
        [tempSdkKeys setAppSubDomainName:subDomain];
//        [[ServiceLayer new] requestWithURL:[UrlData getAppKeysUrlWithID:projectId] httpWay:@"GET"  didFinish:^(NSURLResponse * response, NSMutableDictionary * result,NSError * error) {
//            if (result != nil){
//                if ([result objectForKey:@"AppSubDomainName"] != nil){
//                    //[tempSdkKeys setAppSubDomainName: [result objectForKey:@"AppSubDomainName"]];
//                    [tempSdkKeys setParseAppID: [result objectForKey:@"Parse-AppID"]];
//                    [tempSdkKeys setParseMasterKey:  [result objectForKey:@"Parse-masterKey"]];
//                    [tempSdkKeys setParseServerUrl:  [result objectForKey:@"Parse-serverUrl"]];
//        [Appgain initUser:^(NSURLResponse * response, NSMutableDictionary * result, NSError * error) {
//            initDone(response,result,error);
//        } ];
                    //call init user to replace this one
//                    initDone(response,result,error);
//                }
//                else{
//                    initDone(response,result,error);
//                }
//            }
//            else{
//                initDone(response,result,error);
//                NSLog(@"AppGain SDK init is fail");
//            }
//        }];
    }
    else{
        // add last
//        NSMutableDictionary *details = [NSMutableDictionary new];
//        details[@"success"] = @"Appgian sdk already initalized before.";
        [Appgain updateUserData:nil whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
            NSLog(@"response %@",response);
            NSLog(@"result %@",result);
            NSLog(@"error %@",error);
            initDone(response,result,error);
        }];
    }
}

+(void) requestUserPermissionForUDID :(BOOL) allowed {
    if (allowed) {
        //  NSMutableString *idFA = [@"Not allowed" mutableCopy];
        if (@available(iOS 14.0, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if (status == ATTrackingManagerAuthorizationStatusAuthorized){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[SdkKeys new] setDeviceADID: [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
                        [Appgain initUser:^(NSURLResponse * response, NSMutableDictionary * result, NSError * error) {
                            initDone(response,result,error);
                        } ];
                    });
                }
                
            }];
        }
        else{
            [[SdkKeys new] setDeviceADID: [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
            [Appgain initUser:^(NSURLResponse * response, NSMutableDictionary * result, NSError * error) {
                initDone(response,result,error);
            } ];
        }
    }
}

+(void) initUser: (void (^)(NSURLResponse *, NSMutableDictionary *,NSError *))onComplete {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *details = [NSMutableDictionary new];
    details[@"platform"] = @"ios";
    details[@"appId"] = bundleIdentifier;
    details[@"deviceId"] = [[SdkKeys new] getDeviceADID];
    
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    parameters[@"deviceId"] = [[SdkKeys new] getDeviceADID];
    
    [[ServiceLayer new] postRequestWithURL:[UrlData initUser] withBodyData:details withParameters:[NSMutableDictionary new]  didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        // need to save user id
        // save is returning user or not
        if (result != nil) {
            [[SdkKeys new] setUserID:result[@"userId"]];
            [[SdkKeys new] setIsReturnUser: result[@"isReturningUser"]];
            
            [Appgain updateUserData:nil];
            [Appgain callIdaAttribution];
            
            onComplete(response, result, error);
        }
        
    }];
}
+(void)updateDeviceToken{
    NSMutableDictionary *details = [NSMutableDictionary new];
    details[@"fcmToken"] = [[SdkKeys new] getDeviceToken];
    details[@"deviceToken"] = [[SdkKeys new] getDeviceToken];
    if (![[[SdkKeys new] getDeviceADID]  isEqual: @"Not allowed"]) {
        details[@"deviceId"] = [[SdkKeys new] getDeviceADID];
    }
    // log session
    if (![[[SdkKeys new] getUserID] isEqual:@""]){
        if (logSession){
            details[@"session"] = @"true";
        } else {
            logSession = YES;
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = [[SdkKeys new] getUserID];
    
    [[ServiceLayer new] postRequestWithURL:[UrlData updateUser] withBodyData:details  withParameters:parameters didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        
    }];
}

+(void)callIdaAttribution{
    if ([[[SdkKeys new] getIda] isEqualToString:@"true"]){
        
        // Delay 2 seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
                [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *attributionDetails, NSError *error) {
                    // Look inside of the returned dictionary for all attribution details
                    NSMutableDictionary *details = [NSMutableDictionary new];
                    if ([attributionDetails objectForKey:@"Version3.1"] ){
                        
                        NSDictionary * parameter = [attributionDetails objectForKey:@"Version3.1"] ;
                        for (id  key in parameter){
                            NSString * newKey = [(NSString*)key stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            id value = parameter[key];
                            details[newKey] = value;
                        }
                        if (![[[SdkKeys new] getDeviceADID]  isEqual: @"Not allowed"]) {
                            details[@"deviceId"] = [[SdkKeys new] getDeviceADID];
                        }
                        // log session
                        if (logSession){
                            details[@"session"] = @"true";
                        } else {
                            logSession = YES;
                        }
                        
                        NSMutableDictionary *parameters = [NSMutableDictionary new];
                        parameters[@"userId"] = [[SdkKeys new] getUserID];
                        
                        [[ServiceLayer new] postRequestWithURL:[UrlData updateUser]  withBodyData:details withParameters:parameters  didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
                        }];
                    }
                }];
            }
        });
    }
}

+(void)updateUserData:(NSDictionary *)userData whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError * error))onComplete{
    if (![[[SdkKeys new] getUserID] isEqualToString:@""]){
        NSMutableDictionary *details = [NSMutableDictionary new];
        details[@"userId"] = [[SdkKeys new] getUserID];
        if (![[[SdkKeys new] getDeviceADID]  isEqual: @"Not allowed"]) {
            details[@"deviceId"] = [[SdkKeys new] getDeviceADID];
        }
        details[@"fcmToken"] = [[SdkKeys new] getDeviceToken];
        details[@"deviceToken"] = [[SdkKeys new] getDeviceToken];
        details[@"appversion"] =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        details[@"madidIdtype"] = @"idfa";
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString * date = [dateFormatter stringFromDate:[NSDate new]];
        if ([[[SdkKeys new] getInstallRun] isEqualToString:@"true"]){
            details[@"installationAt"] = date;
        }
        details[@"madid"] =  [[SdkKeys new] getDeviceADID];
        details[@"localeId"] =  @"ar";
        
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier  = [networkInfo subscriberCellularProvider];
        if ([[carrier carrierName] isKindOfClass:[ NSString class] ]){
            details[@"operator"] = [carrier carrierName];
        }
        details[@"lastSeenAt"] = date;
        struct utsname systemInfo;
        uname(&systemInfo);
        details[@"devicemodel"] =  [NSString stringWithCString:systemInfo.machine
                                                      encoding:NSUTF8StringEncoding];
        details[@"platform"] = @"ios";
        NSString *ver = [[UIDevice currentDevice] systemVersion];
        details[@"os_ver"] = ver;
        details[@"localeId"] = [[NSLocale preferredLanguages] firstObject];
        details[@"language"] = [[[NSLocale preferredLanguages] firstObject] substringToIndex: 2];
        details[@"sdk_version"] = sdkVersion;
        
        NSTimeZone * timezone = [NSTimeZone localTimeZone];
        details[@"timeZone"] =   timezone.name;
        details[@"appName"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        details[@"usagecounter"] = [[NSNumber alloc] initWithInt:1];
        details[@"userId"] = [[SdkKeys new] getUserID];
        // log session
        if (logSession){
            details[@"session"] = @"true";
        } else {
            logSession = YES;
        }
        
        if (userData != nil ){
            for (id  key in userData){
                id value = userData[key];
                // do stuff
                details[key] = value;
            }
        }
        
        
        UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (notificationSettings.types != UIUserNotificationTypeNone) {
            // push notifications are enabled
            details[@"pushEnabled"] = @"true";
        } else {
            // push notifications are disabled
            details[@"pushEnabled"] = @"false";
        }
        
        
        details[@"extra_params"] = @"{\"params\":[],\"userId\":\"\"}";
        
//        NSMutableDictionary *parameters = [NSMutableDictionary new];
//        parameters[@"userId"] = [[SdkKeys new] getUserID];
        
        [[ServiceLayer new] postRequestWithURL:[UrlData updateUser]  withBodyData:details withParameters:[NSMutableDictionary new]  didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
            onComplete(response,result,error);
        }];
    }
}


///is called only on the first app run if matching succeeded
+(void)updateMatchingData :(NSDictionary *)extra :(void (^)(NSURLResponse *, NSMutableDictionary *,NSError * error))onComplete{
    NSMutableDictionary *details = [NSMutableDictionary new];
    details[@"userId"] = [[SdkKeys new] getUserID];
    details[@"isReturningUser"] =  [[[SdkKeys new] isReturnUser] isEqualToString:@"1"] ? @"true" : @"false";
    //[NSNumber numberWithBool:[[SdkKeys new] isReturnUser]];
    if ( extra[@"smart_link_url"] ){
        
        details[@"SDL"]  = extra[@"smart_link_url"];
    }
    
    
    NSLog(@"smart_link_id %@",extra[@"smart_link_id"]);
    if (extra[@"smart_link_id"]){
        details[@"smartlink_id"] = extra[@"smart_link_id"];
    }else{
        details[@"smartlink_id"] = @"organic";
    }
    
    if (extra != nil ){
        if ([[extra objectForKey:@"extra_data"] objectForKey:@"params"]){
            NSArray * parameter = [[extra objectForKey:@"extra_data"] objectForKey:@"params"];
            for (NSDictionary *item in parameter){
                for (id  key in item) {
                    id value = item[key];
                    // do stuff
                    details[key] = value;
                }
            }
        }
        //new handle
        if ([extra objectForKey:@"extra_data"] ){
            NSDictionary * parameter = [extra objectForKey:@"extra_data"] ;
            for (id  key in parameter){
                id value = parameter[key];
                // do stuff
                details[key] = value;
                
            }
        }
    }
    
    [[ServiceLayer new] postRequestWithURL: [UrlData updateMatchingData] withBodyData:details withParameters:details didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        NSLog(@"result %@",result);
        NSLog(@"response %@",response);
        NSLog(@"error %@",error);
        onComplete(response,result,error);
    }];
}


+(void)logPurchase:(NSString *)productName withAmount :(double ) amount forCurrency :(NSString*) currency whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError * error))onComplete{
    
    NSMutableDictionary *details = [NSMutableDictionary new];
    
    details[@"userId"] = [[SdkKeys new] getUserID];
    details[@"productName"] = productName;
    details[@"amount"] =  [[NSString alloc] initWithFormat:@"%f",amount];//[NSNumber numberWithDouble:amount];
    details[@"currency"] = currency;
    details[@"platform"] = @"ios";
    
    details[@"smartlink_id"] = [smartLinkId isKindOfClass:[ NSString class] ] ? smartLinkId : @"organic";
    //if there is an notification for buy item
    if ([campaignId isKindOfClass:[ NSString class] ] ){
        [Appgain logNotificationConverstion:amount];
    }
    // NSString * url = [Appgain getUrlWithParameter:[UrlData logPurchase] andParameter:details];
    
    [[ServiceLayer new] postRequestWithURL:[UrlData logPurchase] withBodyData:nil withParameters:details didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        onComplete(response,result,error);
    }];
    
}


+(void)logNotificationConverstion :(double)value{
    
    NSDictionary *details = @{@"channel" :@"apppush",
                              @"action":
                                  @{@"name":[NotificationStatus Conversion],@"value":[NSNumber numberWithDouble:value]} ,//name could be received", --> or conversion or open
                              @"userId":[[SdkKeys new] getUserID], //
                              @"campaign_id": campaignId ,
                              @"campaign_name":campaignName
    };
    // NSString * url = [Appgain getUrlWithParameter:[UrlData getnotificationTrackUrl] andParameter:(NSMutableDictionary *)details];
    
    [[ServiceLayer new] postRequestWithURL:[UrlData getnotificationTrackUrl]  withBodyData:details  withParameters:nil didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            campaignName = @"";
            campaignId = nil;
        });
    }];
    
    
}


+(void)updateUserId:(NSString *)userId  whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError * error))onComplete{
    NSMutableDictionary *details = [NSMutableDictionary new];
    details[@"userId"] = [[SdkKeys new] getUserID];
    details[@"newUserId"] = userId;
    // NSString * url = [Appgain getUrlWithParameter:[UrlData updateUserId] andParameter:details];
    
    [[ServiceLayer new] postRequestWithURL:[UrlData updateUserId] withBodyData:nil withParameters:details didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        [[SdkKeys new] setUserID:userId];
        onComplete(response,result,error);
    }];
    
}


+(void)getUserData:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError * error))onComplete{
    NSMutableDictionary *details = [NSMutableDictionary new];
    details[@"userId"] = [[SdkKeys new] getUserID];
    //  NSString * url = [Appgain getUrlWithParameter:[UrlData getUserInfo] andParameter:details];
    
    [[ServiceLayer new] postRequestWithURL:[UrlData getUserInfo] withBodyData:nil withParameters:details didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        onComplete(response,result,error);
    }];
    
}

+(void)matchLink:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    
    [[ServiceLayer new] requestWithURL:[UrlData getmatcherLink] httpWay:@"GET" didFinish:^(NSURLResponse *response, NSMutableDictionary *result,NSError * error) {
        NSLog(@"response %@",response);
        NSLog(@"result %@",result);
        NSLog(@"error %@",error);
        
        if (result[@"smart_link_id"]){
            smartLinkId = result[@"smart_link_id"];
        }
        //old response
        if (([[[SdkKeys new] getFirstMatch] isEqualToString:@"true"]) && result ){
            //            NSMutableDictionary *details = [NSMutableDictionary new];
            //            details[@"smartlink_id"] = result[@"smart_link_id"];
            //            [Appgain updateUserData:details];
            [Appgain updateMatchingData:result :^(NSURLResponse *response, NSMutableDictionary *info, NSError *error) {
                
            }];
        }
        onComplete(response,result,error);
        
    }];
}


//MARK:Register device token for push notifiaction
/*
 parameter device token data
 */

+(void)RegisterDeviceWithToken:(NSData*)deviceToken{
    NSString *token = @"";
    if (@available(iOS 13, *)) {
        NSUInteger length = deviceToken.length;
        if (length == 0) {
            //  return nil;
        }
        const unsigned char *buffer = deviceToken.bytes;
        NSMutableString *hexString  = [NSMutableString stringWithCapacity:(length * 2)];
        for (int i = 0; i < length; ++i) {
            [hexString appendFormat:@"%02x", buffer[i]];
        }
        token = [hexString copy];
    }
    else{
        token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    
    
    
    // NSString *token =   [deviceToken base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //  NSLog(@"content---%@", token);
    if (![[[SdkKeys new] getDeviceToken] isEqualToString:token]) {
        [[SdkKeys new] setDeviceToken:token];
        [Appgain updateDeviceToken];
    }
    
    //set server installion for this device
}

//MARK:handle recive remote notification to register status track for it
+(void)handlePush:(NSDictionary *)userInfo forApplication:(UIApplication *)application{
    
    [Appgain recordPushStatus:[NotificationStatus Received]  userInfo:userInfo whenFinish:^(NSURLResponse *response , NSMutableDictionary *info , NSError *error) {
        
    }];
    
}



///create smartLink for app
/*
 input parameter
 smart link object
 
 response in block
 */
+(void)createSmartLink:( SmartDeepLink*)linkObject whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    [[ServiceLayer new] postRequestWithURL: [UrlData getSmartUrl] withBodyData: linkObject.dictionaryValue withParameters:nil didFinish:^(NSURLResponse * response, NSMutableDictionary *result,NSError * error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
        });
        
    }];
    
}


//MARK : create LandingPage for user
+(void)createLandingPage:(MobileLandingPage *)landingPage whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    [[ServiceLayer new] postRequestWithURL:[UrlData getLandingPageUrl] withBodyData: [landingPage dictionaryValue] withParameters:nil didFinish:^(NSURLResponse *response, NSMutableDictionary *result,NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
        });
    }];
}




//MARK:create automator
/*
 input parameter
 1- trigger point
 2- userID *optional*
 3- with extra  parameters in NSDictionary [key,value]
 */
+(NSString*)getUrlWithParameter :(NSString*) url andParameter : (NSMutableDictionary *) queryDictionary{
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in queryDictionary) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryDictionary[key]]];
    }
    components.queryItems = queryItems;
    return components.URL.absoluteString;
}

+(NSString*)urlEscapeString:(NSString *)unencodedString
{
    //    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    //    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
    //    CFRelease(originalStringRef);
    //
    //
    //    NSString * toBeEscapedInQueryString = @"!*'\"();:@&=+$,/?%#[]% ";
    //    NSString * ss =   [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:toBeEscapedInQueryString]];
    NSString* s = [unencodedString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    return s;
}



+(void)fireAutomator:(NSString *)triggerPoint  personalizationData:(NSMutableDictionary*) personalizationData whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:[UrlData getAutomatorUrlWithTriggerPoint:triggerPoint]];
    for (id key in personalizationData) {
        NSString *keyString = [key description];
        NSString *valueString = [[personalizationData objectForKey:key] description];
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    [[ServiceLayer new] requestWithURL:urlWithQuerystring httpWay:@"GET" didFinish:^(NSURLResponse *response , NSMutableDictionary * result,NSError * error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
        });
    }];
}
+(void)cancelAutomator:(NSString *)triggerPoint whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *, NSError *))onComplete{
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:[UrlData getAutomatorUrlWithTriggerPoint:triggerPoint]];
    
    [[ServiceLayer new] requestWithURL:urlWithQuerystring httpWay:@"DELETE" didFinish:^(NSURLResponse *response , NSMutableDictionary * result,NSError * error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
        });
    }];
}


//Mark track notification
/*
 input parameter
 1- notification user info
 2- action String (opend, recived, con..)
 */
+(void)recordPushStatus:(NSString*)action userInfo:(NSDictionary *) userInfo whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    
    NSMutableDictionary *details = [NSMutableDictionary new];
    if (userInfo != nil){
        //NSString * campaign = @"";
        //  NSString * campaign_name = @"";
        if ([userInfo objectForKey:@"campaign_id"]) {
            campaignId = [userInfo objectForKey:@"campaign_id"];
        }
        if ([userInfo objectForKey:@"campaignName"]) {
            campaignName = [userInfo objectForKey:@"campaignName"];
        }
        
        
        details[@"channel"] = @"apppush";
        details[@"action"] =  @{@"name":action,@"value":@0.0};
        details[@"userId"] = [[SdkKeys new] getUserID];
        details[@"campaign_id"] = campaignId;
        details[@"campaign_name"] = campaignName;
    }
    
    [[ServiceLayer new] postRequestWithURL:[UrlData getnotificationTrackUrl] withBodyData:details withParameters:nil didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
        });
    }];
    
    
    
}


+(void)logEvent:(NSString *)event andAction:(NSString *)action extras:(NSDictionary*) extras whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    NSDictionary *info;
    if (extras != nil){
        info = @{@"action":action,@"type":event,@"value":extras};
        
    }
    else{
        info = @{@"action":action,@"type":event};
    }
    [[ServiceLayer new] postRequestWithURL:[UrlData getLogEventUrl] withBodyData: info withParameters:nil didFinish:^(NSURLResponse *response, NSMutableDictionary *result,NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
        });
    }];
}




//MARK: get parser user id

+(NSString *)getUserID{
    return  [[SdkKeys new] getUserID];
}




//MARK: enable and disable notification for user
+(void)enableNotifications:(BOOL)isEnabled forType : (NSString*) type whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *, NSError *))onComplete{
    NSMutableDictionary *details = [NSMutableDictionary new];
    
    details[@"isEnabled"] = isEnabled == YES ? @"true" : @"false";//[[NSString alloc] initWithFormat:@"%i",isEnabled];
    details[@"type"] = type;
    details[@"userId"] = [[SdkKeys new] getUserID];
    
    //NSString * url = [Appgain getUrlWithParameter:[UrlData getEnableNotifications] andParameter:details];
    
    [[ServiceLayer new] postRequestWithURL:[UrlData getEnableNotifications] withBodyData:nil withParameters:details didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        onComplete(response,result,error);
    }];
    
    
    
    
}

//MARK: add new notification channel for different type of notification recieving
+(void)createNotificationChannel :(NSString *) type withData :(NSString*) data whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    NSMutableDictionary *details = [NSMutableDictionary new];
    
    
    details[@"smartlink_id"] = smartLinkId;
    details[@"type"] = type;
    details[@"data"] = data;
    
    details[@"userId"] = [[SdkKeys new] getUserID];
    
    [[ServiceLayer new] postRequestWithURL:[UrlData createNotificationChannels]  withBodyData:nil withParameters:details didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        onComplete(response,result,error);
    }];
}





///funcs without callbacks
+(void) initialize:(NSString *)projectId apiKey:(NSString *)apiKey subDomain:(NSString *)subDomain trackUserForAdvertising:(BOOL)trackAdvertisingId {
    [Appgain initialize:projectId apiKey:apiKey subDomain:subDomain trackUserForAdvertising:trackAdvertisingId whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}

+(void)updateUserData:(NSDictionary *)userData {
    [Appgain updateUserData:userData whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        NSLog(@"response %@",response);
        NSLog(@"result %@",result);
        NSLog(@"error %@",error);
    }];
}
///is called only on the first app run if matching succeeded
+(void)logPurchase:(NSString *)productName withAmount :(double ) amount forCurrency :(NSString*) currency {
    [Appgain logPurchase:productName withAmount:amount forCurrency:currency whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}

+(void)updateUserId:(NSString *)userId  {
    [Appgain updateUserId:userId whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}
+(void)matchLink{
    [Appgain matchLink:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}

+(void)fireAutomator:(NSString *)triggerPoint  personalizationData:(NSMutableDictionary*) personalizationData{
    [Appgain fireAutomator:triggerPoint personalizationData:personalizationData whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}
+(void)cancelAutomator:(NSString *)triggerPoint{
    [Appgain cancelAutomator:triggerPoint whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}

+(void)recordPushStatus:(NSString*)action userInfo:(NSDictionary *) userInfo {
//    [Appgain recordPushStatus:action userInfo:userInfo whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
//
//    }];
    
    NSMutableDictionary *details = [NSMutableDictionary new];
    if (userInfo != nil){
        if ([userInfo objectForKey:@"campaign_id"]) {
            details[@"campaign_id"] = [userInfo objectForKey:@"campaign_id"];
        }
        
        if ([userInfo objectForKey:@"campaignName"]) {
            details[@"campaign_name"] = [userInfo objectForKey:@"campaignName"];
        }
    }
        
    [Appgain logEvent:@"" andAction:action extras:details whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
    
}
+(void)logEvent:(NSString *)event andAction:(NSString *)action extras:(NSDictionary*) extras {
    [Appgain logEvent:event andAction:action extras:extras whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}
+(void)enableNotifications:(BOOL)isEnabled forType : (NSString*) type{
    [Appgain enableNotifications:isEnabled forType : type whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}
//MARK: add new notification channel for different type of notification recieving
+(void)createNotificationChannel :(NSString *) type withData :(NSString*) data{
    [Appgain createNotificationChannel:type withData:data whenFinish:^(NSURLResponse *response, NSMutableDictionary *result, NSError *error) {
        
    }];
}


@end

