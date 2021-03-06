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
#import "DebugPrint.h"

@interface ContentViewController ()
{
	Preferences *prefs;
    NSFetchedResultsController *fetchController;
	NSMutableAttributedString *attrString;
	CGRect atrrStringRect;
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

	[tab1 setTitle:RStr(@"Old Testament") forState:UIControlStateNormal];
	[tab2 setTitle:RStr(@"New Testament") forState:UIControlStateNormal];
	[tab3 setTitle:RStr(@"Psalm") forState:UIControlStateNormal];
	
    prefs = [Preferences sharedInstance];
    fetchController =[[DAO sharedInstance] fetchedController];

}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[UINavigationBar appearance]  setTintColor:prefs.themeTintColor];
	
	self.navigationController.navigationBar.barTintColor = prefs.themeNavBarBackgroundColor;
	self.navigationController.navigationBar.tintColor = prefs.themeTintColor;
	self.navigationController.navigationBar.barStyle = (prefs.nightThemeSelected ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : prefs.themeTintColor}];
	self.navigationController.navigationBar.translucent = NO;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dd MMMM"];
	self.navigationItem.title = [df stringFromDate:self.par.dateCreated];
	
    [self.navigationItem.rightBarButtonItem setTintColor:prefs.themeTintColor];
    
	self.shareButton.tintColor = prefs.themeTintColor;
	self.backButton.image = prefs.themeBackButton;
	self.navigationController.title = self.par.title;

	self.view.backgroundColor = prefs.themeNavBarBackgroundColor;
	
    [tab1 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];
    [tab2 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];
    [tab3 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];

	attrString = [self.par.text mutableCopy];
	NSRange attrLength = NSMakeRange(0, attrString.length);
	[attrString enumerateAttribute:NSFontAttributeName
						   inRange:attrLength options:0
						usingBlock:^(id value, NSRange range, BOOL *stop) {
		if (value) {
			UIFont *oldFont = (UIFont *)value;
			UIFont *newFont = [oldFont fontWithSize:prefs.fontSize];
			[attrString removeAttribute:NSFontAttributeName range:range];
			[attrString addAttribute:NSFontAttributeName value:newFont range:range];
		}
	}];
	[attrString enumerateAttribute:NSParagraphStyleAttributeName
						   inRange:attrLength options:0
						usingBlock:^(id value, NSRange range, BOOL *stop) {
		if (value) {
			NSMutableParagraphStyle *style = [value mutableCopy];
			[style setLineSpacing:prefs.lineHeight];
			[attrString removeAttribute:NSParagraphStyleAttributeName range:range];
			[attrString addAttribute:NSParagraphStyleAttributeName value:style range:range];
		}
	}];
	atrrStringRect =
	[attrString boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width, CGFLOAT_MAX)
							 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
							 context:nil];
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
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
		
		titleLabel.textColor = prefs.themeTextColor;
        [titleLabel setFont:[UIFont systemFontOfSize:prefs.fontSize + 4.0f]];
        [titleLabel setText:self.par.title];
		[titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    if (indexPath.row == 1)  {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UnderlineCell" forIndexPath:indexPath];
        UILabel *underlineLabel = (UILabel*)[cell viewWithTag:201];
        
        [underlineLabel setTextColor:prefs.themeTintColor];

    }
    if (indexPath.row == 2) {
        
       cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        UITextView *contentLabel = (UITextView*)[cell viewWithTag:301];
        
        //article text
		contentLabel.contentSize = atrrStringRect.size;
		[contentLabel updateConstraints];
		CGRect frame = cell.frame;
		frame.size = attrString.size;
		cell.frame = frame;
		[cell updateConstraints];
        contentLabel.attributedText = attrString;
		contentLabel.textColor = prefs.themeTextColor;
		contentLabel.backgroundColor = [UIColor clearColor];
		contentLabel.delegate = self;
		//
		// move to proper offset
		//
		CGFloat offset = self.par.textOffset.floatValue;
		CGPoint oft = CGPointMake(0.0, offset);
		[contentLabel setContentOffset: oft animated:NO];
		DLog(@"content.offset = %.0f", contentLabel.contentOffset.y);
		
    }
	cell.contentView.backgroundColor = prefs.themeBackgroundColor;

    return cell;
}

-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    if (indexPath.row == 0) {
		UIFont *titleFont = [UIFont systemFontOfSize:prefs.fontSize + 4.0f];
        NSDictionary *attributes = @{NSFontAttributeName: titleFont};
        CGRect rect = [self.par.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:attributes
                                                         context:nil];
        return rect.size.height + 50;
    }
    if (indexPath.row == 1) {
        return 44;
    }
    if (indexPath.row == 2) {
        // article text
		
        return atrrStringRect.size.height;
    }
    return 44;
}


#pragma mark - Layout manager delegate

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
	return prefs.lineHeight;
}

#pragma mark - UIScrollViewDelegate - 

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat currentOffset = scrollView.contentOffset.y;
	// memorize current offset
	self.par.textOffset = @(currentOffset);
	DLog(@"offset = %@", self.par.textOffset);
	if (prefs.trackReading) {
		CGFloat maxOffset  = scrollView.contentSize.height - scrollView.frame.size.height;
		// If  the whole paragraph fits on one page without scroll mark it as read
		CGFloat delta  = (maxOffset > 0 ? currentOffset / maxOffset : 1.0);
		
		CGFloat oldOffset = self.par.viewed.doubleValue;
		if (delta > oldOffset) {
			// It is obvious that user doesn't forget reading while track it back
			self.par.viewed = @(delta);
		}
	}
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)processBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)processClickTab1:(id)sender {
    [self clickTab:CommentKindOldTestament];
}

- (IBAction)processClickTab2:(id)sender {
    [self clickTab:CommentKindNewTestament];
}

- (IBAction)processClickTab3:(id)sender {
    [self clickTab:CommentKindPsalm];
}

- (void)clickTab:(KindOfComment)index
{
	prefs.selectedParagraph = self.par;
	prefs.commentKind = index;
}

#pragma mark - 

- (IBAction)openShareActivirtform:(id)sender
{
	NSString *textToShare = self.par.title;
	// TMP - while database is not created
	NSURL *myWebsite = [NSURL URLWithString:self.par.link];
 
	NSArray *objectsToShare = @[textToShare, myWebsite];
 
	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
 
	NSArray *excludeActivities = @[UIActivityTypeAirDrop,
								   UIActivityTypePrint,
								   UIActivityTypeAssignToContact,
								   UIActivityTypeSaveToCameraRoll,
								   UIActivityTypeAddToReadingList,
								   UIActivityTypePostToFlickr,
								   UIActivityTypePostToVimeo];
 
	activityVC.excludedActivityTypes = excludeActivities;
 
	 [self presentViewController:activityVC animated:YES completion:nil];
}


- (IBAction)backButtonTapped:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
