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

//get app keys and configure data
//MARK: init sdk with response for link match of smart link.
+(void)initializeAppWithID:(NSString *)appID andApiKey:(NSString *)appApiKey whenFinish:(void (^)(NSURLResponse *, NSMutableDictionary *))onComplete {
    initDone =  onComplete;
    
    //if no project or parser server is done sent to get parser server data
    if ([[[SDKKeys new] getParserUserID]  isEqual: @""] ) {
        
        SDKKeys* tempSdkKeys = [SDKKeys new];
        [tempSdkKeys setAppApiKey:appApiKey];
        [tempSdkKeys setAppID:appID];
        [[ServiceLayer new] getRequestWithURL:[UrlData getAppKeysUrlWithID:appID] didFinish:^(NSURLResponse * response, NSMutableDictionary * result) {
            //done
            //  NSLog(@"- init  response ==%@",response);
            // NSLog(@"- init matcher  result ==%@",result);
            
            initDone(response,result);
            
            if (result != nil){
                
                [tempSdkKeys setAppSubDomainName: [result objectForKey:@"AppSubDomainName"]];
                [tempSdkKeys setParseAppID: [result objectForKey:@"Parse-AppID"]];
                [tempSdkKeys setParseMasterKey:  [result objectForKey:@"Parse-masterKey"]];
                [tempSdkKeys setParseServerUrl:  [result objectForKey:@"Parse-serverUrl"]];
                //if there is no server parse --> sent match link
                //  if ([[tempSdkKeys getParseServerUrl] isEqualToString:@""]){
                //                    [Appgain CreateLinkMactcherWithUserID:@"" whenFinish:^(NSURLResponse * response, NSMutableDictionary *result) {
                //                        dispatch_async(dispatch_get_main_queue(), ^{
                //                            initDone(response,result);
                //                        });
                //                    }];
                // }
                //if parser server data available for this app call parser configuration
                // else{//else call parser config
                [Appgain configuerServerParser:true];
                //  }
            }
            else{
                NSLog(@"AppGain SDK init is fail");
                //NSLog(@"%@",response);
            }
            
        }];
    }
    //else get match linker data
    else{
        // add last
        //increment every time user run app
        
        [Appgain configuerServerParser:false];
        
        //called match inside this
        //            [Appgain CreateLinkMactcherWithUserID:@"" whenFinish:^(NSURLResponse * response, NSMutableDictionary *result) {
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    initDone(response,result);
        //                });
        //            }];
        
    }
}



//MARK: configure parser server
/*
 No parameter that work form data that saved before in NsUserDefault
 */
+(void)configuerServerParser : (BOOL*)newUser{
    
    // If you would like all objects to be private by default, remove this line.
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        SDKKeys * tempkeys = [SDKKeys new];
        configuration.applicationId = [tempkeys getParseAppID];
        configuration.server =[tempkeys getParseServerUrl];
        configuration.localDatastoreEnabled = YES; // If you need to enable local data store
    }]];
    
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    defaultACL.publicReadAccess = YES;
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    PFUser *currentUser = [PFUser currentUser];
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
        
    }
    
    
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
        [[SDKKeys new] setParserUserID:user.objectId];
        if (!error) {
            if (user) {
                //after create user update parser installation with new user id
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                if ([PFUser currentUser].objectId)
                {
                    currentInstallation[@"user"] = [PFUser currentUser];
                    // currentInstallation[@"type"] = @"appPush";
                    // currentInstallation[@"appPush"] = @"true";
                    
                    currentInstallation[@"userId"] = [[PFUser currentUser] objectId];
                    currentInstallation[@"deviceToken"] = [[SDKKeys new] getDeviceToken];
                    // NSTimeZone *timeZone=[NSTimeZone localTimeZone];
                    
                    currentInstallation.channels = @[[NSString stringWithFormat:@"user_%@",[PFUser currentUser].objectId ]];
                    // currentInstallation.channels = timeZone.name;
                    //[currentInstallation saveInBackground];
                    
                    
                    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        
                    }];
                    
                    ///add user object for notification channels
                    PFObject *notificationChannnelsObject = [PFObject objectWithClassName:@"NotificationChannels"];
                    notificationChannnelsObject[@"userId"] = [PFUser currentUser].objectId;
                    notificationChannnelsObject[@"type"] = @"appPush";
                    notificationChannnelsObject[@"appPush"] = @YES;
                    
                    
                    
                    
                    [notificationChannnelsObject saveInBackground];
                    
                }
                /// Match link for first run
                //                [Appgain CreateLinkMactcherWithUserID:@"" whenFinish:^(NSURLResponse * response, NSMutableDictionary *result) {
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                //                        initDone(response,result);
                //                    });
                //                }];
            }
        } else {   NSString *errorString = [error userInfo][@"error"];   // Show the
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
    
    [[SDKKeys new] setDeviceToken:token];
    
    //set server installion for this device
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    
    [currentInstallation saveInBackground];
    
    
}

//MARK:handle recive remote notification to register status track for it
+(void)handlePush:(NSDictionary *)userInfo forApplication:(UIApplication *)application{
    //  [PFPush handlePush:userInfo];
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result);
        });
        
    }];
    
}


//MARK:create linkMatcher
/*
 input parameter app user id
 */
+(void)deefredDeepLinkingWithUserID :(NSString *)userID whenFinish:(void (^)(NSURLResponse*, NSMutableDictionary*))onComplete{
    
    [[ServiceLayer new] getRequestWithURL:[UrlData getmatcherUrlWithUserID:userID] didFinish:^(NSURLResponse *response, NSMutableDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(response,result);
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
                              @"userId":[[SDKKeys new] getParserUserID], //
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
    return  [[SDKKeys new] getParserUserID];
}

//

+(void)updateUserId:(NSString *)userId{
    
    //update current user id
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"user"] = [PFUser currentUser];
    
    currentInstallation[@"userId"] = userId;
    
    [currentInstallation saveInBackground];
    
    [[SDKKeys new] setParserUserID:userId];
    
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

@end

