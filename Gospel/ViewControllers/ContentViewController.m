//
//  ContentViewController.m
//  Gospel
//
//  Created by AAA_Develooper on 20/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ContentViewController.h"
#import "Preferences.h"

@interface ContentViewController ()
{
	Preferences *prefs;
}



@end

@implementation ContentViewController

@synthesize uv1, tab1, tab2, tab3;
@synthesize contentTextView, titleLabel, titleUnderlineImageView, titleUnderlineLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    prefs = [Preferences sharedInstance];

    
    [[UINavigationBar appearance]  setTintColor:prefs.themeTintColor];

    self.navigationController.navigationBar.barTintColor = prefs.themeNavBarBackgroundColor;
    self.navigationController.navigationBar.tintColor = prefs.themeTintColor;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : prefs.themeTintColor}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = prefs.themeNavBarBackgroundColor;
    
    [titleUnderlineLabel setTextColor:prefs.themeTintColor];
    
    
    uv1.backgroundColor = prefs.themeBackgroundColor;
    contentTextView.backgroundColor = prefs.themeBackgroundColor;
    
    [contentTextView setTextColor:prefs.themeTextColor];
    [titleLabel setTextColor:prefs.themeTextColor];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	
	
    
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
    uv1.hidden = YES;

    
    [tab1 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];
    [tab2 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];
    [tab3 setTitleColor:prefs.themeTintColor forState:UIControlStateNormal];
    
    if (index == 1) {
        uv1.hidden = NO;
        [tab1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else if (index ==2) {
        [tab2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else {
        [tab3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
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
