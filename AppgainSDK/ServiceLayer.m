//
//  ServiceLayer.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import "ServiceLayer.h"
#import <WebKit/WebKit.h>
@implementation ServiceLayer

WKWebView* webView;

///MARK:Get request for api
-(void)getRequestWithURL:(NSString *)url didFinish:(void (^)(NSURLResponse *, NSMutableDictionary *,NSError*))onComplete{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: url]];
    [self stringByEvaluatingJavaScript:^(NSString * secretAgent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //create the Method "GET"
            [urlRequest setHTTPMethod:@"GET"];
            //add header parameters
            if ([url containsString:@"match"]){
                [urlRequest setAllHTTPHeaderFields: @{@"appApiKey": [[SdkKeys new] getAppApiKey] ,@"User-Agent": secretAgent, @"idfa":[[SdkKeys new] getDeviceADID]}];
            }
            else{
                [urlRequest setAllHTTPHeaderFields: @{@"appApiKey": [[SdkKeys new] getAppApiKey] ,@"User-Agent": secretAgent}];
            }
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
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields: @{@"appApiKey": [[SdkKeys new] getAppApiKey],@"content-type": @"application/json"}];
    
    //    NSLog(@"---- url sent r : %@", [dictionaryBody description]);
    //    NSLog(@"---- url sent r : %@", url);
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dictionaryBody options:NSJSONWritingPrettyPrinted error:&error];
    
    [urlRequest setHTTPBody:bodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
        //hide network indecator
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        });
        
        // NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSMutableDictionary *responseDictionary;// = [NSMutableDictionary new];
        if(data != nil )
        {
            
            NSError *parseError = nil;
            responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        }
        onComplete(response,responseDictionary,error);
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
