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

- (id)initWithURL:(NSURL *)url tinyUrl:(NSURL*) tinyURL headLine:(NSString*) headLine{
    self = [super init];
    if(self){
        self.navigationURL = url;
        self.tinyURL = tinyURL;
        self.headLine = headLine;
        self.title = @"News Story";
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:self.webView];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:shareButton] autorelease];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.navigationURL]];
    [shareButton release];
}

//for iOS5 rotating
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}


-(void)shareButtonTouchUpInside:(UIButton *)sender{
    // Note, this is just an example. This could be appended with Facebook, iMessage, Email (which all have share view controllers available as of iOS6),
    // and to other services such as tumblr via APIs or 3rd party libraries such such as ShareKit.
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:@"Share Story" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", nil];
    [shareSheet showInView:self.view];
    [shareSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex)
    {
        case 0: //Twitter
        {
            Class socialKitController = NSClassFromString(@"SLComposeViewController");
            if(socialKitController)
            {
                //Social kit is available
                if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                {
                    SLComposeViewController *tweetComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                    [tweetComposer setInitialText:[NSString stringWithFormat:@"%@ #SMH #QuickNews",self.headLine]];
                    if(self.tinyURL)
                        [tweetComposer addURL:self.tinyURL];
                    [tweetComposer setCompletionHandler:^(SLComposeViewControllerResult result) {
                        switch (result) {
                            case SLComposeViewControllerResultCancelled:
                                NSLog(@"Twitter post Cancelled");
                                break;
                            case SLComposeViewControllerResultDone:
                                NSLog(@"Twitter post Successful");
                                break;
                                
                            default:
                                break;
                        }
                    }];
                    
                    [self presentViewController:tweetComposer animated:YES completion:nil];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Unavailable" message:@"Twitter is not available on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }

            }
            else //fall back to the Twitter framework of iOS5
            {
                if([TWTweetComposeViewController canSendTweet])
                {
                    /* NOTE:
                     
                     This block of code is untested. I do not have an iOS5 device available to test, and there is a bug
                     that prevents me from testing it in the simulator. The bug is detailed here: 
                     https://developer.apple.com/library/ios/#releasenotes/General/RN-iOSSDK-6_1/index.html#//apple_ref/doc/uid/TP40012869
                     under the section "Social".
                     Looks fine though :-)
                     
                     */
                    TWTweetComposeViewController *tweetComposer = [[TWTweetComposeViewController alloc] init];
                    [tweetComposer setInitialText:[NSString stringWithFormat:@"%@ #SMH #QuickNews",self.headLine]];
                    if(self.tinyURL)
                        [tweetComposer addURL:self.tinyURL];
                    
                    [self presentViewController:tweetComposer animated:YES completion:nil];
                    [tweetComposer release];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Unavailable" message:@"Twitter is not available on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            }
        }
            break;
            
        case 1:
            //Close, do nothing
            break;
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
