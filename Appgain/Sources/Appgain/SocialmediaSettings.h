//
//  SocialmediaSettings.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import <Foundation/Foundation.h>

@interface SocialmediaSettings : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *mediaDescription;
@property (nonatomic, strong) NSString *image;

- (id)initWithTitle:(NSString*)title andDescription:(NSString*)description andImage : (NSString*)image ;

-(NSDictionary *)dictionaryValue;
@end
