//
//  LandingPageObject.h
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.
#import <Foundation/Foundation.h>
#import "SocialmediaSettings.h"
#import "MobileLandingPageButton.h"

@interface MobileLandingPage : NSObject


@property (nonatomic, strong) NSString *LogoUrl;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *paragraph;
//slider images
@property (nonatomic, strong) NSArray *sliderImages;
//arry of buttons
@property (nonatomic, strong) NSArray *Buttons ;

@property (nonatomic, strong) SocialmediaSettings *socialSetting ;



@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *web_push_subscription;
@property (nonatomic, strong) NSString *image_default;
@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) NSString *slug ;



- (MobileLandingPage*)initWithLogo :(NSString*)logoUrl andHeader :(NSString*) header andParagraph :(NSString*) paragraph withSliderUrlImages:(NSArray*)images andButtons:(NSArray*) button andSocialMediaSetting :(SocialmediaSettings*) mediaSetting language: (NSString*)lang andSubscription : (NSString*) sub andimage:(NSString*) image andlabel :(NSString*)label;



-(NSDictionary*)dictionaryValue;



//{
//    "lang": "en",

//    "web_push_subscription": true,


//    "components": [
//                   { "type": “basic.h+logo", "logo": { "src": “[Array of
                       //what]” },"header": 			{ "text": "Product Name “ }
//                   },
//                   { "type": "basic.p", "content": "[input] "},
//                   { "type": "basic.btn","text": "[input]", "alt-text":"[input]",
//                       "targets": { "ios": “[input]", "android": “[input]", "web": "[input]"}
//                   },
//                   {  "type": “basic.slider", "slider": [
//                       {  "src": “[input]" }, { "src": "[input]"},{"src": "[input]"} ],
//                           "speed": 3000,
//                           "direction": "horizontal",
//                           "autoplay": 4000
//                       } ],
//
//
//                       "socialmedia_settings": { "title": “[input]", "description":    	"[input]","image": "[input]"
//                       },

//                       "label": "[input]",
//                       "image_default":false,
//                       "slug":"[input]"-->Optional
//}’


@end
