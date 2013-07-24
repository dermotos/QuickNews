//
//  RDCNewsListViewController.h
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDCCellContentView.h"
#import "RDCStoryViewController.h"
#import "RDCStylizer.h"
#import "UIView+RDCGaussianFade.h"

@interface RDCNewsListViewController : UITableViewController

-(void)downloadData;

@property (nonatomic,retain) NSMutableDictionary *imageCache;
@property (nonatomic,retain) UIRefreshControl *refresher;


@end
