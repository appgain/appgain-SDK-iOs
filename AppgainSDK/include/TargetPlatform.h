//
//  Platform.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import <Foundation/Foundation.h>




@interface TargetPlatform : NSObject  


@property (nonatomic, strong) NSString *primary;
@property (nonatomic, strong) NSString *fallback;

- (id)initWithPrimary:(NSString*)primary withFallBack:(NSString*)fallBack ;


@end
