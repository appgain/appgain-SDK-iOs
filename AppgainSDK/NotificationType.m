//
//  NotificationType.m
//  AppGain.io
//
//  Created by Ragaie Alfy on 8/3/19.
//  Copyright © 2019 Ragaie Alfy. All rights reserved.
//

#import "NotificationType.h"

@implementation NotificationType

+(NSString*)Mobile{
    return @"appPush";
}
+(NSString*)Sms{
    return @"sms";
}
+(NSString*)Email{
    return @"email";
}
+(NSString*)Web{
    return @"webPush";
}


@end
