//
//  LandingTarget.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import <Foundation/Foundation.h>

@interface MobileLandingPageButton : NSObject



@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *iosUrlTarget;
@property (nonatomic, strong) NSString *androidUrlTarget;
@property (nonatomic, strong) NSString *webUrlTarget;

- (id)initWithTitle :(NSString*) title iosTarget:(NSString*)iosurlTarget andAndroid:(NSString*)androidUrlTarget andWeb: (NSString*)webUrlTarget ;
-(NSDictionary*)dictionaryValue;


@end
