//
//  NotificationStatus.m
//  AppGainSDKCreator
//  Created by appgain.io on 2/13/18.
//  Copyright © 2018 appgain.io All rights reserved.

#import "NotificationStatus.h"

@implementation NotificationStatus

+(NSString *)Opened{
    return @"open";
}

+(NSString *)Received{
    return @"received";
}

+(NSString *)Dismissed{
    return @"dismiss";
}

+(NSString *)Conversion{
    return @"conversion";
}
@end
