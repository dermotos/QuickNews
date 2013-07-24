//
//  RDCNewsListViewController.m
//  QuickNews
//
//  Created by Dermot on 21/07/13.
//  Copyright (c) 2013 Rocky Desk Creations. All rights reserved.
//

#import "RDCNewsListViewController.h"
#import "RDCAsyncDownloader.h"

@interface RDCNewsListViewController ()
// |articles| is an array of NSDictionaries. Each dictionary represents a summary of a news article.
@property (nonatomic, retain) NSArray *articles;
@end

@implementation RDCNewsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.imageCache = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Loading..."];    
    Class uiRefresh = NSClassFromString(@"UIRefreshControl");
    if(uiRefresh)
    {
        self.refresher = [[[UIRefreshControl alloc] init] autorelease];
        [self.refresher addTarget:self action:@selector(downloadData)
                 forControlEvents:UIControlEventValueChanged];
        self.refresher.tintColor = [RDCStylizer colorFromHexString:@"#48a4d7"];
        self.refreshControl = self.refresher;
    }
    [self downloadData];

}

-(void)downloadData{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    RDCAsyncDownloader *downloader = [[RDCAsyncDownloader alloc] init];
    [downloader setCompletionCallback:^{
#if(DEBUG)
        NSLog(@"Download of initial news JSON completed");
#endif
        
        NSError *error;
        //        For testing:
        //        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"testdata" ofType:@"txt"];
        
        //        NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
        //        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        //
        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:downloader.downloadedData options:NSJSONReadingAllowFragments error:&error];
        if(rootObject)
        {
            NSString *mainTitle = [rootObject objectForKey:@"name"];
            NSArray *articles = [rootObject objectForKey:@"items"];
            self.articles = articles;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationItem setTitle:mainTitle];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self.refresher endRefreshing];
                [self.tableView reloadData];
            });
            
        }
        else
        {
#if(DEBUG)
            NSLog(@"Parsing of the the JSON object tree failed. Error: %@", error.description);
#endif
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self.refresher endRefreshing];
                
            });

        }
        
    }];
    
    [downloader beginDownloadFromURL:[NSURL URLWithString:kRDCNewsURL]];
    [downloader release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Clear the image cache when running low on memory. Images will be re-downloaded as required.
    [self.imageCache removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.articles)
        return self.articles.count;
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *headLine = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"headLine"];
    NSString *slugLine = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"slugLine"];
    BOOL imageExists = ![[[self.articles objectAtIndex:indexPath.row] objectForKey:@"thumbnailImageHref"] isEqual:[NSNull null]];
    //Turn NSNulls into nil for consistency
    slugLine = [slugLine isKindOfClass:[NSNull class]] ? nil : slugLine;
    
   // NSLog(@"Row %d image: %@ - %i",indexPath.row, [[self.articles objectAtIndex:indexPath.row] objectForKey:@"thumbnailImageHref"], imageExists);
    
    float height = [RDCCellContentView computeRowHeightOfWidth:tableView.frame.size.width withHeaderText:headLine slugText:slugLine displayingImage:imageExists];
    return height;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *headLine = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"headLine"];
    NSString *slugLine = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"slugLine"];
    NSString *imagePath = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"thumbnailImageHref"];
    slugLine = [slugLine isKindOfClass:[NSNull class]] ? nil : slugLine;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    RDCCellContentView *contentView;

    if(cell && cell.tag == self.tableView.frame.size.width)
    {
        //Cell already exists, just change the values of it's fields
         contentView = [cell.contentView.subviews objectAtIndex:0];
        [contentView updateWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [self tableView:self.tableView heightForRowAtIndexPath:indexPath])
                            headLine: headLine
                            slugLine: slugLine
                         andImageURL: [imagePath isKindOfClass:[NSNull class]] ? nil : [NSURL URLWithString:imagePath] andCache:self.imageCache];

    }
    else
    {
        //Creating a new cell
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.tag = self.tableView.frame.size.width;
        contentView = [[[RDCCellContentView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [self tableView:self.tableView heightForRowAtIndexPath:indexPath])
                                                       headLine: headLine
                                                       slugLine: slugLine
                                                    andImageURL: [imagePath isKindOfClass:[NSNull class]] ? nil : [NSURL URLWithString:imagePath] andCache:self.imageCache] autorelease];
       [cell.contentView addSubview:contentView];
    }
    
       
    CAGradientLayer *backgroundGradient = [CAGradientLayer layer];
    cell.backgroundView = [[[UIView alloc] initWithFrame:contentView.frame] autorelease];
    backgroundGradient.frame = cell.backgroundView.bounds;
    backgroundGradient.colors = [NSArray arrayWithObjects: (id)[RDCStylizer colorFromHexString:kRDCBackgroundGradientTopColor].CGColor,
                                 [RDCStylizer colorFromHexString:kRDCBackgroundGradientBottomColor].CGColor, nil];
    [cell.backgroundView.layer addSublayer:backgroundGradient];

    return cell;
}

//for iOS5 rotating
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    [self.tableView reloadData];
    return YES;
}
//for iOS6+ rotating
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"webHref"];
    if(kRDCLoadMobileStory)
    {
        //Replaces the desktop version of the site with the mobile version. Note that when sharing, the tinyURL is used, which
        //will continue to point to the correct site version for the recipient.
        urlString = [urlString stringByReplacingOccurrencesOfString:@"http://www.smh.com.au/" withString:@"http://m.smh.com.au/"];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"http://news.smh.com.au/" withString:@"http://m.smh.com.au/"];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURL *tinyUrl = [NSURL URLWithString: [[self.articles objectAtIndex:indexPath.row] objectForKey:@"tinyUrl"]];
    NSString *headLine = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"headLine"];
    
    RDCStoryViewController *storyController = [[[RDCStoryViewController alloc] initWithURL:url tinyUrl:tinyUrl headLine:headLine] autorelease];
    [self.navigationController pushViewController:storyController animated:YES];
}




@end

















