//
//  SDKKeys.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import "SdkKeys.h"

@implementation SdkKeys

//appApiKey   <—- that will create from your account in server side .
//Response AppID
//AppSubDomainName
//Parse-AppID
//AppSubDomainName
//appApiKey
//parse-serverUrl
//parse-masterKey
//


//appApiKey
-(NSString*) getAppApiKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:APP_API_KEY];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void) setAppApiKey :(NSString*)  key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:APP_API_KEY];
    [defaults synchronize];
}

//AppID
-(NSString*) getAppID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:APP_ID];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void) setAppID :(NSString*)  key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:APP_ID];
    [defaults synchronize];
}

//AppSubDomainName
-(NSString*) getAppSubDomainName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:APP_SUB_DOMAIN_NAME];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void) setAppSubDomainName :(NSString*)  key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:APP_SUB_DOMAIN_NAME];
    [defaults synchronize];
}

//AppSubDomainName
-(NSString*) getParseClientID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:PARSE_CLIENT_ID];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void) setParseClientID:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey: PARSE_CLIENT_ID];
    [defaults synchronize];
}

//Parse-AppID
-(NSString*) getParseAppID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:PARSE_APP_ID];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void) setParseAppID :(NSString*)  key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:PARSE_APP_ID];
    [defaults synchronize];
}


//parse-serverUrl
-(NSString*) getParseServerUrl{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:PARSE_SERVER_URL];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void) setParseServerUrl :(NSString*)  key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:PARSE_SERVER_URL];
    [defaults synchronize];
}

//parse-masterKey
-(NSString*) getParseMasterKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:PARSE_MASTER_KEY];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void) setParseMasterKey :(NSString*)  key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue: key forKey:PARSE_MASTER_KEY];
    [defaults synchronize];
}

///in first time will be null so return true and set first run false
-(NSString *)getFirstRun{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:FIRST_RUN_APP];
    if (theKey == NULL ){
        [self setFirstRun:@"false"];
        [self setFirstMatch:@"true"];
        return @"true";
    }
    [self setFirstMatch:theKey];
    return theKey;
}


-(void)setFirstRun:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:FIRST_RUN_APP];
    [defaults synchronize];
}


-(NSString *)getFirstMatch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:FIRST_MATCH];
    if (theKey == NULL ){
        return @"false";
    }
    return theKey;
}


-(void)setFirstMatch:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:FIRST_MATCH];
    [defaults synchronize];
}

////MARK:first install
-(NSString*) getInstallRun{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:FIRST_INSTALL_APP];
    if (theKey == NULL ){
        [self setInstallRun:@"false"];
        return @"true";
    }
    return theKey;
}

-(void) setInstallRun :(NSString*)  key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:FIRST_INSTALL_APP];
    [defaults synchronize];
}

////MARK:first install
-(NSString*) getIda{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:FIRST_IDA_RETRIVE];
    if (theKey == NULL ){
        [self setInstallRun:@"false"];
        return @"true";
    }
    return theKey;
}

-(void) setIda :(NSString*)  key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:FIRST_IDA_RETRIVE];
    [defaults synchronize];
}

///save value of automatic configuration
-(NSString* )isReturnUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * theKey = [defaults stringForKey:IS_RETURN_USER];
  
    
       if (theKey == NULL ){
           return @"false";
       }
    
    
    return theKey;
}


-(void)setIsReturnUser:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:key forKey:IS_RETURN_USER];
    [defaults synchronize];
}


///userID i
-(NSString *)getUserID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:USER_ID];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void)setUserID:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:USER_ID];
    [defaults synchronize];
}

-(void)setDeviceADID :(NSString *) adid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:adid forKey:IDFA_ID];
    [defaults synchronize];
}

-(NSString *)getDeviceADID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:IDFA_ID];
    if (theKey == NULL ){
        return @"Not allowed";
    }
    return theKey;
}

-(NSString *)getDeviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:PUSH_DEVICE_TOKEN];
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}

-(void)setDeviceToken:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:PUSH_DEVICE_TOKEN];
    [defaults synchronize];
}
@end
