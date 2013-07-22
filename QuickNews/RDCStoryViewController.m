//
//  RDCStoryViewController.m
//  QuickNews
//
//  Created by Dermot on 22/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCStoryViewController.h"

@interface RDCStoryViewController ()

@end

@implementation RDCStoryViewController

- (id)initWithURL:(NSURL *)url{
    self = [super init];
    if(self){
        self.navigationURL = url;
        self.title = @"News";
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.navigationURL]];
    //TODO: Add activity indicator centre-view?
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
