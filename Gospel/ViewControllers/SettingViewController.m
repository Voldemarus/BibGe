//
//  SettingViewController.m
//  Gospel
//
//  Created by AAA_Develooper on 19/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "SettingViewController.h"
#import "Preferences.h"

@interface SettingViewController ()
{
	Preferences *prefs;
}
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UISwitch *swTrack;
@property (weak, nonatomic) IBOutlet UISwitch *swiClud;

@end

@implementation SettingViewController
@synthesize btnBack, swTrack, swiClud;


- (void)viewDidLoad {
    [super viewDidLoad];
	prefs = [Preferences sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawDefault];
}

- (void)drawDefault
{
	[btnBack setImage:prefs.themeBackButton forState:UIControlStateNormal];
	[swTrack setOnTintColor:prefs.themeTintColor];
	[swiClud setOnTintColor:prefs.themeTintColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
