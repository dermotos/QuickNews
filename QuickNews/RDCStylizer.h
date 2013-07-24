//
//  RDCStylizer.h
//  QuickNews
//
//  Created by Dermot on 24/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RDCStylizer : NSObject

//Class method to apply styles used throughout the app. Specifically, it configures the UIAppearance Proxy to display the UINavigationBar in a styled fashion
+(void)applyGlobalStyles;
//Helper method to return a UIColor from a standard colour hex string
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
