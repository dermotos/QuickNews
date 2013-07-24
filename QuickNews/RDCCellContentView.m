//
//  RDCCellContentView.m
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//



#import "RDCCellContentView.h"

@implementation RDCCellContentView

- (id)initWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL andCache:(NSMutableDictionary*)imageCache
{
    self = [super initWithFrame:frame];
    if (self) {
        //The header should always exist
        CGSize headLineSize;
        if(imageURL)
            headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width - (kRDCPadding + kRDCImageWidth) type:RDCTextTypeHeader];
        else
            headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width type:RDCTextTypeHeader];
        
        self.headLineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kRDCPadding, kRDCPadding, headLineSize.width, headLineSize.height)] autorelease];
        self.headLineLabel.text = headline;
        self.headLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.headLineLabel.numberOfLines = 0;
        self.headLineLabel.backgroundColor = [UIColor clearColor];
        self.headLineLabel.textColor = [RDCStylizer colorFromHexString:kRDCHeaderFontColor];
        self.headLineLabel.font = [UIFont fontWithName:kRDCHeaderFontName size:kRDCHeaderFontSize];
        [self addSubview:self.headLineLabel];

        
        //Slugline is optional
        if(slugline)
        {
            CGSize slugLineSize;
           
            if(imageURL)
                slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width - (kRDCPadding + kRDCImageWidth)  type:RDCTextTypeSlug];
            else
                slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width type:RDCTextTypeSlug];

            self.slugLineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kRDCPadding, self.headLineLabel.frame.size.height + kRDCPadding, slugLineSize.width, slugLineSize.height)] autorelease];
            self.slugLineLabel.text =  slugline;
            self.slugLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.slugLineLabel.numberOfLines = 0;
            self.slugLineLabel.font = [UIFont fontWithName:kRDCSlugFontName size:kRDCSlugFontSize];
            self.slugLineLabel.backgroundColor = [UIColor clearColor];
            self.slugLineLabel.textColor = [RDCStylizer colorFromHexString:kRDCSlugFontColor];
            [self addSubview:self.slugLineLabel];
        }
        //Image is optional
        if(imageURL){
            self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - (kRDCPadding + kRDCImageWidth), kRDCPadding, kRDCImageWidth, kRDCImageHeight)] autorelease];
            self.imageView.backgroundColor = [UIColor clearColor];
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.imageView.layer setCornerRadius:3.0]; //rounded corners of images
            [self.imageView.layer setMasksToBounds:YES];
            
            if(imageCache && [imageCache objectForKey:[imageURL absoluteString]]){
                //load pre-existing image from cache, as it already exists
                self.imageView.alpha = 1.0;
                self.imageView.image = [UIImage imageWithData:[imageCache objectForKey:[imageURL absoluteString]]];
            }
            else{
                //hide imageView and download image in the background
                self.imageView.alpha = 0.0;
                [self beginBackgroundDownloadFromURL:imageURL withCache:imageCache];
            }

            [self addSubview:self.imageView];
        }
    }
    return self;
}

-(void)beginBackgroundDownloadFromURL:(NSURL*)url withCache:(NSMutableDictionary*) imageCache{
    RDCAsyncDownloader __block *downloader = [[RDCAsyncDownloader alloc] init];
    downloader.completionCallback = ^{
        if(downloader.downloadedData){
            [imageCache setValue:downloader.downloadedData forKey:[url absoluteString]];
            /* NOTE: Im using a small library i've written for a (yet unreleased) personal iOS app project.
             This library creates the effect of the image fading into view, unfocused, whilst gradually coming into focus.
             I have implemented this as a category on UIView, so it can be implemented in any project with just one line of code.
             This uses CoreImage for the gaussian filter, which is only available in iOS6. It gracefully degrades in iOS6 to a simple alpha fade.
             
             This is the first time I've used it on actual images (rather than text & simple shape views) and I've noticed the algorithm could do with
             some tweaking for images.
             */
            self.imageView.image = [UIImage imageWithData:downloader.downloadedData];
            [self.imageView fadeIn:1.5]; 
        }
    };
    [downloader beginDownloadFromURL:url];
}


