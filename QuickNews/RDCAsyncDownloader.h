//
//  RDCThumbnailDownloader.h
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDCAsyncDownloader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, copy) void (^completionCallback)(void);
@property (nonatomic, strong) NSMutableData *downloadedData;

- (void)beginDownloadFromURL:(NSURL*) url;
- (void)cancelDownload;

@end
