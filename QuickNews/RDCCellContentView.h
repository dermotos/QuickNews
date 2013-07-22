//
//  RDCCellContentView.h
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RDCCellContentView : UIView

typedef enum {
    RDCTextTypeHeader,
    RDCTextTypeSlug
} RDCTextType;

+ (float) computeHeightOfText:(NSString*) text forWidth:(float)contentWidth type:(RDCTextType)textType;
+ (float) computeRowHeightOfWidth:(float)contentWidth withHeaderText:(NSString*) headerText slugText:(NSString*)slugText displayingImage:(BOOL)imageDisplayed;

- (id)initWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL;
- (void)updateWithFrame:(CGRect)frame headLine: (NSString*)headline slugLine:(NSString*)slugline andImageURL:(NSURL*)imageURL;

@property (nonatomic, retain) UILabel * headLineLabel;
@property (nonatomic, retain) UILabel * slugLineLabel;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) UIImageView * imageView;

@end
