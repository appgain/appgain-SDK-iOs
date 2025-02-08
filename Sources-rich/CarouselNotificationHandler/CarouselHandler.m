
//  CarouselHandler.m
//  AppGainSDKCreator
//
//  Created by Mohamed Nabil on 05/01/2025.

//

#import <UIKit/UIKit.h>
#import "CarouselHandler.h"
#import "CarouselCollectionViewCell/CarouselCollectionViewCell.h"
@implementation CarouselHandler {
    UICollectionView *_collectionView;
    UIViewController *_viewController;
}

- (instancetype)initWithCarouselData:(NSArray *)data viewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _carouselData = data;
        _viewController = viewController;
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _viewController.view.backgroundColor =[UIColor whiteColor];
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
       stackView.axis = UILayoutConstraintAxisVertical; // Stack items vertically
       stackView.distribution = UIStackViewDistributionFill;
       stackView.spacing = 10;
       stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.backgroundColor =[UIColor whiteColor];

       [_viewController.view addSubview:stackView];
       
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake(_viewController.view.frame.size.width-100,_viewController.view.frame.size.height-50);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.scrollEnabled=false;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[CarouselCollectionViewCell class] forCellWithReuseIdentifier:@"CarouselCell"];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;

 
    
    
    UIButton *scrollButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [scrollButton setTitle:@">>" forState:UIControlStateNormal];
    [scrollButton setTitleColor:[UIColor blackColor] forState:normal];
    scrollButton.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollButton addTarget:self action:@selector(scrollToNextItem) forControlEvents:UIControlEventTouchUpInside];
    [scrollButton setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    scrollButton.layer.cornerRadius = 12; // Adjust for desired roundness
    scrollButton.layer.borderColor = [UIColor darkGrayColor].CGColor; // Border color
    scrollButton.layer.borderWidth = 0.2; // Border width
    scrollButton.clipsToBounds = YES;
    
    [stackView addArrangedSubview:_collectionView];
    [stackView addArrangedSubview:scrollButton];
    

    // Set constraints for the stack view
     [NSLayoutConstraint activateConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:_viewController.view.leadingAnchor constant:12],
         [stackView.trailingAnchor constraintEqualToAnchor:_viewController.view.trailingAnchor  constant:-12 ],
         [stackView.topAnchor constraintEqualToAnchor:_viewController.view.topAnchor constant:5],
         [stackView.bottomAnchor constraintEqualToAnchor:_viewController.view.bottomAnchor constant:-15],
     ]];
     
     [NSLayoutConstraint activateConstraints:@[
         [_collectionView.heightAnchor constraintEqualToConstant:_viewController.view.frame.size.height-50],
         [scrollButton.heightAnchor constraintEqualToConstant:50],
     ]];
}

#pragma mark - Scroll to Next Item
- (void)scrollToNextItem {
    // Get the currently visible index
    if (self.selectedIndexPath) {
        NSInteger nextItem = self.selectedIndexPath.item + 1;
        NSInteger numberOfItems = [self collectionView:_collectionView numberOfItemsInSection:0];
        
        // Check if the next item is within bounds
        if (nextItem < numberOfItems) {
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
            self.selectedIndexPath=nextIndexPath;
            [UIView animateWithDuration:0.3 animations:^{
                [self->_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }];
        }else{
            self.selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self->_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
    [self reloadWithCarouselData:self.carouselData];
}

- (void)reloadWithCarouselData:(NSArray *)data {
    self.carouselData = data;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.carouselData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarouselCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarouselCell" forIndexPath:indexPath];
    cell.imageView.image = nil;
    NSDictionary *item = self.carouselData[indexPath.item];
    NSString *imageURL = item[@"imageUrl"];
    NSString *title = item[@"title"];
    NSString *description = item[@"description"];
    [cell configureWithImageURL:imageURL title:title description:description isSelectedCell:self.selectedIndexPath.item==indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected item at index: %ld", (long)indexPath.item);
}

@end



