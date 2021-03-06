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
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMMM"];
    
    NSMutableString *title = [[NSMutableString alloc] initWithString:[df stringFromDate:prefs.selectedParagraph.dateCreated]];
    [title appendString:@" | "];

    switch (prefs.commentKind) {
        case CommentKindOldTestament:
            [title appendString:RStr(@"Old Testament")];
           break;
        case CommentKindNewTestament:
            [title appendString:RStr(@"New Testament")];
           break;
        case CommentKindPsalm:
            [title appendString:RStr(@"Psalm")];
   }
    self.navigationItem.title = title;
}


- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	// setup theme colors
	self.commentTextView.textColor = prefs.themeTextColor;
	self.commentTextView.font = [UIFont systemFontOfSize:prefs.fontSize];
	self.view.backgroundColor = prefs.themeBackgroundColor;
    [self.commentTextView setBackgroundColor:prefs.themeBackgroundColor];
	
	NSAttributedString *translationData = nil;
	// setup title andd data
	CGFloat offset = 0;
	switch (prefs.commentKind) {
		case CommentKindOldTestament:
			self.navigationController.title = RStr(@"Old Testament");
			translationData = prefs.selectedParagraph.translation1;
		break;
		case CommentKindNewTestament:
			self.navigationController.title = RStr(@"New Testament");
			translationData = prefs.selectedParagraph.translation2;
			break;
		case CommentKindPsalm:
			self.navigationController.title = RStr(@"Psalm");
			translationData = prefs.selectedParagraph.translation3;
	}

	NSMutableAttributedString *attrString = [translationData mutableCopy];
	
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
	self.commentTextView.attributedText = attrString;
	self.commentTextView.textColor = prefs.themeTextColor;
	self.commentTextView.alpha = 0.0;

}

- (void) viewDidAppear:(BOOL)animated
{
	CGFloat offset = 0;
	switch (prefs.commentKind) {
		case CommentKindOldTestament:
			offset = prefs.selectedParagraph.translation1Offset.floatValue;
			break;
		case CommentKindNewTestament:
			offset = prefs.selectedParagraph.translation2Offset.floatValue;
			break;
		case CommentKindPsalm:
			offset = prefs.selectedParagraph.translation3Offset.floatValue;
			break;
	}
	CGPoint oft = CGPointMake(0.0, offset);
	[self.commentTextView setContentOffset:oft animated:NO];
	self.commentTextView.alpha = 1.0;
}

- (void) viewWillDisappear:(BOOL)animated
{
	CGFloat offset = self.commentTextView.contentOffset.y;
	switch (prefs.commentKind) {
		case CommentKindOldTestament:
			prefs.selectedParagraph.translation1Offset = @(offset); break;
		case CommentKindNewTestament:
			prefs.selectedParagraph.translation2Offset = @(offset); break;
		case CommentKindPsalm:
			prefs.selectedParagraph.translation3Offset = @(offset); break;
	}
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
