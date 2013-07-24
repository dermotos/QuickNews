//
//  RDCThumbnailDownloader.h
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDCAsyncDownloader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) void (^completionCallback)(void);
@property (nonatomic, strong) NSMutableData *downloadedData;
@property (nonatomic, assign) NSMutableDictionary *cache;

//Begins a background download of the image at the requested URL. The completion callback must be set prior to calling this method.
//If the image loading fails, the callback simply isn't invoked.
- (void)beginDownloadFromURL:(NSURL*) url;
//For completeness. Allows cancelling of the in progress download. Currently not used.
- (void)cancelDownload;

@end
