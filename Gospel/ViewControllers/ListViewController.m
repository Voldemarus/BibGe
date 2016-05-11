//
//  ListViewController.m
//  Gospel
//
//  Created by AAA_Develooper on 19/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "Preferences.h"
#import "Dao.h"
#import "ContentViewController.h"
#import "DebugPrint.h"

@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
	Preferences *prefs;
    BOOL bTheme;
	NSFetchedResultsController *fetchController;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgSidebar;
@property (weak, nonatomic) IBOutlet UITableView *tvList;

@end

@implementation ListViewController
@synthesize m_imgSidebar, tvList;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	prefs = [Preferences sharedInstance];
	fetchController =[[DAO sharedInstance] fetchedController];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(updateTable:) name:VVVpersistentStoreChanged object:nil];
	[nc addObserver:self selector:@selector(freezeInterface:) name:VVVcloudSyncInProgress  object:nil];
	
	self.waitingController = [[WaitingViewController alloc] init];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
    [self drawDefault];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawDefault
{
	m_imgSidebar.image = prefs.themeSideBar;
	
    [tvList reloadData];
}


#pragma mark - Selectors

- (void) updateTable:(NSNotification *) note
{
	NSError *error =nil;
	[fetchController performFetch:&error];
	if (error) {
		DLog(@"error  = %@", [error localizedDescription]);
	} else {
		[tvList reloadData];
	}
	[self.waitingController hideFromScreen];
	[self.waitingController.view removeFromSuperview];
}

- (void) freezeInterface:(NSNotification *) note
{
	[self.view addSubview:self.waitingController.view];
	[self.waitingController showOnScreen];
}


#pragma mark - Actions

- (IBAction)processClickTheme:(id)sender
{
	if (!self.tuneController) {
		self.tuneController = [[ThemeTuneViewController alloc] init];
	}
    
    [self.navigationController pushViewController:self.tuneController animated:YES];
	//[self presentViewController:self.tuneController animated:YES completion:nil];
}

- (IBAction)processClickSetting:(id)sender {
    //[self performSegueWithIdentifier:@"goSetting" sender:nil];
}

#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fetchController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listcell";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    if (!cell)
        cell = [[ListTableViewCell alloc] init];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = prefs.themeCellBackgroundColor;
	cell.txtTitle.textColor = prefs.themeTextColor;
	cell.detailTextLabel.textColor = prefs.themeDetailColor;
	
	Paragraph *par = [[fetchController fetchedObjects] objectAtIndex:indexPath.row];
	// Numeration from the oldest record
	NSInteger counter = [fetchController fetchedObjects].count - indexPath.row;
	
	// show percent of viewed text
	cell.progressCircle.progressValue = par.viewed.floatValue; // (indexPath.row % 10) / 10.0;
    cell.progressCircle.color = prefs.themeProgressFiller;
	
	static NSDateFormatter *df = nil;
	if (!df) {
		df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"dd MMM YYYY"];
	}
	NSString *curFormattedDate = [df stringFromDate:par.dateCreated];
	
	cell.txtDetail.text = [NSString stringWithFormat:@"%@   %ld", curFormattedDate, (long)counter];
	cell.txtTitle.text = par.title;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        ContentViewController *cvc = [segue destinationViewController];
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"indexpath: %@", indexPath);
        Paragraph *par = [[fetchController fetchedObjects] objectAtIndex:indexPath.row];

        [cvc setPar:par];
        [cvc setIndexPath:indexPath];
    }
    
}


@end
