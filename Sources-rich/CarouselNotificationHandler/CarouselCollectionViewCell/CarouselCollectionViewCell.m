//
//  CarouselCollectionViewCell.m
//  AppGainSDKCreator
//
//  Created by Mohamed Nabil on 05/01/2025.
//  Copyright © 2025 Ragaie Alfy. All rights reserved.
//


#import "CarouselCollectionViewCell.h"

@implementation CarouselCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // Image View
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    
    // Title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    // Description Label
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.font = [UIFont systemFontOfSize:18];
    self.descriptionLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.descriptionLabel];
    
    self.layer.cornerRadius = 12; // Adjust for desired roundness
    self.layer.borderColor = [UIColor darkGrayColor].CGColor; // Border color
    self.layer.borderWidth = 0.1; // Border width
    self.clipsToBounds = YES;
    
    [self setupConstraints];
}

- (void)setupConstraints {
    // Disable autoresizing mask translation
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Image View Constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
    
    // Title Label Constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.descriptionLabel.topAnchor constant:0]
    ]];
    
    // Description Label Constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
        [self.descriptionLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]
    ]];
}

- (void)configureWithImageURL:(NSString *)imageURL title:(NSString *)title description:(NSString *)description isSelectedCell:(BOOL )isSelectedCell {
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
    if (isSelectedCell) {
        // Animate the scaling
   
        self.transform = CGAffineTransformIdentity;  // Reset scaling

            // Add shadow for selected cell
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowOffset = CGSizeMake(0, 4); // Shadow offset
            self.layer.shadowRadius = 5; // Shadow radius
            self.layer.shadowOpacity = 0.7; // Shadow opacity
    } else {
        // Animate the scaling
            self.transform = CGAffineTransformMakeScale(0.9, 0.9);  // Scale down to 80%
            
            // Remove shadow when not selected
            self.layer.shadowOpacity = 0.0;
    }

    NSURLCache *cache = [NSURLCache sharedURLCache];

    // Check if the image is already cached
    NSURL *url = [NSURL URLWithString:imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSCachedURLResponse *cachedResponse = [cache cachedResponseForRequest:request];

    if (cachedResponse) {
        // If cached image exists, use it
        UIImage *cachedImage = [UIImage imageWithData:cachedResponse.data];
        self.imageView.image = cachedImage;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            UIImage *image = [UIImage imageWithData:imageData];
            NSURLResponse *dummyResponse = [[NSURLResponse alloc] initWithURL:url
                                                                            MIMEType:@"image/jpeg"
                                                               expectedContentLength:imageData.length
                                                                    textEncodingName:nil];
                    
                    // Create the NSCachedURLResponse with the dummy response and image data
                    NSCachedURLResponse *response = [[NSCachedURLResponse alloc] initWithResponse:dummyResponse data:imageData];            [cache storeCachedResponse:response forRequest:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        });
    }
    

}

@end
