//
//  AppGainTracker.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import "Appgain.h"

@implementation  Appgain




static void  (^initDone)(NSURLResponse*, NSMutableDictionary*);

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



+(void)initializeAppWithClientID:(NSString *)clientId andAppId:(NSString *)appId andApiKey:(NSString *)appApiKey whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *))onComplete{
    [[SdkKeys new] setParseClientID:clientId];
    [Appgain initializeAppWithID:appId andApiKey:appApiKey whenFinish:^(NSURLResponse * reponse, NSMutableDictionary * result) {
        onComplete(reponse,result);
    }];
}



//get app keys and configure data
//MARK: init sdk with response for link match of smart link.
+(void)initializeAppWithID:(NSString *)appID andApiKey:(NSString *)appApiKey whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *))onComplete {
    initDone =  onComplete;
    
    //if no project or parser server is done sent to get parser server data
    if ([[[SdkKeys new] getParserUserID]  isEqual: @""] ) {
        SdkKeys* tempSdkKeys = [SdkKeys new];
        [tempSdkKeys setAppApiKey:appApiKey];
        [tempSdkKeys setAppID:appID];
        [[ServiceLayer new] getRequestWithURL:[UrlData getAppKeysUrlWithID:appID] didFinish:^(NSURLResponse * response, NSMutableDictionary * result) {
            if (result != nil){
                if ([result objectForKey:@"AppSubDomainName"] != nil){
                    [tempSdkKeys setAppSubDomainName: [result objectForKey:@"AppSubDomainName"]];
                    [tempSdkKeys setParseAppID: [result objectForKey:@"Parse-AppID"]];
                    [tempSdkKeys setParseMasterKey:  [result objectForKey:@"Parse-masterKey"]];
                    [tempSdkKeys setParseServerUrl:  [result objectForKey:@"Parse-serverUrl"]];
                    [Appgain configuerServerParser:YES];
                    initDone(response,result);
                }
                else{
                    initDone(response,result);
                }
            }
            else{
                initDone(response,result);
                NSLog(@"AppGain SDK init is fail");
                //NSLog(@"%@",response);
            }
            
        }];
    }
    //else get match linker data
    else{
        // add last
        //increment every time user run app
        [Appgain configuerServerParser:NO];
        
        initDone(nil,nil);
        
        
        
        
    }
}
//MARK: deInitializeApp
+(void)deInitializeApp{
    
    [Appgain createUserID];
    
}


//MARK: configure parser server
/*
 No parameter that work form data that saved before in NsUserDefault
 */
+(void)configuerServerParser : (BOOL)newUser{
    
    // If you would like all objects to be private by default, remove this line.
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        SdkKeys * tempkeys = [SdkKeys new];
        configuration.applicationId = [tempkeys getParseAppID];
        configuration.server =[tempkeys getParseServerUrl];
        configuration.localDatastoreEnabled = YES;// If you need to enable local data store
        //set client id if it provided
        if (![[[SdkKeys new] getParseClientID] isEqualToString:@""]){
            configuration.clientKey = [[SdkKeys new] getParseClientID];
        }
        
        
    }]];
    
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    defaultACL.publicReadAccess = YES;
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    });
    PFUser * user = [PFUser currentUser];
    if (newUser){
        //MARK:create new user for this device
        //after finish configure parser server then create user id for this app
        [Appgain createUserID];
    }
    else{
        [user incrementKey:@"usagecounter"];
        [user saveInBackground];
        [Appgain logAppSession];

    }
    //add record with user id for every time app open
    
}


//then call user id by register new user
/*flow inside this function
 1- create unique id for this app
 2- update parser installtion with this user id
 3- create user object data for NotificationChannels table.
 4- finally sent matcher link api
 
 
 */

