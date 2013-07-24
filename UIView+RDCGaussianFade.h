//
//  UIView+RDCGaussianFade.h
//  RDCGaussianBlur
//
//  Created by Dermot on 6/18/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//  Please my readme.md @ https://github.com/dermotos/RDCGaussianFade for a full description

#import <UIKit/UIKit.h>

@interface UIView (RDCGaussianFade)

-(void)fadeIn:(float)duration;
-(void)fadeIn:(float)duration withCompletion:(void (^)()) block;
-(void)fadeIn:(float)duration withDelay:(float)delay andCompletion:(void (^)()) block;

-(void)fadeOut:(float)duration;
-(void)fadeOut:(float)duration withCompletion:(void (^)()) block;
-(void)fadeOut:(float)duration withDelay:(float)delay andCompletion:(void (^)()) block;

@end
