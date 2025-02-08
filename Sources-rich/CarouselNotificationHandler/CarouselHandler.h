
//
//  CarouselHandler.h
//  AppGainSDKCreator
//
//  Created by Mohamed Nabil on 05/01/2025.
//
//


@interface CarouselHandler : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// Data source for the collection view
@property (nonatomic, strong) NSArray *carouselData;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

// Initialize with data and view controller
- (instancetype)initWithCarouselData:(NSArray *)data viewController:(UIViewController *)viewController;
- (void)reloadWithCarouselData:(NSArray *)data;


@end
