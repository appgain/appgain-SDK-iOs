//
//  AppgainRich.m
//  AppGainSDKCreator
//
//  Created by Ragaie Alfy on 6/8/19.
//  Copyright © 2019 Ragaie Alfy. All rights reserved.
//

#import "AppgainRich.h"

@implementation AppgainRich

//MARK : Rich notification part

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
    
    
    if ([type isEqual:NULL] || [attachmentUrl isEqual:NULL]){
        
        return;
    }
    
    if ([type isEqualToString:@"photo"]){
        UIActivityIndicatorView * loader = [[UIActivityIndicatorView alloc] init];
        [loader setCenter:viewController.view.center];
        [loader setColor:[UIColor lightGrayColor] ];
        [viewController.view addSubview:loader];
        [loader startAnimating];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:viewController.view.frame];
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
        
        WKWebView * myWebView = [[WKWebView alloc] initWithFrame:viewController.view.frame];
        NSURL *theURL = [[NSURL alloc] initWithString:attachmentUrl];
        [myWebView loadRequest:[NSURLRequest requestWithURL:theURL]];
        [viewController.view addSubview:myWebView];
        
    }else if ([type isEqualToString:@"video"]){
        
        NSURL *videoURL = [NSURL URLWithString: attachmentUrl];
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController * playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [viewController.view addSubview:playerViewController.view];
        [viewController presentViewController:playerViewController animated:YES completion:nil];
        
    }else  if ([type isEqualToString:@"htmlWebView"]){
        UIActivityIndicatorView * loader = [[UIActivityIndicatorView alloc] init];
        [loader setCenter:viewController.view.center];
        [loader setColor:[UIColor lightGrayColor] ];
        [viewController.view addSubview:loader];
        [loader startAnimating];
        WKWebView * myWebView = [[WKWebView alloc] initWithFrame:viewController.view.frame];
        [myWebView loadHTMLString:attachmentUrl baseURL:NULL];
        [viewController.view addSubview:myWebView];
        
    }
    
    
    
    
    
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


@end
