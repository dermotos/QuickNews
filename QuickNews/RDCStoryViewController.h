//
//  RDCStoryViewController.h
//  QuickNews
//
//  Created by Dermot on 22/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDCStoryViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *navigationURL;

- (id)initWithURL:(NSURL *)url;

@end
