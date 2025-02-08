//
//  AppgainRich.m
//  AppGainSDKCreator
//
//  Created by Ragaie Alfy on 6/8/19.
//  Copyright © 2019 Ragaie Alfy. All rights reserved.
//

#import "AppgainRich.h"
#import <UIKit/UIKit.h>
#import "CarouselNotificationHandler/CarouselHandler.h"
@implementation AppgainRich

//MARK : Rich notification part


static UIViewController* viewControllerShared;
static NSString * url;
static CarouselHandler *carouselHandler = nil;
+ (void)didReceiveNotificationRequest:(UNNotificationRequest *)request andNotificationContent :(UNMutableNotificationContent*) bestAttemptContent withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    // self.contentHandler = contentHandler;
    bestAttemptContent = [request.content mutableCopy];
    if ( bestAttemptContent != nil ){
        // Modify the notification content here..
        NSString * urlString  = nil;
        if (request.content.userInfo[@"image-url"] != nil ){
            urlString = request.content.userInfo[@"image-url"];
        }
        if ( urlString != nil ){
            NSURL * fileUrl = [[NSURL alloc] initWithString:urlString];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL:fileUrl];
            if (imageData == nil ) {
                contentHandler(bestAttemptContent);
                return;
            }
            UNNotificationAttachment *   attachment =   [AppgainRich saveImageToDisk:@"attach.png" withData:imageData andOptions:nil];
            [bestAttemptContent setAttachments:@[ attachment ]];
        }
        contentHandler(bestAttemptContent);
    }
}



+ (void)didReceiveNotification:(UNNotification* _Nullable )notification inViewController : (UIViewController*) viewController{
    //type
    NSString * type = notification.request.content.userInfo[@"type"];
    NSString * attachmentUrl = notification.request.content.userInfo[@"attachment"];
    NSString * callForAction = notification.request.content.userInfo[@"call2action"];
    if ([type isEqual:NULL] || [attachmentUrl isEqual:NULL]){
        return;
    }
    CGRect viewFrame = viewController.view.frame;
    
    if ([callForAction isKindOfClass:NSString.class]){
    
        viewFrame = CGRectMake(0, 0 , viewController.view.frame.size.width, viewController.view.frame.size.height - 40);
    }
    
    if ([type isEqualToString:@"photo"]){
        UIActivityIndicatorView * loader = [[UIActivityIndicatorView alloc] init];
        [loader setCenter:viewController.view.center];
        [loader setColor:[UIColor lightGrayColor] ];
        [viewController.view addSubview:loader];
        [loader startAnimating];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:viewFrame];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: attachmentUrl]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView setImage:[UIImage imageWithData:data] ];
                [viewController.view addSubview:imageView];
                
            });
        });
        
    }else if ([type isEqualToString:@"gif"] || [type isEqualToString:@"webView"] ){
        
        WKWebView * myWebView = [[WKWebView alloc] initWithFrame:viewFrame];
        NSURL *theURL = [[NSURL alloc] initWithString:attachmentUrl];
        [myWebView loadRequest:[NSURLRequest requestWithURL:theURL]];
        [viewController.view addSubview:myWebView];
        
    }else if ([type isEqualToString:@"video"]){

        NSURL *videoURL = [NSURL URLWithString: attachmentUrl];
         AVPlayer *player = [AVPlayer playerWithURL:videoURL];
         AVPlayerLayer * playerlyer = [AVPlayerLayer new];
        [playerlyer setPlayer:player];
        [playerlyer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [playerlyer setFrame:viewFrame] ;
        [viewController.view.layer addSublayer:playerlyer];
        [player play];
//        NSURL *videoURL = [NSURL URLWithString: attachmentUrl];
//        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
//        AVPlayerViewController * playerViewController = [AVPlayerViewController new];
//        playerViewController.player = player;
//
//        viewControllerShared = viewController;
//        [viewController.view addSubview:playerViewController.view];
//
//        [viewController presentViewController:playerViewController animated:YES completion:nil];
//
    }else  if ([type isEqualToString:@"htmlWebView"]){
        UIActivityIndicatorView * loader = [[UIActivityIndicatorView alloc] init];
        [loader setCenter:viewController.view.center];
        [loader setColor:[UIColor lightGrayColor] ];
        [viewController.view addSubview:loader];
        [loader startAnimating];
        WKWebView * myWebView = [[WKWebView alloc] initWithFrame:viewFrame];
        [myWebView loadHTMLString:attachmentUrl baseURL:NULL];
        [viewController.view addSubview:myWebView];
        
    }else  if ([type isEqualToString:@"carousel"]){
        NSArray *carousel = notification.request.content.userInfo[@"carousel"];
        carouselHandler = [[CarouselHandler alloc] initWithCarouselData:carousel viewController:viewController];

        [carouselHandler reloadWithCarouselData:carousel];
        
    }
    if ([callForAction isKindOfClass:NSString.class] ){
        
        viewControllerShared = viewController;
        url = callForAction;
        UIButton *action = [[UIButton alloc] initWithFrame:CGRectMake((viewController.view.frame.size.width / 2) - 50, viewController.view.frame.size.height - 35 , 100, 30)];
        action.layer.cornerRadius = 15;
        [action setTitle:@"View" forState:UIControlStateNormal];
        action.backgroundColor = UIColor.lightGrayColor;
        [viewController.view addSubview:action];
        [action addTarget:self action:@selector(openView:)
         forControlEvents:UIControlEventTouchUpInside];
    }
}
+ (void) openView:(UIButton *) sender {

    WKWebView * myWebView = [[WKWebView alloc] initWithFrame:viewControllerShared.view.frame];
    NSURL *theURL = [[NSURL alloc] initWithString:url];
    [myWebView loadRequest:[NSURLRequest requestWithURL:theURL]];
    [viewControllerShared.view addSubview:myWebView];

}

