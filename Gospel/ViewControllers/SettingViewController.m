//
//  SettingViewController.m
//  Gospel
//
//  Created by AAA_Develooper on 19/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "SettingViewController.h"
#import "CommonHeader.h"

@interface SettingViewController ()
{
    NSString *colorTheme;
}
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UISwitch *swTrack;
@property (weak, nonatomic) IBOutlet UISwitch *swiClud;

@end

@implementation SettingViewController
@synthesize btnBack, swTrack, swiClud;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    colorTheme = GETVALUE(@"ThemeColor");
    [self drawDefault];
}

- (void)drawDefault
{
    if ([colorTheme isEqualToString:@"blue"])
    {
        [btnBack setImage:[UIImage imageNamed:@"icon_Back.png"] forState:UIControlStateNormal];
        [swTrack setOnTintColor:BLUE_COLOR];
        [swiClud setOnTintColor:BLUE_COLOR];
    }
    else
    {
        [btnBack setImage:[UIImage imageNamed:@"icon_Back_red.png"] forState:UIControlStateNormal];
        [swTrack setOnTintColor:RED_COLOR];
        [swiClud setOnTintColor:RED_COLOR];
    }
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
