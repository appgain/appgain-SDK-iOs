//
//  AppGainTracker.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import "Appgain.h"

@implementation  Appgain



static  NSString  *smartLinkId;
static LocationManger * location;

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


+(void)initializeAppWithClientID:(NSString *)clientId andAppId:(NSString *)appId andApiKey:(NSString *)appApiKey whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError * error))onComplete{
    [[SdkKeys new] setParseClientID:clientId];
    [Appgain initializeAppWithID:appId andApiKey:appApiKey whenFinish:^(NSURLResponse * reponse, NSMutableDictionary * result,NSError * error) {
        onComplete(reponse,result,error);
    }];
}



//get app keys and configure data
//MARK: init sdk with response .
+(void)initializeAppWithID:(NSString *)appID andApiKey:(NSString *)appApiKey automaticConfiguration:(BOOL)configureAutomatic whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError *))onComplete{
    initDone =  onComplete;
    [[SdkKeys new] setAutomaticConfigureUser: configureAutomatic];
    location = [LocationManger new];
    //if no project or parser server is done sent to get parser server data
    if ([[[SdkKeys new] getParserUserID]  isEqual: @""] ) {
        SdkKeys* tempSdkKeys = [SdkKeys new];
        [tempSdkKeys setAppApiKey:appApiKey];
        [tempSdkKeys setAppID:appID];
        [[ServiceLayer new] getRequestWithURL:[UrlData getAppKeysUrlWithID:appID] didFinish:^(NSURLResponse * response, NSMutableDictionary * result,NSError * error) {
            if (result != nil){
                if ([result objectForKey:@"AppSubDomainName"] != nil){
                    [tempSdkKeys setAppSubDomainName: [result objectForKey:@"AppSubDomainName"]];
                    [tempSdkKeys setParseAppID: [result objectForKey:@"Parse-AppID"]];
                    [tempSdkKeys setParseMasterKey:  [result objectForKey:@"Parse-masterKey"]];
                    [tempSdkKeys setParseServerUrl:  [result objectForKey:@"Parse-serverUrl"]];
                    [Appgain configuerServerParser:YES andAutomaticConfiguration:configureAutomatic];
                    initDone(response,result,error);
                }
                else{
                    initDone(response,result,error);
                }
            }
            else{
                initDone(response,result,error);
                NSLog(@"AppGain SDK init is fail");
            }
        }];
    }
    else{
        // add last
        //increment every time user run app
        [Appgain configuerServerParser:NO andAutomaticConfiguration:configureAutomatic];
        initDone(nil,nil,nil);
    }
}

+(void)initializeAppWithID:(NSString *)appID andApiKey:(NSString *)appApiKey whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError *))onComplete {
    initDone =  onComplete;
    //if no project or parser server is done sent to get parser server data
    if ([[[SdkKeys new] getParserUserID]  isEqual: @""] ) {
        SdkKeys* tempSdkKeys = [SdkKeys new];
        [tempSdkKeys setAppApiKey:appApiKey];
        [tempSdkKeys setAppID:appID];
        [[ServiceLayer new] getRequestWithURL:[UrlData getAppKeysUrlWithID:appID] didFinish:^(NSURLResponse * response, NSMutableDictionary * result,NSError * error) {
            if (result != nil){
                if ([result objectForKey:@"AppSubDomainName"] != nil){
                    [tempSdkKeys setAppSubDomainName: [result objectForKey:@"AppSubDomainName"]];
                    [tempSdkKeys setParseAppID: [result objectForKey:@"Parse-AppID"]];
                    [tempSdkKeys setParseMasterKey:  [result objectForKey:@"Parse-masterKey"]];
                    [tempSdkKeys setParseServerUrl:  [result objectForKey:@"Parse-serverUrl"]];
                    initDone(response,result,error);
                }
                else{
                    initDone(response,result,error);
                }
            }
            else{
                initDone(response,result,error);
                NSLog(@"AppGain SDK init is fail");
            }
            
        }];
    }
    else{
        initDone(nil,nil,nil);
    }
}


//MARK: deInitializeApp
+(void)deInitializeApp{
    if ([[[SdkKeys new] getAutomaticConfigureUser] isEqualToString:@"true"]){
        [Appgain createUserID];
    }
}


//MARK: configure parser server
/*
 No parameter that work form data that saved before in NsUserDefault
 */
+(void)configuerServerParser : (BOOL)newUser andAutomaticConfiguration : (BOOL)configure{
    
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
    //call matching api for
    
    
    
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
        if (configure) {
            [Appgain createUserID];
        }
    }
    else{
        [user incrementKey:@"usagecounter"];
        [user saveInBackground];
        [Appgain logAppSession];
        
    }
    //add record with user id for every time app open
    
}

