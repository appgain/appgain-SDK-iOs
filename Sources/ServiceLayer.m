//
//  ServiceLayer.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import "ServiceLayer.h"
#import <WebKit/WebKit.h>
@implementation ServiceLayer
WKWebView* webView;
///MARK: request for api


-(void)requestWithURL:(NSString *)url httpWay:(NSString *)way didFinish:(void (^)(NSURLResponse *, NSMutableDictionary *, NSError *))onComplete{
/////MARK:Get request for api
//-(void)getRequestWithURL:(NSString *)url didFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError*))onComplete{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: url]];
    [self stringByEvaluatingJavaScript:^(NSString * secretAgent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //create the Method "GET"
            [urlRequest setHTTPMethod:way];
            //add header parameters
            SdkKeys *tempKeys = [SdkKeys new];

            if ([url containsString:@"match"]){
                [urlRequest setAllHTTPHeaderFields: @{@"appApiKey": [tempKeys getAppApiKey] ,@"User-Agent": secretAgent, @"idfa":[[SdkKeys new] getDeviceADID]}];
            }
            else{
                [urlRequest setAllHTTPHeaderFields: @{@"appApiKey": [tempKeys getAppApiKey] ,@"User-Agent": secretAgent}];
            }
            
            
            if (![[tempKeys getAppID] isEqualToString:@""]){
                [urlRequest addValue:[tempKeys getAppID] forHTTPHeaderField:@"appId"];
            }
            if (![[tempKeys getParseMasterKey] isEqualToString:@""]){
                [urlRequest addValue:[tempKeys getParseMasterKey] forHTTPHeaderField:@"x-parse-master-key"];
            }
            if (![[tempKeys getParseAppID] isEqualToString:@""]){
                    [urlRequest addValue:[tempKeys getParseAppID] forHTTPHeaderField:@"x-parse-application-id"];
                }
            [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
                    
                    //  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    NSMutableDictionary *responseDictionary;// = [NSMutableDictionary new];
                    
                    if( data != nil )
                    {
                        NSError *parseError = nil;
                        responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    }
                    
                    onComplete(response,responseDictionary,error);
                });
                
            }];
            [dataTask resume];
            
        });
        
    }];
    
    
}



//MARK: post request data.
-(void)postRequestWithURL:(NSString *)url withBodyData:(NSDictionary *)dictionaryBody didFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError*))onComplete{
    // show network indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    SdkKeys *tempKeys = [SdkKeys new];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setAllHTTPHeaderFields: @{@"appApiKey": [tempKeys getAppApiKey]}];
    if (![[tempKeys getAppID] isEqualToString:@""]){
        [urlRequest addValue:[tempKeys getAppID] forHTTPHeaderField:@"appId"];
    }
    if (![[tempKeys getParseMasterKey] isEqualToString:@""]){
        [urlRequest addValue:[tempKeys getParseMasterKey] forHTTPHeaderField:@"x-parse-master-key"];
    }
    if (![[tempKeys getParseAppID] isEqualToString:@""]){
        [urlRequest addValue:[tempKeys getParseAppID] forHTTPHeaderField:@"x-parse-application-id"];
    }
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if ([url containsString:[[SdkKeys new] getParseServerUrl]]){
        [urlRequest addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        
    }
    else{
        [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    }
    
    NSError *error;
    if (dictionaryBody != nil){
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dictionaryBody options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"body details %@",bodyData);
        [urlRequest setHTTPBody:bodyData];
        
        
        
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
        //hide network indecator
        dispatch_async(dispatch_get_main_queue(), ^{
       
        
        // NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSMutableDictionary *responseDictionary;// = [NSMutableDictionary new];
        if(data != nil )
        {
            
            NSError *parseError = nil;
            responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        }
        onComplete(response,responseDictionary,error);
    });
    }];
    [dataTask resume];
}

-(void)stringByEvaluatingJavaScript:(void (^)(NSString *))onComplete{
    //  NSString *resultString = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{

    webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                NSString *  resultString = [NSString stringWithFormat:@"%@", result];
                onComplete(resultString);
            }
        } else {
            onComplete(@"");
        }
    }];
    });
}


@end
