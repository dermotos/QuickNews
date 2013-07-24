//
//  RDCAppDelegate.h
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDCNewsListViewController.h"
#import "RDCStylizer.h"

@class RDCViewController;

@interface RDCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) RDCNewsListViewController *listController;

@end
