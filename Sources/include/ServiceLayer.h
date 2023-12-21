//
//  ServiceLayer.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SdkKeys.h"
@interface ServiceLayer : NSObject


-(void)requestWithURL :(NSString*) url httpWay: (NSString*) way didFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError*))onComplete  ;
-(void)postRequestWithURL :(NSString*) url withBodyData :(NSDictionary* ) dictionaryBody withParameters: (NSDictionary* ) dictionaryParameters  didFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError*))onComplete ;

@end