+ (UNNotificationAttachment*)saveImageToDisk:(NSString *)fileIdentifier withData:(NSData *)data andOptions:(NSDictionary*) options {
    
    NSFileManager * fileManager = NSFileManager.defaultManager;
    
    NSString *folderName = NSProcessInfo.processInfo.globallyUniqueString;
    NSURL * folderURL = [[[NSURL alloc] initFileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:folderName isDirectory:YES];
    [fileManager createDirectoryAtURL:folderURL withIntermediateDirectories:YES attributes:nil error:nil];
    NSURL * fileURL = [folderURL URLByAppendingPathComponent:fileIdentifier];
    if ( [data writeToURL:fileURL options:NSDataWritingAtomic  error:nil] == YES){
        UNNotificationAttachment* attachment =  [UNNotificationAttachment attachmentWithIdentifier:fileIdentifier URL:fileURL options:options error:nil];
        return attachment;
        
    }
    return nil;
}


static void handleCarouselType(NSArray *carousel, UIViewController * _Nullable viewController) {
    CGRect scrollViewFrame = CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height);
    UIScrollView *carouselScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    carouselScrollView.showsHorizontalScrollIndicator = NO;
    
    // Create a UIStackView to hold the carousel items
    UIStackView *carouselStackView = [[UIStackView alloc] init];
    carouselStackView.axis = UILayoutConstraintAxisHorizontal;
    carouselStackView.spacing = 10; // Spacing between items
    carouselStackView.alignment = UIStackViewAlignmentFill;
    carouselStackView.distribution = UIStackViewDistributionFillEqually;
    
    // Loop through the carousel data and create a UIView for each item
    for (NSDictionary *item in carousel) {
        NSString *imageUrl = item[@"imageUrl"];
        NSString *title = item[@"title"];
        NSString *description = item[@"description"];
        
        if (imageUrl) {
            // Container view for image and labels
            UIView *itemView = [[UIView alloc] init];
            itemView.clipsToBounds = YES;

            // Image view for the carousel image
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [itemView addSubview:imageView];
            
            // Load the image asynchronously
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
            });
            
            // Title label
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = title;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            
            // Description label
            UILabel *descriptionLabel = [[UILabel alloc] init];
            descriptionLabel.text = description;
            descriptionLabel.textColor = [UIColor whiteColor];
            descriptionLabel.font = [UIFont systemFontOfSize:18];
            descriptionLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            descriptionLabel.textAlignment = NSTextAlignmentCenter;
            
            // Add labels to the item view
            [itemView addSubview:titleLabel];
            [itemView addSubview:descriptionLabel];
            
            // Add constraints for image and labels
            [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [imageView.topAnchor constraintEqualToAnchor:itemView.topAnchor].active = YES;
            [imageView.leadingAnchor constraintEqualToAnchor:itemView.leadingAnchor].active = YES;
            [imageView.trailingAnchor constraintEqualToAnchor:itemView.trailingAnchor].active = YES;
            [imageView.bottomAnchor constraintEqualToAnchor:itemView.bottomAnchor].active = YES;
            
      
            
            [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [descriptionLabel.leadingAnchor constraintEqualToAnchor:itemView.leadingAnchor constant:10].active = YES;
            [descriptionLabel.trailingAnchor constraintEqualToAnchor:itemView.trailingAnchor constant:-10].active = YES;
            [descriptionLabel.bottomAnchor constraintEqualToAnchor:itemView.bottomAnchor constant:-10].active = YES;
            
            [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [titleLabel.leadingAnchor constraintEqualToAnchor:itemView.leadingAnchor constant:10].active = YES;
            [titleLabel.trailingAnchor constraintEqualToAnchor:itemView.trailingAnchor constant:-10].active = YES;
            [titleLabel.bottomAnchor constraintEqualToAnchor:descriptionLabel.topAnchor constant:0].active = YES;
            
            // Add the item view to the stack view
            [carouselStackView addArrangedSubview:itemView];
        }
    }
    
    // Add the stack view to the scroll view
    [carouselScrollView addSubview:carouselStackView];
    
    // Set constraints for the stack view
    [carouselStackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [carouselStackView.leadingAnchor constraintEqualToAnchor:carouselScrollView.leadingAnchor].active = YES;
    [carouselStackView.trailingAnchor constraintEqualToAnchor:carouselScrollView.trailingAnchor].active = YES;
    [carouselStackView.topAnchor constraintEqualToAnchor:carouselScrollView.topAnchor].active = YES;
    [carouselStackView.bottomAnchor constraintEqualToAnchor:carouselScrollView.bottomAnchor].active = YES;
    [carouselStackView.heightAnchor constraintEqualToConstant:scrollViewFrame.size.height].active = YES;
    viewController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    // Add the scroll view to the main view
    [viewController.view addSubview:carouselScrollView];
}

@end
