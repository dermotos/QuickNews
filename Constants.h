//
//  Constants.h
//  QuickNews
//
//  Created by Dermot on 22/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//Depending on requirements, these could be stored in a plist or if they needed to be changed by the user, in NSDefaults
#define kRDCNewsURL @"http://mobilatr.mob.f2.com.au/services/views/9.json"
#define kRDCLoadMobileStory YES
#define kRDCHeaderFontName @"Helvetica"
#define kRDCHeaderFontSize 13
#define kRDCHeaderFontColor @"#2b437e"
#define kRDCSlugFontName @"Helvetica"
#define kRDCSlugFontSize 10
#define kRDCSlugFontColor @"#545454"
#define kRDCBackgroundGradientTopColor @"#fefefe"
#define kRDCBackgroundGradientBottomColor @"#ebebeb"
#define kRDCImageWidth 160
#define kRDCPadding 3
#define kRDCRowPadding 4
#define kRDCImageHeight 60
#define kRDCImageWidth  90



@end
