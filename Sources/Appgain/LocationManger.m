//
//  LocationManger.m
//  PragueNow
//
//  Created by Ragaie Alfy on 3/8/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

#import "LocationManger.h"

@implementation LocationManger


CLLocationManager  *locationManager ;


@synthesize city;
@synthesize country;

- (instancetype)init
{
    self = [super init];
    if (self) {
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
    return self;
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            return;
        }
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        [self setCity: placemark.locality];
        [self setCountry: placemark.country];
    }];
}
@end
