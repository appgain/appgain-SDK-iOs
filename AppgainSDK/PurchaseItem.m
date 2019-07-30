//
//  PurchaseItem.m
//  AppGain.io
//
//  Created by Ragaie Alfy on 7/30/19.
//  Copyright © 2019 Ragaie Alfy. All rights reserved.
//

#import "PurchaseItem.h"

@implementation PurchaseItem

@synthesize currency = _currency;
@synthesize productName = _productName;
@synthesize amount = _amount;


-(PurchaseItem *)initWithProductName:(NSString *)productName andAmount:(NSString *)amount andCurrency:(NSString *)currency {
    self = [super init];
    if(self) {
        _currency = currency;
        _productName = productName;
        _amount = amount;
    }
    return self;
}
@end
