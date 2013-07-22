//
//  RDCCellContentView.m
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCCellContentView.h"

@implementation RDCCellContentView

- (id)initWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL
{
    self = [super initWithFrame:frame];
    if (self) {
        /* There are a total of 3 different possible view configurations. Each of these view configurations must be possible with different widths 
         (portrait, landscape, iPhone 5 landscape).
         
         Config0: Header text, no content, no image
         Config1: Header text, content text, no image
         Config2: Header text, content text, image text.
         
         In all cases, a header text is visible. In the other two cases, the content text is visible. If an image is available, the context
         text will be narrower to allow for space for the image. Note that images can come back from the service in different sizes. For 
         visual consistency, all images will be resized to the same size.
         
         */
        
        //The header should always exist
        CGSize headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width type:RDCTextTypeHeader];
        
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
//            if(imageURL){
//                //Slugtext and an image are available
//                slugLineSize = [slugline sizeWithFont:[UIFont fontWithName:kRDCSlugFontName size:kRDCSlugFontSize]
//                                    constrainedToSize:CGSizeMake(self.frame.size.width - (kRDCTextPadding *2) - (kRDCTextPadding + kRDCImageWidth), CGFLOAT_MAX)
//                                        lineBreakMode:NSLineBreakByWordWrapping];
//            }
//            else{
                //Only the slugtext is available
            slugLineSize = [RDCCellContentView computeSizeOfText:slugline forWidth:self.frame.size.width type:RDCTextTypeSlug];

           // }
            //NSLog(@"Slugline width: %f",slugLineSize.width);
            self.slugLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kRDCTextSidePadding, self.headLineLabel.frame.size.height + kRDCInterTextPadding, slugLineSize.width, slugLineSize.height)];
            self.slugLineLabel.text =  slugline;
            self.slugLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.slugLineLabel.numberOfLines = 0;
            self.slugLineLabel.font = [UIFont fontWithName:kRDCSlugFontName size:kRDCSlugFontSize];
            self.slugLineLabel.backgroundColor = [UIColor redColor];
            [self addSubview:self.slugLineLabel];

        
        
        }
    }
    return self;
}

- (void)updateWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL{
    //Reusing the existing contentView. As a result, existing views may need to be removed if they are no longer used
    if(!slugline && self.slugLineLabel)
        [self.slugLineLabel removeFromSuperview]; //TODO: release?
    
    if(!imageURL && self.imageView)
        [self.imageView removeFromSuperview]; //TODO: release?
    
    //Change the size of the labels to match their new content & change content
    CGSize headLineSize = [RDCCellContentView computeSizeOfText:headline forWidth:self.frame.size.width type:RDCTextTypeHeader];
    self.headLineLabel.frame = CGRectMake(kRDCTextSidePadding, kRDCTextTopPadding, headLineSize.width, headLineSize.height);
    self.headLineLabel.text = headline;
    
    if(slugline)
    {
        CGSize slugLineSize;
        CGSize imageSize;
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
        else
        {
            self.slugLineLabel.frame = CGRectMake(kRDCTextSidePadding, self.headLineLabel.frame.size.height + kRDCInterTextPadding, slugLineSize.width, slugLineSize.height);
        }
        
        self.slugLineLabel.text =  slugline;
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

+ (float) computeRowHeightOfWidth:(float)contentWidth withHeaderText:(NSString*) headerText slugText:(NSString*)slugText displayingImage:(BOOL)imageDisplayed{

    /* Caclulates the total height of the row. This is determined by 3 variable factors. The header text length, slug text length (or whether it exists or not)
     and whether an image is available. The image will reduce the width of the |slugText| by |kRDCImageWidth| + |kRDCTextPadding|
     Note: It is assumed that a header text is always available.
     */
    
    float headerHeight = [RDCCellContentView computeHeightOfText:headerText forWidth:contentWidth type:RDCTextTypeHeader] + kRDCTextTopPadding;
    float slugHeight = 0;
    if(slugText){
        float slugTextWidth = imageDisplayed ? contentWidth - (kRDCImageWidth) : contentWidth;
        slugHeight = [RDCCellContentView computeHeightOfText:slugText forWidth:contentWidth type:RDCTextTypeSlug] + kRDCInterTextPadding;
    }
    //NSLog(@"Computed row height: %f", headerHeight + slugHeight);
    return headerHeight + slugHeight;
}




@end






















