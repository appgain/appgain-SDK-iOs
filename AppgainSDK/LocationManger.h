//
//  LocationManger.h
//  PragueNow
//
//  Created by Ragaie Alfy on 3/8/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LocationManger : NSObject <CLLocationManagerDelegate>

@property NSString * city ;
@property NSString * country ;

@end

NS_ASSUME_NONNULL_END
