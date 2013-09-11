//
//  RDCThumbnailDownloader.m
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCAsyncDownloader.h"

@interface RDCAsyncDownloader()

@property (nonatomic, strong) NSURLConnection *connection;


@end

@implementation RDCAsyncDownloader

- (void)beginDownloadFromURL:(NSURL*) url{
    self.downloadedData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancelDownload{
    [self.connection cancel];
    self.connection = nil;
    self.downloadedData = nil;
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.connection = nil;
    self.downloadedData = nil;
    if(self.failureCallback)
        self.failureCallback();
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.downloadedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if(self.completionCallback)
        self.completionCallback();
    self.connection = nil;
}




@end
