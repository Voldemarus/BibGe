//
//  FeedbackViewController.m
//  Gospel
//
//  Created by Водолазкий В.В. on 03.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "FeedbackViewController.h"
#import "DAO.h"
#import "Preferences.h"
#import "DebugPrint.h"

@interface FeedbackViewController () {
	DAO *dao;
	Preferences *prefs;
}


@end

@implementation FeedbackViewController

@synthesize deviceInfo = _deviceInfo;
@synthesize initialText = _initialText;

- (id) init
{
	if (self = [super initWithNibName:[[self class] description] bundle:nil]) {
		dao = [DAO sharedInstance];
		prefs = [Preferences sharedInstance];
	}
	return self;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.navigationController.title = RStr(@"Feedback");
	self.view.backgroundColor = prefs.themeBackgroundColor;
	self.sendMessageButton.tintColor = prefs.themeTintColor;
	self.mailAddressField.textColor = prefs.themeTextColor;
	self.mailAddressField.backgroundColor =  (prefs.nightThemeSelected ? [UIColor darkTextColor] : prefs.themeBackgroundColor);
	self.messageTextView.textColor = prefs.themeTextColor;
	self.messageTextView.backgroundColor = (prefs.nightThemeSelected ? [UIColor darkTextColor] : prefs.themeBackgroundColor);
	self.messageTextView.text = self.initialText;
	self.mailLabel.textColor = prefs.themeTextColor;
	self.mwssageLabel.textColor = prefs.themeTextColor;
	
	UIKeyboardAppearance app = (prefs.nightThemeSelected ? UIKeyboardAppearanceAlert : UIKeyboardAppearanceDefault);
	self.mailAddressField.keyboardAppearance = app;
	self.messageTextView.keyboardAppearance = app;
    
    self.messageTextView.layer.borderWidth = 1.0f;
    self.messageTextView.layer.borderColor = [prefs.themeTintColor CGColor];
    self.messageTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);

    
    self.sendMessageButton.layer.borderWidth = 1.0f;
    self.sendMessageButton.layer.borderColor = [prefs.themeTintColor CGColor];


}

- (void) setInitialText:(NSString *)initialText
{
	_initialText = initialText;
	self.messageTextView.text = _initialText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendMessageButtonTapped:(id)sender
{
	NSString *addr = (self.mailAddressField.text ? self.mailAddressField.text : @"");
	if (self.messageTextView.text && self.messageTextView.text.length > 0) {
		[dao sendFeedbackFrom:addr withMessae:self.messageTextView.text
				andDeviceInfo:self.deviceInfo];
	}
	// in any case we return to previous screen
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

@end
