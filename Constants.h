//
//  Constants.h
//  QuickNews
//
//  Created by Dermot on 22/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//Depending on requirements, these could be stored in a plist or if they needed to be changed by the user, in NSDefaults
#define kRDCNewsURL @"http://mobilatr.mob.f2.com.au/services/views/9.json"
#define kRDCLoadMobileStory YES
#define kRDCHeaderFontName @"Helvetica"
#define kRDCHeaderFontSize 14
#define kRDCHeaderFontColor [UIColor blueColor]
#define kRDCSlugFontName @"Helvetica"
#define kRDCSlugFontSize 10
#define kRDCSlugFontColor [UIColor blackColor]
#define kRDCImageWidth 160
#define kRDCTextTopPadding 2
#define kRDCTextBottomPadding 2
#define kRDCTextSidePadding 2
#define kRDCInterTextPadding 2
#define kRDCImageHeight 60
#define kRDCImageWidth  90



@end
