//
//  FeedbackWindowController.m
//  Gospel
//
//  Created by Водолазкий В.В. on 05.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "FeedbackWindowController.h"

@interface FeedbackWindowController () {
	DAO  *dao;
}

@end

@implementation FeedbackWindowController


- (id)init
{
	self = [super initWithWindowNibName:[[self class] description]];
	if (self) {
		// Initialization code here.
		dao = [DAO sharedInstance];
		self.feedbackMoc = dao.feedbackMoc;
	}
	return self;
}



- (void)windowDidLoad {
    [super windowDidLoad];
    
}

@end
