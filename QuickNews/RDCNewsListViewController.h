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

#define padding 3
#define imageWidth 100

@interface RDCNewsListViewController : UITableViewController

@property (nonatomic,retain) NSMutableDictionary *imageCache;

@end