+(void)skipUserLogin{
    [Appgain createUserID];
}


+(void)createUserInstallation{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if ([PFUser currentUser].objectId)
    {
        currentInstallation[@"user"] = [PFUser currentUser];
        currentInstallation[@"deviceToken"] = [[SdkKeys new] getDeviceToken];
        currentInstallation[@"enable"] = @YES;
        currentInstallation[@"enabled"] = @YES;
        currentInstallation[@"push_enabled"] = @YES;
        currentInstallation.channels = @[[NSString stringWithFormat:@"user_%@",[PFUser currentUser].objectId ]];
        [currentInstallation saveInBackground];
        ///add user object for notification channels
        PFObject *notificationChannnelsObject = [PFObject objectWithClassName:@"NotificationChannels"];
        notificationChannnelsObject[@"userId"] = [[SdkKeys new] getParserUserID];
        notificationChannnelsObject[@"type"] = @"appPush";
        notificationChannnelsObject[@"enable"] = @YES;
        notificationChannnelsObject[@"enabled"] = @YES;
        notificationChannnelsObject[@"appPush"] = @YES;
        [notificationChannnelsObject saveInBackground];
    }
}

//MARK:Register device token for push notifiaction
/*
 parameter device token data
 */

+(void)RegisterDeviceWithToken:(NSData*)deviceToken{
    //  NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //  token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //  NSLog(@"content---%@", token);
    //  NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
    NSString *token =   [deviceToken base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //  NSLog(@"content---%@", token);
    [[SdkKeys new] setDeviceToken:token];
    //set server installion for this device
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

//MARK:handle recive remote notification to register status track for it
+(void)handlePush:(NSDictionary *)userInfo forApplication:(UIApplication *)application{
    
    [Appgain trackNotificationWithAction: [NotificationStatus Opened]   andUserInfo:userInfo  whenFinish:^(NSURLResponse *response, NSMutableDictionary *result,NSError *error) {
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
+(void)CreateSmartLinkWithObject:( SmartDeepLink*)linkObject whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    [[ServiceLayer new] postRequestWithURL: [UrlData getSmartUrl] withBodyData: linkObject.dictionaryValue didFinish:^(NSURLResponse * response, NSMutableDictionary *result,NSError * error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
        });
        
    }];
    
}

//MARK:create linkMatcher
/*
 input parameter app user id
 */
+(void)CreateLinkMactcherWithUserID :(NSString *)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    
    [[ServiceLayer new] getRequestWithURL:[UrlData getmatcherUrlWithUserID:userID] didFinish:^(NSURLResponse *response, NSMutableDictionary *result,NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
            //old response
            
            PFUser * currentUser = [PFUser currentUser];

            if ([[result objectForKey:@"extra_data"] objectForKey:@"params"]){
                NSArray * parameter = [[result objectForKey:@"extra_data"] objectForKey:@"params"];
                for (NSDictionary *item in parameter){
                    for (id  key in item) {
                        id value = item[key];
                        // do stuff
                        currentUser[key] = value;
                    }
                }
            }
            
            
            //new handle
            if ([result objectForKey:@"extra_data"] ){
                NSDictionary * parameter = [result objectForKey:@"extra_data"] ;
                for (id  key in parameter){
                    id value = parameter[key];
                    // do stuff
                    currentUser[key] = value;
                    
                }
            }
            
            ///add key for smart link in first run
            // update user id
            //if case user first logging and have matching link id
            //add link idto user and save id for app session
            
            if (result[@"smart_link_id"]){
                smartLinkId = result[@"smart_link_id"];
                
            }
            if ( result[@"smart_link_url"] ){
                
                currentUser[@"SDL"] = result[@"smart_link_url"];
            }
            
            
            if (([[[SdkKeys new] getFirstMatch] isEqualToString:@"true"]) && (result[@"smart_link_id"] )){
                currentUser[@"smartlink_id"] = result[@"smart_link_id"];
            }
            
            [currentUser saveInBackground];

        });
    }];
}