+ (void)createUserID {
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSString *userTimeStamp = [NSString stringWithFormat:@"%.20lf", timeStamp];
    PFUser *user = [PFUser user];
    user.username = userTimeStamp;
    user.password = userTimeStamp;
    [user incrementKey:@"usagecounter"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //NSLog(user.objectId);
        [[SdkKeys new] setParserUserID:user.objectId];
        if (!error) {
            if (user) {
                //log new app session for user after create user object
                [Appgain logAppSession];

                //after create user update parser installation with new user id
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                if ([PFUser currentUser].objectId)
                {
                    currentInstallation[@"user"] = [PFUser currentUser];
                    currentInstallation[@"userId"] = [[PFUser currentUser] objectId];
                    currentInstallation[@"deviceToken"] = [[SdkKeys new] getDeviceToken];
                    // NSTimeZone *timeZone=[NSTimeZone localTimeZone];
                    
                    currentInstallation.channels = @[[NSString stringWithFormat:@"user_%@",[PFUser currentUser].objectId ]];
                    
                    [currentInstallation saveInBackground];
                    
                    ///add user object for notification channels
                    PFObject *notificationChannnelsObject = [PFObject objectWithClassName:@"NotificationChannels"];
                    notificationChannnelsObject[@"userId"] = [PFUser currentUser].objectId;
                    notificationChannnelsObject[@"type"] = @"appPush";
                    notificationChannnelsObject[@"appPush"] = @YES;
                    [notificationChannnelsObject saveInBackground];
                }
            }
        } else {
            //NSString *errorString = [error userInfo][@"error"];   // Show the
            NSLog(@"AppGain Fail to create your id %@",error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    }];
}



//MARK:Register device token for push notifiaction
/*
 parameter device token data
 */

+(void)RegisterDeviceWithToken:(NSData*)deviceToken{
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"content---%@", token);
    [[SdkKeys new] setDeviceToken:token];
    //set server installion for this device
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

//MARK:handle recive remote notification to register status track for it
+(void)handlePush:(NSDictionary *)userInfo forApplication:(UIApplication *)application{
    
    [Appgain trackNotificationWithAction: [NotificationStatus Opened]   andUserInfo:userInfo  whenFinish:^(NSURLResponse *response, NSMutableDictionary *result) {
        //   NSLog(@"%@",result);
    }];
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}



///create smartLink for app
/*
 input parameter
 smart link object
 
 response in block
 */
+(void)CreateSmartLinkWithObject:( SmartDeepLink*)linkObject whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete{
    [[ServiceLayer new] postRequestWithURL: [UrlData getSmartUrl] withBodyData: linkObject.dictionaryValue didFinish:^(NSURLResponse * response, NSMutableDictionary *result) {
        // update user id
        if (result[@"smartlink"] != nil ){
            PFUser * currentUser = [PFUser currentUser];
            currentUser[@"SDL"] = result[@"smartlink"];
            [currentUser saveInBackground];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result);
        });
        
    }];
    
}

//MARK:create linkMatcher
/*
 input parameter app user id
 */
+(void)CreateLinkMactcherWithUserID :(NSString *)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete{
    
    [[ServiceLayer new] getRequestWithURL:[UrlData getmatcherUrlWithUserID:userID] didFinish:^(NSURLResponse *response, NSMutableDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result);
            if ([[result objectForKey:@"extra_data"] objectForKey:@"params"]){
                PFUser *currentUser = [PFUser currentUser];
                NSArray * parameter = [[result objectForKey:@"extra_data"] objectForKey:@"params"];
                for (NSDictionary *item in parameter){
                    for (id  key in item) {
                        id value = item[key];
                        // do stuff
                        currentUser[key] = value;
                    }
                }
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                }];
            }
        });
    }];
}


//MARK : create LandingPage for user
+(void)createLandingPageWithObject:(MobileLandingPage *)landingPage whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete{
    [[ServiceLayer new] postRequestWithURL:[UrlData getLandingPageUrl] withBodyData: [landingPage dictionaryValue] didFinish:^(NSURLResponse *response, NSMutableDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result);
        });
    }];
}





//MARK:create automator
/*
 input parameter
 1- trigger point
 2- userID *optional*
 3-
 */
+(void)CreateAutomatorWithTrigger:(NSString *)trigger andUserId:(NSString *)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete{
    [[ServiceLayer new] getRequestWithURL:[UrlData getAutomatorUrlWithTriggerPoint:trigger] didFinish:^(NSURLResponse *response , NSMutableDictionary * result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result);
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

+(NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

+(void)CreateAutomatorWithTrigger:(NSString *)trigger andUserId:(NSString *)userID andParameters:(NSMutableDictionary*) parameters whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete{
    
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:[UrlData getAutomatorUrlWithTriggerPoint:trigger]];
    for (id key in parameters) {
        NSString *keyString = [key description];
        NSString *valueString = [[parameters objectForKey:key] description];
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    [[ServiceLayer new] getRequestWithURL:urlWithQuerystring didFinish:^(NSURLResponse *response , NSMutableDictionary * result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result);
        });
        
        
        
    }];
    
}




//Mark track notification
/*
 input parameter
 1- notification user info
 2- action String (opend, recived, con..)
 */
