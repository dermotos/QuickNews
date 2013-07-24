//
//  Constants.h
//  QuickNews
//
//  Created by Dermot on 22/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//Depending on requirements, these could be stored in a plist or if they needed to be changed by the user, in NSUserDefaults

#define kRDCNewsURL @"http://mobilatr.mob.f2.com.au/services/views/9.json"
#define kRDCLoadMobileStory YES

#define kRDCTitleFontName @"Roboto-Light"
#define kRDCTitleFontSize 21

#define kRDCHeaderFontName @"Roboto-Light"
#define kRDCHeaderFontSize 16
#define kRDCHeaderFontColor @"#2b437e"

#define kRDCSlugFontName @"Roboto-Light"
#define kRDCSlugFontSize 10
#define kRDCSlugFontColor @"#545454"

#define kRDCBackgroundGradientTopColor @"#fefefe"
#define kRDCBackgroundGradientBottomColor @"#ebebeb"

#define kRDCPadding 3
#define kRDCRowPadding 4
#define kRDCImageHeight 60
#define kRDCImageWidth  90



@end
