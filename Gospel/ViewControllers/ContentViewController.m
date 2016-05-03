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

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;

@property (weak, nonatomic) IBOutlet UIView *uv1;
@property (weak, nonatomic) IBOutlet UILabel *m_txtTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLine;
@property (weak, nonatomic) IBOutlet UITextView *m_txtContent;


@property (weak, nonatomic) IBOutlet UIView *uv2;
@property (weak, nonatomic) IBOutlet UIView *uv3;

@property (weak, nonatomic) IBOutlet UIButton *tab1;
@property (weak, nonatomic) IBOutlet UIButton *tab2;
@property (weak, nonatomic) IBOutlet UIButton *tab3;

@end

@implementation ContentViewController
@synthesize btnBack, lblTitle, btnUpload;
@synthesize uv1, m_txtTitle, m_lblLine, m_txtContent;
@synthesize uv2, uv3;
@synthesize tab1, tab2, tab3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	
	[btnBack setImage:prefs.themeBackButton forState:UIControlStateNormal];
	[btnUpload setImage:prefs.themeUploadButton forState:UIControlStateNormal];
	
    [lblTitle setTextColor:prefs.themeTextColor];
    
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
    uv2.hidden = YES;
    uv3.hidden = YES;
    
    [tab1 setTitleColor:prefs.themeTextColor forState:UIControlStateNormal];
    [tab2 setTitleColor:prefs.themeTextColor forState:UIControlStateNormal];
    [tab3 setTitleColor:prefs.themeTextColor forState:UIControlStateNormal];
    
    if (index == 1) {
        uv1.hidden = NO;
        [tab1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [m_lblLine setBackgroundColor:prefs.themeTextColor];
    }
    else if (index ==2) {
        uv2.hidden = NO;
        [tab2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else {
        uv3.hidden = NO;
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
