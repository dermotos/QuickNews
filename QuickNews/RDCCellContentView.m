//
//  RDCCellContentView.m
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//


/*
 Remaining:
 ---Images (see above)
 Background image loading. Image should fade into view.
 Use CGGradient (get code from Eve)
 Add loader that appears when loading view initially, and when loading story view.
 
 
 Tidy up code
 Retain/Release. Test with analyzer.
 Any further improvements, such as icon, default images, customize title bar, etc...
 
 */



#import "RDCCellContentView.h"

@implementation RDCCellContentView

- (id)initWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL andCache:(NSMutableDictionary*)imageCache
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //The header should always exist
        CGSize headLineSize;
        if(imageURL)
            headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width - (kRDCTextSidePadding + kRDCImageWidth) type:RDCTextTypeHeader];
        else
            headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width type:RDCTextTypeHeader];
        
        self.headLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kRDCTextSidePadding, kRDCTextTopPadding, headLineSize.width, headLineSize.height)];
        self.headLineLabel.text = headline;
        self.headLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.headLineLabel.numberOfLines = 0;
        self.headLineLabel.backgroundColor = [UIColor blueColor];
        self.headLineLabel.font = [UIFont fontWithName:kRDCHeaderFontName size:kRDCHeaderFontSize];
        [self addSubview:self.headLineLabel];

        
        
        if(slugline)
        {
            CGSize slugLineSize;
            CGSize imageSize;
            UIImageView *iconView;
            if(imageURL)
                slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width - (kRDCTextSidePadding + kRDCImageWidth)  type:RDCTextTypeSlug];
            else
                slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width type:RDCTextTypeSlug];

            self.slugLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kRDCTextSidePadding, self.headLineLabel.frame.size.height + kRDCInterTextPadding, slugLineSize.width, slugLineSize.height)];
            self.slugLineLabel.text =  slugline;
            self.slugLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.slugLineLabel.numberOfLines = 0;
            self.slugLineLabel.font = [UIFont fontWithName:kRDCSlugFontName size:kRDCSlugFontSize];
            self.slugLineLabel.backgroundColor = [UIColor redColor];
            [self addSubview:self.slugLineLabel];
        }
        
        if(imageURL){
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - (kRDCTextSidePadding + kRDCImageWidth), kRDCTextTopPadding, kRDCImageWidth, kRDCImageHeight)];
            self.imageView.backgroundColor = [UIColor yellowColor];
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
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
            
            CGRect __block positionInSuperview = self.frame;
            self.imageView.frame = CGRectMake(positionInSuperview.origin.x + positionInSuperview.size.width, positionInSuperview.origin.y, positionInSuperview.size.width, positionInSuperview.size.height);
            self.imageView.image = [UIImage imageWithData:downloader.downloadedData];
            [UIView animateWithDuration:0.3 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                self.frame = positionInSuperview;
                self.alpha = 1.0;
            }];
            
        }
    };
    [downloader beginDownloadFromURL:url];
}


- (void)updateWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL andCache:(NSMutableDictionary*)imageCache{
    //Reusing the existing contentView. As a result, existing views may need to be removed if they are no longer used
    if(!slugline && self.slugLineLabel)
    {
        [self.slugLineLabel removeFromSuperview]; //TODO: release?
        self.slugLineLabel = nil;
    }
    
    if(!imageURL && self.imageView)
    {
        [self.imageView removeFromSuperview]; //TODO: release?
        self.imageView = nil;
    }
    
    //Change the size of the labels to match their new content & change content
    CGSize headLineSize;
    if(imageURL)
        headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width - (kRDCTextSidePadding + kRDCImageWidth) type:RDCTextTypeHeader];
    else
        headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width type:RDCTextTypeHeader];
   
    self.headLineLabel.frame = CGRectMake(kRDCTextSidePadding, kRDCTextTopPadding, headLineSize.width, headLineSize.height);
    self.headLineLabel.text = headline;
    
    if(slugline)
    {
        CGSize slugLineSize;
        CGSize imageSize;
        if(imageURL)
            slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width - (kRDCTextSidePadding + kRDCImageWidth)  type:RDCTextTypeSlug];
        else
            slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width type:RDCTextTypeSlug];
        if(!self.slugLineLabel)
        {
            self.slugLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kRDCTextSidePadding, self.headLineLabel.frame.size.height + kRDCInterTextPadding, slugLineSize.width, slugLineSize.height)];
            self.slugLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.slugLineLabel.numberOfLines = 0;
            self.slugLineLabel.font = [UIFont fontWithName:kRDCSlugFontName size:kRDCSlugFontSize];
            self.slugLineLabel.backgroundColor = [UIColor redColor];
            [self addSubview:self.slugLineLabel];

        }
        else{
            self.slugLineLabel.frame = CGRectMake(kRDCTextSidePadding, self.headLineLabel.frame.size.height + kRDCInterTextPadding, slugLineSize.width, slugLineSize.height);
        }
        
        self.slugLineLabel.text =  slugline;
    }
    
    if(imageURL){
        
        if(!self.imageView){
            //imageView doesn't exist, initialize it
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - (kRDCTextSidePadding + kRDCImageWidth), kRDCTextTopPadding, kRDCImageWidth, kRDCImageHeight)];
            self.imageView.backgroundColor = [UIColor yellowColor];
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:self.imageView];

        }
        else{
            //ImageView already exists, reconfigure with new parameters:
            self.imageView.frame = CGRectMake(self.frame.size.width - (kRDCTextSidePadding + kRDCImageWidth), kRDCTextTopPadding, kRDCImageWidth, kRDCImageHeight);
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
    CGSize computedSize = [text sizeWithFont:textFont constrainedToSize:CGSizeMake(contentWidth - (kRDCTextSidePadding * 2), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return computedSize;
}

+ (float) computeRowHeightOfWidth:(float)contentWidth withHeaderText:(NSString*) headerText slugText:(NSString*)slugText displayingImage:(BOOL)imageAvailable{

    /* Caclulates the total height of the row. This is determined by 3 variable factors. The header text length, slug text length (or whether it exists or not)
     and whether an image is available. The image will reduce the width of the slugText and headerText by |kRDCImageWidth| + |kRDCTextPadding|
     Note: It is assumed that a header text is always available.
     */
    
    float headerHeight = [RDCCellContentView computeHeightOfText:headerText forWidth:imageAvailable ? contentWidth - (kRDCImageWidth + kRDCInterTextPadding) : contentWidth type:RDCTextTypeHeader] + kRDCTextTopPadding;
    float slugHeight = 0;
    if(slugText){
        float slugTextWidth = (imageAvailable ? contentWidth - (kRDCImageWidth + kRDCInterTextPadding) : contentWidth) + kRDCTextSidePadding ;
        slugHeight = [RDCCellContentView computeHeightOfText:slugText forWidth:slugTextWidth type:RDCTextTypeSlug] + kRDCInterTextPadding;
    }
    //NSLog(@"Computed row height: %f", headerHeight + slugHeight);
    float rowHeight = headerHeight + slugHeight;
    
    if(imageAvailable && rowHeight < kRDCImageHeight + kRDCTextTopPadding)
        rowHeight = kRDCImageHeight + (kRDCTextTopPadding * 2);
    
    return rowHeight;
}




@end






















