//
//  ContentViewController.m
//  Gospel
//
//  Created by AAA_Develooper on 20/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ContentViewController.h"
#import "Preferences.h"
#import "AppDelegate.h"
#import "Dao.h"

@interface ContentViewController ()
{
	Preferences *prefs;
    NSFetchedResultsController *fetchController;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ContentViewController

@synthesize tab1, tab2, tab3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
    prefs = [Preferences sharedInstance];
    fetchController =[[DAO sharedInstance] fetchedController];

    
    [[UINavigationBar appearance]  setTintColor:prefs.themeTintColor];

    self.navigationController.navigationBar.barTintColor = prefs.themeNavBarBackgroundColor;
    self.navigationController.navigationBar.tintColor = prefs.themeTintColor;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : prefs.themeTintColor}];
    self.navigationController.navigationBar.translucent = NO;
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
        
        [titleLabel setFont:[UIFont systemFontOfSize:prefs.fontSize + 4.0f]];
        [titleLabel setText:self.par.title];
    }
    if (indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UnderlineCell" forIndexPath:indexPath];
        UILabel *underlineLabel = (UILabel*)[cell viewWithTag:201];
        
        [underlineLabel setTextColor:prefs.themeTintColor];

    }
    if (indexPath.row == 2)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        UILabel *contentLabel = (UILabel*)[cell viewWithTag:301];
        
        //article text
        NSString *text = self.par.text;
        
        [contentLabel setFont:[UIFont systemFontOfSize:prefs.fontSize]];
        [contentLabel setText:text];
    }


    return cell;
}

-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    if (indexPath.row == 0)
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:prefs.fontSize + 4.0f]};
        CGRect rect = [self.par.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:attributes
                                                         context:nil];
        return rect.size.height + 50;
    }
    if (indexPath.row == 1)
    {
        return 44;
    }
    if (indexPath.row == 2)
    {
        // article text
        NSString *text = self.par.text;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:prefs.fontSize]};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [text boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributes
                                                      context:nil];
        //contentLabel.frame = rect;
        //cell.frame = rect;
        
        return rect.size.height;
    }
    return 44;
}


#pragma mark - Layout manager delegate

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
	return prefs.lineHeight;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	
	self.view.backgroundColor = prefs.themeNavBarBackgroundColor;
	
//	[titleUnderlineLabel setTextColor:prefs.themeTintColor];
//	
//	uv1.backgroundColor = prefs.themeBackgroundColor;
//	contentTextView.backgroundColor = prefs.themeBackgroundColor;
//	
//	[contentTextView setTextColor:prefs.themeTextColor];
//	[titleLabel setTextColor:prefs.themeTextColor];
//	
//	titleLabel.font = [UIFont systemFontOfSize:(prefs.fontSize+4)];
//	contentTextView.font = [UIFont systemFontOfSize:prefs.fontSize];
//	
	
    [self clickTab:1];
}


- (IBAction)processBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)processClickTab1:(id)sender {
    [self clickTab:1];
}

- (IBAction)processClickTab2:(id)sender {
    [self clickTab:2];
}

- (IBAction)processClickTab3:(id)sender {
    [self clickTab:3];
}

- (void)clickTab:(int)index
{
    //uv1.hidden = YES;

    
    [tab1 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];
    [tab2 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];
    [tab3 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];
    
    if (index == 1) {
        //uv1.hidden = NO;
        [tab1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else if (index ==2) {
        [tab2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else {
        [tab3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 

- (IBAction)openShareActivirtform:(id)sender
{
//	NSString *textToShare = self.titleLabel.text;
//	// TMP - while database is not created
//	NSURL *myWebsite = [NSURL URLWithString:@"http://armada.cardarmy.ru"];
// 
//	NSArray *objectsToShare = @[textToShare, myWebsite];
// 
//	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
// 
//	NSArray *excludeActivities = @[UIActivityTypeAirDrop,
//								   UIActivityTypePrint,
//								   UIActivityTypeAssignToContact,
//								   UIActivityTypeSaveToCameraRoll,
//								   UIActivityTypeAddToReadingList,
//								   UIActivityTypePostToFlickr,
//								   UIActivityTypePostToVimeo];
// 
//	activityVC.excludedActivityTypes = excludeActivities;
// 
//	 [self presentViewController:activityVC animated:YES completion:nil];
}




@end
