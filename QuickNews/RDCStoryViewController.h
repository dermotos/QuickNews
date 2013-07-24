//
//  RDCStoryViewController.h
//  QuickNews
//
//  Created by Dermot on 22/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface RDCStoryViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *navigationURL;
@property (nonatomic, strong) NSURL *tinyURL;
@property (nonatomic, strong) NSString *headLine;

//Initializes the ViewController with all information necessary to display the story. The tinyURL and headLine are required
//for sharing purposes.
- (id)initWithURL:(NSURL *)url tinyUrl:(NSURL*) tinyURL headLine:(NSString*) headLine;

@end
