//
//  CarouselCollectionViewCell.h
//  AppGainSDKCreator
//
//  Created by Mohamed on 05/01/2025.
//  Copyright © 2025 Ragaie Alfy. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarouselCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

- (void)configureWithImageURL:(NSString *)imageURL title:(NSString *)title description:(NSString *)description isSelectedCell:(BOOL )isSelectedCell;

@end

NS_ASSUME_NONNULL_END
