//
//  RDCCellContentView.h
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDCAsyncDownloader.h"



@interface RDCCellContentView : UIView

typedef enum {
    RDCTextTypeHeader,
    RDCTextTypeSlug
} RDCTextType;

+ (float) computeHeightOfText:(NSString*) text forWidth:(float)contentWidth type:(RDCTextType)textType;
+ (float) computeRowHeightOfWidth:(float)contentWidth withHeaderText:(NSString*) headerText slugText:(NSString*)slugText displayingImage:(BOOL)imageDisplayed;

- (id)initWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL andCache:(NSMutableDictionary*)imageCache;
- (void)updateWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL andCache:(NSMutableDictionary*)imageCache;

@property (nonatomic, strong) UILabel * headLineLabel;
@property (nonatomic, strong) UILabel * slugLineLabel;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) UIImageView * imageView;

@end