- (void)updateWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL andCache:(NSMutableDictionary*)imageCache{
    //Reusing the existing contentView. As a result, existing views may need to be removed if they are no longer used, if not, they are just re-configured for the new data
    self.frame = frame;

    if(!slugline && self.slugLineLabel)
    {
        [self.slugLineLabel removeFromSuperview];
        self.slugLineLabel = nil;
    }
    
    if(!imageURL && self.imageView)
    {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    //Change the size of the labels to match their new content & change content
    CGSize headLineSize;
    if(imageURL)
        headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width - (kRDCPadding + kRDCImageWidth) type:RDCTextTypeHeader];
    else
        headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width type:RDCTextTypeHeader];
   
    self.headLineLabel.frame = CGRectMake(kRDCPadding, kRDCPadding, headLineSize.width, headLineSize.height);
    self.headLineLabel.text = headline;
    
    if(slugline)
    {
        CGSize slugLineSize;
        if(imageURL)
            slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width - (kRDCPadding + kRDCImageWidth)  type:RDCTextTypeSlug];
        else
            slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width type:RDCTextTypeSlug];
        if(!self.slugLineLabel)
        {
            self.slugLineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kRDCPadding, self.headLineLabel.frame.size.height + kRDCPadding, slugLineSize.width, slugLineSize.height)] autorelease];
            self.slugLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.slugLineLabel.numberOfLines = 0;
            self.slugLineLabel.font = [UIFont fontWithName:kRDCSlugFontName size:kRDCSlugFontSize];
            self.slugLineLabel.backgroundColor = [UIColor clearColor];
            self.slugLineLabel.textColor = [RDCStylizer colorFromHexString:kRDCSlugFontColor];
            [self addSubview:self.slugLineLabel];

        }
        else{
            self.slugLineLabel.frame = CGRectMake(kRDCPadding, self.headLineLabel.frame.size.height + kRDCPadding, slugLineSize.width, slugLineSize.height);
        }
        
        self.slugLineLabel.text =  slugline;
    }
    
    if(imageURL){
        if(!self.imageView){
            //imageView doesn't exist, initialize it
            self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - (kRDCPadding + kRDCImageWidth), kRDCPadding, kRDCImageWidth, kRDCImageHeight)] autorelease];
            self.imageView.backgroundColor = [UIColor clearColor];
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:self.imageView];

        }
        else{
            //ImageView already exists, reconfigure with new parameters:
            self.imageView.frame = CGRectMake(self.frame.size.width - (kRDCPadding + kRDCImageWidth), kRDCPadding, kRDCImageWidth, kRDCImageHeight);
            //NSLog(@"%@",self.imageView.superview);
        }
        if(imageCache && [imageCache objectForKey:[imageURL absoluteString]]){
            //load pre-existing image from cache
            self.imageView.alpha = 1.0;
            self.imageView.image = [UIImage imageWithData:[imageCache objectForKey:[imageURL absoluteString]]];
        }
        else{
            //hide imageView and download image in the background
            self.imageView.alpha = 0.0;
            [self beginBackgroundDownloadFromURL:imageURL withCache:imageCache];
        }
    }
}


+ (float) computeHeightOfText:(NSString*) text forWidth:(float)contentWidth type:(RDCTextType)textType{
    return [RDCCellContentView computeSizeOfText:text forWidth:contentWidth type:textType].height;
}

+ (CGSize) computeSizeOfText:(NSString*) text forWidth:(float)contentWidth type:(RDCTextType)textType{
    UIFont *textFont = [UIFont fontWithName:(textType == RDCTextTypeHeader) ? kRDCHeaderFontName : kRDCSlugFontName
                                       size:(textType == RDCTextTypeHeader) ? kRDCHeaderFontSize : kRDCSlugFontSize];
    CGSize computedSize = [text sizeWithFont:textFont constrainedToSize:CGSizeMake(contentWidth - (kRDCPadding * 2), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return computedSize;
}

+ (float) computeRowHeightOfWidth:(float)contentWidth withHeaderText:(NSString*) headerText slugText:(NSString*)slugText displayingImage:(BOOL)imageAvailable{
    float headerHeight = [RDCCellContentView computeHeightOfText:headerText forWidth:imageAvailable ? contentWidth - (kRDCImageWidth + kRDCPadding) : contentWidth type:RDCTextTypeHeader] + kRDCPadding;
    float slugHeight = 0;
    if(slugText){
        float slugTextWidth = (imageAvailable ? contentWidth - (kRDCImageWidth + kRDCPadding) : contentWidth) + kRDCPadding ;
        slugHeight = [RDCCellContentView computeHeightOfText:slugText forWidth:slugTextWidth type:RDCTextTypeSlug] + kRDCPadding;
    }
    //NSLog(@"Computed row height: %f", headerHeight + slugHeight);
    float rowHeight = headerHeight + slugHeight;
    
    if(imageAvailable && rowHeight < kRDCImageHeight + kRDCPadding)
        rowHeight = kRDCImageHeight + (kRDCPadding * 2);
    
    return rowHeight + kRDCRowPadding;
}





@end






















