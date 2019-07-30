//
//  PurchaseItem.h
//  AppGain.io
//
//  Created by Ragaie Alfy on 7/30/19.
//  Copyright © 2019 Ragaie Alfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseItem : NSObject
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *currency;

@property (nonatomic, strong) NSString   *amount;
-(PurchaseItem *)initWithProductName:(NSString *)productName andAmount:(NSString *)amount andCurrency:(NSString *)currency ;

@end

NS_ASSUME_NONNULL_END