+(void)trackNotificationWithAction :(NSString*)action andUserInfo:(NSDictionary *) userInfo whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete{
    NSString * campaign = @"";
    NSString * campaign_name = @"";
    if ([userInfo objectForKey:@"campaign_id"]) {
        campaign = [userInfo objectForKey:@"campaign_id"];
    }
    if ([userInfo objectForKey:@"campaignName"]) {
        campaign_name = [userInfo objectForKey:@"campaignName"];
    }
    
    NSDictionary *details = @{@"channel" :@"apppush",
                              @"action":
                                  @{@"name":action,@"value":@"NA"} ,//name could be received", --> or conversion or open
                              @"userId":[[SdkKeys new] getParserUserID], //
                              @"campaign_id": campaign ,
                              @"campaign_name":campaign_name
                              };
    [[ServiceLayer new] postRequestWithURL:[UrlData getnotificationTrackUrl] withBodyData:details didFinish:^(NSURLResponse *response  , NSMutableDictionary * result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result);
        });
    }];
    
    
}

//MARK: get parser user id

+(NSString *)getUserID{
    return  [[SdkKeys new] getParserUserID];
}

//

+(void)updateUserId:(NSString *)userId{
    //update current user id
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"user"] = [PFUser currentUser];
    currentInstallation[@"userId"] = userId;
    [currentInstallation saveInBackground];
    [[SdkKeys new] setParserUserID:userId];
    
    // update user id
    PFUser * currentUser = [PFUser currentUser];
    currentUser[@"userId"] = userId;
    [currentUser saveInBackground];
    
    //update user id in notification channel
    PFQuery *query = [PFQuery queryWithClassName:@"NotificationChannels"];
    [query whereKey:@"userId" equalTo:currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject *user in objects) {
            user[@"userId"] = userId;
            [user saveInBackground];
        }
    }];
    
}

+(void)logPurchaseForItem:(PurchaseItem *)item whenFinish:(void (^)(BOOL, NSError *))onComplete{
    
    ///add user object for notification channels
    PFObject *purchaseItemObject = [PFObject objectWithClassName:@"PurchaseTransactions"];
    purchaseItemObject[@"userId"] = [PFUser currentUser].objectId;
    purchaseItemObject[@"productName"] = item.productName;
    purchaseItemObject[@"amount"] =  item.amount;
    purchaseItemObject[@"currency"] =  item.currency;
    
    [purchaseItemObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        onComplete(succeeded,error);
    }];
}
//log new record for user every time, open app
+(void)logAppSession{
    PFObject *appSessionObject = [PFObject objectWithClassName:@"appSessions"];
    appSessionObject[@"userId"] = [PFUser currentUser].objectId;
    [appSessionObject saveInBackground];
}

+(void)enableReciveNotification:(BOOL)enable forType:(NSString *)type whenFinish:(void (^)(BOOL, NSError *))onComplete{
    //update user id in notification channel
    PFQuery *query = [PFQuery queryWithClassName:@"NotificationChannels"];
    [query whereKey:@"userId" equalTo: [PFUser currentUser].objectId];
    [query whereKey:@"type" equalTo:type];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject *user in objects) {
            user[@"appPush"] = [[NSString alloc] initWithFormat:@"%@",enable ? @"YES" : @"NO"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                onComplete(succeeded,error);
            }];
        }
    }];
}



+(void)createNotificationChannelForType:(NSString *)notificationType andExtraItem:(NSString *)item whenFinish:(void (^)(BOOL, NSError *))onComplete{
    PFObject *notificationChannnelsObject = [PFObject objectWithClassName:@"NotificationChannels"];
    notificationChannnelsObject[@"userId"] = [PFUser currentUser].objectId;
    notificationChannnelsObject[@"appPush"] = @YES;
    ///add user object for notification channels
    //mobile app notification
    if([notificationType isEqualToString:[NotificationType Mobile]]){
        
        notificationChannnelsObject[@"type"] =  [NotificationType Mobile];
        // notificationChannnelsObject[@"type"] = @"appPush";
        
    }
    //email sent  notification
    
    if([notificationType isEqualToString:[NotificationType Email]]){
        notificationChannnelsObject[@"type"] = [NotificationType Email];
        notificationChannnelsObject[@"email"] = item;
    }
    //sms sent notification
    if([notificationType isEqualToString:[NotificationType Sms]]){
        notificationChannnelsObject[@"type"] =  [NotificationType Sms];
        notificationChannnelsObject[@"mobileNum"] = item;
    }
    //
    if([notificationType isEqualToString:[NotificationType Web]]){
        notificationChannnelsObject[@"type"] =  [NotificationType Web];
    }
    
    
    
    [notificationChannnelsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        onComplete(succeeded,error);
        
    }];
    
    
}
@end

