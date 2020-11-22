//
//  SocialmediaSettings.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import "SocialmediaSettings.h"

@implementation SocialmediaSettings

@synthesize title = _title;
@synthesize mediaDescription = _mediaDescription;
@synthesize image = _image;



-(id)initWithTitle:(NSString *)title andDescription:(NSString *)description andImage:(NSString *)image{
    self = [super init];
    if(self) {
        _title = title;
        _mediaDescription = description;
        _image = image;
    }
    return self;
   
}
//MARK:Create Dictionary value for object

-(NSDictionary *)dictionaryValue{

    NSDictionary *details = @{@"title":_title,@"description":_mediaDescription,@"image":_image};
    
    
    return details;
    
}

@end
