//
//  WaitingViewController.m
//  Gospel
//
//  Created by Водолазкий В.В. on 11.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "WaitingViewController.h"

@interface WaitingViewController ()

@end

@implementation WaitingViewController

- (id) init
{
	if (self = [super initWithNibName:[[self class] description] bundle:nil]) {
		
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	CGRect bounds = [UIScreen mainScreen].bounds;
	CGRect myFrame = self.view.frame;
	myFrame.origin.x = bounds.size.width ;
	myFrame.origin.y = bounds.size.height;
	self.view.frame = myFrame;
	self.view.alpha = 0;
}

- (void) showOnScreen
{
	CGRect bounds = [UIScreen mainScreen].bounds;
	CGRect myFrame = self.view.frame;
	
	self.view.alpha = 0.0;
	myFrame.origin.x = (bounds.size.width - myFrame.size.width) * 0.5;
	myFrame.origin.y = (bounds.size.height - myFrame.size.height) * 0.5;
	
	self.view.frame = myFrame;
	
	[UIView beginAnimations : @"ShowView" context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationBeginsFromCurrentState:FALSE];
	
	self.view.alpha = 1.0;
	[UIView commitAnimations];
}


- (void) hideFromScreen
{
	CGRect bounds = [UIScreen mainScreen].bounds;
	CGRect myFrame = self.view.frame;
	
	[UIView beginAnimations : @"ShowView" context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationBeginsFromCurrentState:FALSE];
	
	self.view.alpha = 0.0;
	[UIView commitAnimations];
	
	self.view.alpha = 0.0;
	myFrame.origin.x = bounds.size.width ;
	myFrame.origin.y = bounds.size.height;
	
	self.view.frame = myFrame;

}
	
	
	
@end
