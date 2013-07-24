//
//  RDCStylizer.m
//  QuickNews
//
//  Created by Dermot on 24/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCStylizer.h"

@implementation RDCStylizer

+(void)applyGlobalStyles{
    UIImage *portraitNavigationImage = [[UIImage imageNamed:@"nav-bar.png"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIImage *landscapeNavigationImage = [[UIImage imageNamed:@"nav-bar-landscape.png"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    [[UINavigationBar appearance] setBackgroundImage:portraitNavigationImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:landscapeNavigationImage forBarMetrics:UIBarMetricsLandscapePhone];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:kRDCTitleFontName size:kRDCTitleFontSize],
      UITextAttributeFont,
      nil]];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