//MARK : create LandingPage for user
+(void)createLandingPageWithObject:(MobileLandingPage *)landingPage whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    [[ServiceLayer new] postRequestWithURL:[UrlData getLandingPageUrl] withBodyData: [landingPage dictionaryValue] didFinish:^(NSURLResponse *response, NSMutableDictionary *result,NSError * error) {
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
 3-
 */
+(void)CreateAutomatorWithTrigger:(NSString *)trigger andUserId:(NSString *)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    [[ServiceLayer new] getRequestWithURL:[UrlData getAutomatorUrlWithTriggerPoint:trigger] didFinish:^(NSURLResponse *response , NSMutableDictionary * result,NSError * error) {
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

+(NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

+(void)CreateAutomatorWithTrigger:(NSString *)trigger andUserId:(NSString *)userID andParameters:(NSMutableDictionary*) parameters whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    
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
    [[ServiceLayer new] getRequestWithURL:urlWithQuerystring didFinish:^(NSURLResponse *response , NSMutableDictionary * result,NSError * error) {
        
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
+(void)trackNotificationWithAction :(NSString*)action andUserInfo:(NSDictionary *) userInfo whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
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
    [[ServiceLayer new] postRequestWithURL:[UrlData getnotificationTrackUrl] withBodyData:details didFinish:^(NSURLResponse *response  , NSMutableDictionary * result,NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result,error);
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
    if ([smartLinkId isKindOfClass:[ NSString class] ]){
        currentUser[@"smartlink_id"] = smartLinkId;
    }
    [currentUser saveInBackground];
    
    //update user id in notification channel
    PFQuery *query = [PFQuery queryWithClassName:@"NotificationChannels"];
    if ([currentUser.objectId isKindOfClass: NSString.class]){
        [query whereKey:@"userId" equalTo:currentUser.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            for (PFObject *channel in objects) {
                channel[@"userId"] = userId;
                if ([smartLinkId isKindOfClass:[ NSString class] ]){
                    channel[@"smartlink_id"] = smartLinkId;
                }
                [channel saveInBackground];
            }
        }];
    }
    //update user app session
    PFQuery *querySession = [PFQuery queryWithClassName:@"appSessions"];
    if ([currentUser.objectId isKindOfClass: NSString.class]){
        [querySession whereKey:@"userId" equalTo:currentUser.objectId];
        [querySession findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            for (PFObject *appSession in objects) {
                appSession[@"userId"] = userId;
                if ([smartLinkId isKindOfClass:[ NSString class] ]){
                    appSession[@"smartlink_id"] = smartLinkId;
                }
                [appSession saveInBackground];
                
            }
        }];
    }
}

+(void)logPurchaseForItem:(PurchaseItem *)item whenFinish:(void (^)(BOOL, NSError *))onComplete{
    
    ///add user object for notification channels
    PFObject *purchaseItemObject = [PFObject objectWithClassName:@"PurchaseTransactions"];
    purchaseItemObject[@"userId"] = [[SdkKeys new] getParserUserID];
    purchaseItemObject[@"productName"] = item.productName;
    purchaseItemObject[@"amount"] =  @([item.amount doubleValue]);
    purchaseItemObject[@"currency"] =  item.currency;
    purchaseItemObject[@"platform"] =  @"ios";
    purchaseItemObject[@"transactionAt"] = [NSDate new] ;
    //add smart link if user first login app and purchased item.
    if ([smartLinkId isKindOfClass:[ NSString class] ]){
        purchaseItemObject[@"smartlink_id"] = smartLinkId;
    }
    [purchaseItemObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            onComplete(succeeded,error);
            //increse value of ltv by amount purchase item in user object
            PFUser * currentUser = [PFUser currentUser];
            PFQuery *querySession = [PFQuery queryWithClassName:@"user"];
            if ([currentUser.objectId isKindOfClass: NSString.class]){
                [querySession whereKey:@"userId" equalTo:currentUser.objectId];
                [querySession findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    for (PFObject *user in objects) {
                        user[@"ltv"] =  [NSNumber numberWithInteger: [user[@"ltv"] integerValue] + [item.amount integerValue]];
                        [user saveInBackground];
                        
                    }
                }];
            }
            
        });
    }];
}
//log new record for user every time, open app
+(void)logAppSession{
    PFObject *appSessionObject = [PFObject objectWithClassName:@"appSessions"];
    if ([[PFUser currentUser].objectId isKindOfClass: NSString.class]){
        appSessionObject[@"userId"] = [[SdkKeys new] getParserUserID];
        appSessionObject[@"platform"] = @"ios";
        PFUser * user = [PFUser currentUser];
        user[@"lastSeenAt"] = [NSDate new];
        [user saveInBackground];
        if ([smartLinkId isKindOfClass:[ NSString class] ]){
            appSessionObject[@"smartlink_id"] = smartLinkId;
        }
        [appSessionObject saveInBackground];
    }
}
//32WyFD5pQP
+(void)enableReciveNotification:(BOOL)enable forType:(NSString *)type whenFinish:(void (^)(BOOL, NSError *))onComplete{
    //update user id in notification channel
    PFQuery *query = [PFQuery queryWithClassName:@"NotificationChannels"];
    [query whereKey:@"userId" equalTo: [[SdkKeys new] getParserUserID]];
    [query whereKey:@"type" equalTo:type];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject *channel in objects) {
            channel[@"appPush"] = [NSNumber numberWithBool:enable];//[[NSString alloc] initWithFormat:@"%@",enable ? @"YES" : @"NO"];
            channel[@"enable"] = [NSNumber numberWithBool:enable];
            [channel saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    onComplete(succeeded,error);
                });
            }];
        }
    }];
}



