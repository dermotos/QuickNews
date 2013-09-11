//
//  QuickNewsTests.m
//  QuickNewsTests
//
//  Created by Dermot on 29/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "QuickNewsTests.h"
#import "RDCAsyncDownloader.h"

@implementation QuickNewsTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAsyncDownloader
{
    BOOL __block asyncResult = NO;
    //Tests the functionality of the async downloader
    NSMutableDictionary *cache = [[NSMutableDictionary alloc] init];
    RDCAsyncDownloader *downloader = [[RDCAsyncDownloader alloc] init];
    [downloader setCache:cache];
    [downloader setCompletionCallback:^{
        asyncResult = YES;
        NSLog(@"Async Downloader received data");
        
    }];
    
    [downloader setFailureCallback:^{
        if(downloader.downloadedData.length == 0)
            STFail(@"Async Downloader test failed, the downloaded data was empty");
        else
            STFail(@"Async Downloader test failed, the downloader received partial data");
        
        asyncResult = NO;
    }];
    
    
    [downloader beginDownloadFromURL:[NSURL URLWithString:@"https://www.google.com.au/images/srpr/logo4w.png"]];
    WAIT_WHILE(!asyncResult, 5);

}


@end
