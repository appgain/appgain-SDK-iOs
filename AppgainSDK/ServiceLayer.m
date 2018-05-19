//
//  ServiceLayer.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import "ServiceLayer.h"

@implementation ServiceLayer

///MARK:Get request for api
-(void)getRequestWithURL:(NSString *)url didFinish:(void (^)(NSURLResponse *, NSMutableDictionary *))onComplete{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: url]];
    
    //To get device user agent
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    //add header parameters
    [urlRequest setAllHTTPHeaderFields: @{@"appApiKey": [[SDKKeys new] getAppApiKey] ,@"User-Agent": secretAgent}];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
                });
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSMutableDictionary *responseDictionary;// = [NSMutableDictionary new];
                                          
                if( data != nil )
                {
                 NSError *parseError = nil;
                 responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    }
                
                onComplete(response,responseDictionary);

                
                }];
    [dataTask resume];
    


}

//MARK: post request data.
-(void)postRequestWithURL:(NSString *)url withBodyData:(NSDictionary *)dictionaryBody didFinish:(void (^)(NSURLResponse *, NSMutableDictionary *))onComplete{
// show network indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields: @{@"appApiKey": [[SDKKeys new] getAppApiKey],@"content-type": @"application/json"}];

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
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSMutableDictionary *responseDictionary;// = [NSMutableDictionary new];
            if(data != nil )
            {
            
                NSError *parseError = nil;
                responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            }
            onComplete(response,responseDictionary);
            }];
    [dataTask resume];
    


}

@end
