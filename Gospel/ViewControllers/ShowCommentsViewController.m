//
//  ShowCommentsViewController.m
//  Gospel
//
//  Created by Водолазкий В.В. on 10.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ShowCommentsViewController.h"
#import "DebugPrint.h"

@interface ShowCommentsViewController () {
	Preferences *prefs;
}

@end

@implementation ShowCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	prefs = [Preferences sharedInstance];
}


- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	// setup theme colors
	self.commentTextView.textColor = prefs.themeTextColor;
	self.commentTextView.font = [UIFont systemFontOfSize:prefs.fontSize];
	self.view.backgroundColor = prefs.themeBackgroundColor;
	
	// setup title andd data
	switch (prefs.commentKind) {
		case CommentKindOldTestament:
			self.navigationController.title = RStr(@"Old Testament");
			self.commentTextView.text = prefs.selectedParagraph.translation1;
			break;
		case CommentKindNewTestament:
			self.navigationController.title = RStr(@"New Testament");
			self.commentTextView.text = prefs.selectedParagraph.translation2;
			break;
		case CommentKindPsalm:
			self.navigationController.title = RStr(@"Psalm");
			self.commentTextView.text = prefs.selectedParagraph.translation3;
	}

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
