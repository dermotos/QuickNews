//
//  RDCCellContentView.h
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDCAsyncDownloader.h"
#import <QuartzCore/QuartzCore.h> //For the gradient layer
#import "UIView+RDCGaussianFade.h"
#import <CoreImage/CoreImage.h>
#import "RDCStylizer.h"


//Custom view to display cell content in the news list controller.
@interface RDCCellContentView : UIView

typedef enum {
    RDCTextTypeHeader,
    RDCTextTypeSlug
} RDCTextType;

//Returns the height required to display the specified text.
+ (float) computeHeightOfText:(NSString*) text forWidth:(float)contentWidth type:(RDCTextType)textType;
//Returns the height required to display a row with the specified parameters.
+ (float) computeRowHeightOfWidth:(float)contentWidth withHeaderText:(NSString*) headerText slugText:(NSString*)slugText displayingImage:(BOOL)imageDisplayed;

//Initializes a new RDCCellContentView with the specified parameters
- (id)initWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL andCache:(NSMutableDictionary*)imageCache;
//Reconfigures an existing RDCCellContentView with the specified parameters
- (void)updateWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL andCache:(NSMutableDictionary*)imageCache;

@property (nonatomic, strong) UILabel * headLineLabel;
@property (nonatomic, strong) UILabel * slugLineLabel;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) UIImageView * imageView;

@end