+(void)createNotificationChannelForType:(NSString *)notificationType andExtraItem:(NSString *)item whenFinish:(void (^)(BOOL, NSError *))onComplete{
    PFObject *notificationChannnelsObject = [PFObject objectWithClassName:@"NotificationChannels"];
    notificationChannnelsObject[@"userId"] = [[SdkKeys new] getParserUserID];
    notificationChannnelsObject[@"appPush"] = @YES;
    notificationChannnelsObject[@"enable"] = @YES;
    notificationChannnelsObject[@"enabled"] = @YES;
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            
            onComplete(succeeded,error);
        });
        
    }];
    
    
}



//then call user id by register new user
/*flow inside this function
 1- create unique id for this app
 2- update parser installtion with this user id
 3- create user object data for NotificationChannels table.
 4- finally sent matcher link api
 
 
 */

+ (void)createUserID {
    
    if ([[PFUser currentUser] objectId] == nil){
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        // NSTimeInterval is defined as double
        NSString *userTimeStamp = [NSString stringWithFormat:@"%.20lf", timeStamp];
        //        NSString *deviceID = [[SdkKeys new] getDeviceADID];
        PFUser *user = [PFUser user];
        user.username = userTimeStamp;
        user.password = userTimeStamp;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SdkKeys new] setParserUserID:user.objectId];
                if (!error) {
                    if (user) {
                        [Appgain addExtraParameterUser];
                        //check if id added befoer update all object increment
                        [self checkReinstallUserForAynoumous];
                        
                    }
                } else {
                    NSLog(@"AppGain Fail to create your id %@",error);
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }];
    }
}


//MARK : Login and register

+(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password whenFinish:(void (^)(PFUser *, NSError *))onComplete{
    
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Appgain addExtraParameterUser];
            [self checkReinstallUser];
            
            onComplete(user,error);
        });
    }];
    
}

+ (void)loginWithSocailAccountEmail :(NSString *)userEmail andId:(NSString *)userId andUserName:(NSString *)userName whenFinish:(void (^)(BOOL, NSError *))onComplete{
    
    
    
    [Appgain loginWithEmail:userEmail andPassword:userEmail whenFinish:^(PFUser *user , NSError * error) {
        
        if (user){
            [Appgain addExtraParameterUser];
            
            [self checkReinstallUser];
            onComplete(YES,error);
            
        }
        
        else{
            
            PFUser *user = [PFUser user];
            user.username = userName;
            user.email = userEmail;
            user.password = userId;
            user[@"fbID"] = userId;
            
            [user incrementKey:@"usagecounter"];
            [Appgain signUpWithUser:user whenFinish:onComplete];
        }
        
    }];
    
 
    
}
+(void)signUpWithUser:(PFUser *)user whenFinish:(void (^)(BOOL, NSError *))onComplete{
    
    //first register there not user object
    if ([[PFUser currentUser] objectId] == nil){
        [Appgain loginWithEmail:user.email andPassword:user.password whenFinish:^(PFUser *user , NSError * error) {
              if (user){
                  [Appgain addExtraParameterUser];
                  [self checkReinstallUser];
                  [[SdkKeys new] setParserUserID:user.objectId];

                  onComplete(YES,error);
              }
              else{
                  [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          onComplete(succeeded,error);
                      });
                      [[SdkKeys new] setParserUserID:user.objectId];
                      if (!error) {
                          if (user) {
                              //after create user update parser installation with new user id
                              [self checkReinstallUser];
                              [Appgain addExtraParameterUser];
                              onComplete(YES,error);
                          }
                      } else {
                          NSLog(@"AppGain Fail to create your id %@",error);
                      }
                  }];
              }
          }];
    }
    else {
        PFUser * curUser = [PFUser currentUser];
        
        for (NSString *key in [user allKeys]){
            
            if (user[key]){
                curUser[key] = user[key];
            }
        }
        [curUser saveInBackground];
        [Appgain addExtraParameterUser];
        onComplete(YES,nil);
        
    }
    
    
    
    
}



