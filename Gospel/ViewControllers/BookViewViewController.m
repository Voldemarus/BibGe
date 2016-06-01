//
//  BookViewViewController.m
//  Gospel
//
//  Created by Водолазкий В.В. on 01.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "BookViewViewController.h"

@interface BookViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BookViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	NSBundle *mb = [NSBundle mainBundle];
	NSURL *url = [mb URLForResource:@"!stIconDoc" withExtension:@"pdf"];
	if (url) {
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
		[self.webView loadRequest:request];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
