//
//  SDKKeys.h
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

//AppID
//AppSubDomainName
//Parse-AppID
//AppSubDomainName
//appApiKey
//parse-serverUrl
//parse-masterKey
//

#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface SdkKeys : NSObject

#define APP_API_KEY @"app_api_key"
#define APP_ID @"app_id"
#define APP_SUB_DOMAIN_NAME @"app_sub_domain_name"
#define PARSE_APP_ID @"parse_app_id"
#define PARSE_CLIENT_ID @"parse_client_id"

#define PARSE_SERVER_URL @"parse-server_url"
#define PARSE_MASTER_KEY @"parse-master_key"
#define FIRST_RUN_APP @"first_run_app"
#define FIRST_MATCH @"first_match"
#define FIRST_INSTALL_APP @"first_install_app"
#define FIRST_IDA_RETRIVE @"first_ida_retrive"
#define IS_RETURN_USER @"is_return_user"
#define USER_ID @"user_id"
#define PUSH_DEVICE_TOKEN @"push_device_token"
#define IDFA_ID @"idfa_id"

//MARK:appApiKey
-(NSString*) getAppApiKey;
-(void) setAppApiKey :(NSString*)  key;
//MARK:AppID
-(NSString*) getAppID;
-(void) setAppID :(NSString*)  key;

//MARK:AppSubDomainName
-(NSString*) getAppSubDomainName;
-(void) setAppSubDomainName :(NSString*)  key;

//MARK:Parse-AppID
-(NSString*) getParseAppID;
-(void) setParseAppID :(NSString*)  key;
//MARK:Parse-ClientID
-(NSString*) getParseClientID;
-(void) setParseClientID :(NSString*)  key;


//MARK:parse-serverUrl
-(NSString*) getParseServerUrl;
-(void) setParseServerUrl :(NSString*)  key;

//MARK:parse-masterKey
-(NSString*) getParseMasterKey;
-(void) setParseMasterKey :(NSString*)  key;

//MARK:first run
-(NSString*) getFirstRun;
-(void) setFirstRun :(NSString*)  key;

////MARK:first install
-(NSString*) getInstallRun;
-(void) setInstallRun :(NSString*)  key;


-(void)setFirstMatch:(NSString *)key;

-(NSString *)getFirstMatch;

//MARK:device token
-(NSString*) getDeviceToken;
-(void) setDeviceToken :(NSString*)  key;


//MARK: Advertising Identifier value
-(void)setDeviceADID :(NSString *) adid;
-(NSString*) getDeviceADID;

///userID in parser server
-(NSString *)getUserID;
-(void)setUserID:(NSString *)key;

-(NSString* )isReturnUser;
-(void)setIsReturnUser:(NSString*)key;

-(NSString*) getIda;
-(void) setIda :(NSString*)  key;


@end
