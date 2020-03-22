//
//  ServiceLayer.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SdkKeys.h"
@interface ServiceLayer : NSObject

-(void)getRequestWithURL :(NSString*) url didFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError*))onComplete  ;
-(void)postRequestWithURL :(NSString*) url withBodyData :(NSDictionary* ) dictionaryBody  didFinish:(void (^)(NSURLResponse*, NSMutableDictionary*,NSError*))onComplete ;

@end
