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
        return @"true";
    }
    return theKey;
}


-(void)setFirstRun:(NSString *)key{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:FIRST_RUN_APP];
    [defaults synchronize];
}

///save value of automatic configuration
-(NSString* )getAutomaticConfigureUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:AUTOMATIC_CONFIGURATION_USER];
    
    
    if (theKey == NULL ){
        theKey = @"false";
    }
    return theKey;
}


-(void)setAutomaticConfigureUser:(BOOL)key{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (key){
        [defaults setValue:@"true" forKey:AUTOMATIC_CONFIGURATION_USER];
    }
    else{
        [defaults setValue:@"false" forKey:AUTOMATIC_CONFIGURATION_USER];

    }
    [defaults synchronize];
}


///userID in parser server

-(NSString *)getParserUserID{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theKey = [defaults stringForKey:USER_PARSE_ID];
    
    
    if (theKey == NULL ){
        return @"";
    }
    return theKey;
}


-(void)setParserUserID:(NSString *)key{
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:USER_PARSE_ID];
    [defaults synchronize];
}

-(NSString *)getDeviceADID{
    return  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
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