+(void)addExtraParameterUser{
    
    [Appgain createUserInstallation];
    [Appgain logAppSession];
    
    PFUser * user = [PFUser currentUser];
    NSString *deviceID = [[SdkKeys new] getDeviceADID];
    user[@"devices"] = @[deviceID];
    user[@"madid"] = deviceID;
    user[@"appversion"] =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    user[@"madidIdtype"] = @"idfa";
    
    if (![user[@"smartlink_id"] isKindOfClass:[ NSString class] ]){
        user[@"smartlink_id"] = @"Organic";
    }
    
    if ([[[SdkKeys new] getInstallRun] isEqualToString:@"true"]){
        user[@"installationAt"] = [NSDate new] ;
    }
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier  = [networkInfo subscriberCellularProvider];
    if ([[carrier carrierName] isKindOfClass:[ NSString class] ]){
        user[@"operator"] = [carrier carrierName];
    }
    
    
    user[@"lastSeenAt"] = [NSDate new];
    if ([location city]){
        user[@"city"] = [location city];
    }
    if ([location city]){
        user[@"country"] = [location country];
    }
    
    struct utsname systemInfo;
    uname(&systemInfo);
    user[@"devicemodel"] =  [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    user[@"platform"] = @"ios";
    [user incrementKey:@"usagecounter"];
    //if (![user[@"userId"] isKindOfClass:[ NSString class] ]){
    [Appgain updateUserId:user.objectId];
    //  }
    
    [user saveInBackground];
}



+(void)checkReinstallUser{
    ////find user by IDFA
    PFQuery * query = [PFUser query];
    [query whereKey:@"madid" equalTo:[[SdkKeys new] getDeviceADID]  ];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (objects.count > 0){
                PFUser * user = objects.firstObject;
                // user.objectId
                // PFUser * user = [PFUser currentUser];
                PFQuery *query = [PFQuery queryWithClassName:@"NotificationChannels"];
                [query whereKey:@"userId" equalTo: user.objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (objects.count > 0){
                            if ( ![user[@"deviceToken"] isEqual:  [[SdkKeys new] getDeviceToken] ] ){
                                [Appgain callMatchingApiAndUpdateUser];
                            }
                        }
                    });
                }];
            }
            //end return to main thread
        });
    }];
    
    
}
+(void)checkReinstallUserForAynoumous{
    ////find user by IDFA
    PFQuery * query = [PFUser query];
    [query whereKey:@"madid" equalTo:[[SdkKeys new] getDeviceADID]  ];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (objects.count > 1){
                
                [Appgain callMatchingApiAndUpdateUser];
            
            }
            //end return to main thread
        });
    }];
    
    
}


+(void) callMatchingApiAndUpdateUser{
    
    if ([smartLinkId isKindOfClass:[ NSString class] ]){
        PFUser * user = [PFUser currentUser];
        user[@"reinstall_source"]  = smartLinkId;
        [user incrementKey:@"reinstallcount"];
        [user saveInBackground];
    }
    else{
        [Appgain CreateLinkMactcherWithUserID: @"" whenFinish:^(NSURLResponse *response, NSMutableDictionary * result,NSError * error) {
            PFUser * user = [PFUser currentUser];
            
            if ([smartLinkId isKindOfClass:[ NSString class] ]){
                    user[@"reinstall_source"] = smartLinkId;
               }
            else{
                user[@"reinstall_source"]  = @"organic";
            }
            [user incrementKey:@"reinstallcount"];
            [user saveInBackground];
        }];
    }
    
}

+(void)logEventForAction:(NSString *)action andType:(NSString *)type whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError *))onComplete{
    
   NSDictionary *event = @{@"action":action,@"type":type};
    [[ServiceLayer new] postRequestWithURL:[UrlData getLogEventUrl] withBodyData: event didFinish:^(NSURLResponse *response, NSMutableDictionary *result,NSError * error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              onComplete(response,result,error);
          });
      }];
}

+(void)updateUserProfileFor:(PFUser *)user whenFinish:(void (^)(BOOL, NSError *))onComplete{
    PFUser * currentUser = [PFUser currentUser];
    if ([currentUser objectId]){
          for (NSString *key in [user allKeys]){
              if (user[key]){
                  currentUser[key] = user[key];
              }
          }
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete(succeeded,error);
            });
        }];
    }
}

@end

