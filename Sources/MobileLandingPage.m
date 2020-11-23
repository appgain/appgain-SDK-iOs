//
//  LandingPageObject.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.



//MobileDeepPage
#import "MobileLandingPage.h"

@implementation MobileLandingPage


@synthesize LogoUrl = _LogoUrl;
@synthesize header = _header;
@synthesize paragraph = _paragraph;
//slider images
@synthesize sliderImages = _sliderImages;
//arry of buttons
@synthesize Buttons = _Buttons;
@synthesize socialSetting = _socialSetting;


@synthesize lang = _lang;
@synthesize web_push_subscription = _web_push_subscription;
@synthesize image_default = _image_default;
@synthesize label = _label;

@synthesize slug = _slug;



-(MobileLandingPage *)initWithLogo:(NSString *)logoUrl andHeader:(NSString *)header andParagraph:(NSString *)paragraph withSliderUrlImages:(NSArray *)images andButtons:(NSArray *)buttons andSocialMediaSetting:(SocialmediaSettings *)mediaSetting language:(NSString *)lang andSubscription:(NSString *)sub andimage:(NSString *)image andlabel:(NSString *)label{

    
    self = [super init];
    if(self) {
        _LogoUrl = logoUrl;
        _header = header;
        _paragraph = paragraph;
        _sliderImages = images;
        _Buttons = buttons;
        _socialSetting = mediaSetting;
        _lang = lang;
        _web_push_subscription = sub;
        _image_default = image;
        _label = label;
        _slug = @"";
    }
    return self;


}
//MARK:Create Dictionary value for header part

-(NSDictionary*)headerPage{

    NSDictionary *details = @{@"type":@"basic.h+logo",@"logo":@{@"src":_LogoUrl},@"header":@{@"text":_header}};
    
    return details;
    
}

//MARK:Create Dictionary value for slider value

-(NSDictionary* )sliderValue{
    NSMutableArray *images = [NSMutableArray new];
    for (NSString *item in _sliderImages) {
        [images addObject:@{@"src":item}];
    }
    NSDictionary *details = @{@"type":@"basic.slider",@"slider":images,@"speed":@3000,@"direction":@"horizontal",@"autoplay":@4000};
    return details;
}
//MARK:Create Dictionary value for buttons values

-(NSArray*)buttonsValues{

    NSMutableArray *buttons = [NSMutableArray new];
    for (MobileLandingPageButton *item in _Buttons) {
        [buttons addObject:item.dictionaryValue];
    }
    return buttons;
}
//fff
//MARK:Create Dictionary value for object
-(NSDictionary *)dictionaryValue{
    {

        NSMutableArray * components = [NSMutableArray arrayWithObjects:self.headerPage,@{@"type":@"basic.p",@"content":_paragraph}, self.sliderValue, nil];
        [components addObjectsFromArray:[self buttonsValues]];
        
        NSDictionary *details = @{@"lang" :_lang,
                              @"web_push_subscription":@YES,
                              @"label":_label,
                            //  @"slug"    :_slug,
                              @"image_default":@NO,
            @"components": components,
            @"socialmedia_settings":_socialSetting.dictionaryValue,
        };
    return details;


}
}

@end
