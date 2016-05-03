//
//  ListViewController.m
//  Gospel
//
//  Created by AAA_Develooper on 19/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ListViewController.h"
#import "CommonHeader.h"

@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *colorTheme;
    BOOL bTheme;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgSidebar;
@property (weak, nonatomic) IBOutlet UITableView *tvList;

@end

@implementation ListViewController
@synthesize m_imgSidebar, tvList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([colorTheme isEqualToString:@"blue"])
        bTheme = NO;
    else
        bTheme = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    colorTheme = GETVALUE(@"ThemeColor");
    [self drawDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawDefault
{
    if ([colorTheme isEqualToString:@"blue"])
        [m_imgSidebar setImage:[UIImage imageNamed:@"img_sidebar_blue.png"]];
    else
        [m_imgSidebar setImage:[UIImage imageNamed:@"img_sidebar.png"]];
    
    [tvList reloadData];
}

- (IBAction)processClickTheme:(id)sender
{
    bTheme = !bTheme;
    
    if (bTheme) {
        UPDATE_DEFAULTS(@"ThemeColor", @"red");
    }
    else
        UPDATE_DEFAULTS(@"ThemeColor", @"blue");
    [self viewWillAppear:YES];
}

- (IBAction)processClickSetting:(id)sender {
    [self performSegueWithIdentifier:@"goSetting" sender:nil];
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
    
    if ([colorTheme isEqualToString:@"blue"])
        [cell.imgCircle setImage:[UIImage imageNamed:@"icon_circle_blue.png"]];
    else
        [cell.imgCircle setImage:[UIImage imageNamed:@"icon_circle_red.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
