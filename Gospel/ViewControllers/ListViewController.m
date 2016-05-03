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

@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
	Preferences *prefs;
    BOOL bTheme;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgSidebar;
@property (weak, nonatomic) IBOutlet UITableView *tvList;

@end

@implementation ListViewController
@synthesize m_imgSidebar, tvList;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	prefs = [Preferences sharedInstance];
 
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

- (IBAction)processClickTheme:(id)sender
{
	[prefs selectNextTheme];
	[self drawDefault];
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
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listcell";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    if (!cell)
        cell = [[ListTableViewCell alloc] init];
	
	cell.imgCircle.image = prefs.themeCircle;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = prefs.themeCellBackgroundColor;
	cell.txtTitle.textColor = prefs.themeTextColor;
	cell.detailTextLabel.textColor = prefs.themeDetailColor;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goShow" sender:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
