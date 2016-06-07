//
//  GEPreferences.m
//  Gospel
//
//  Created by Водолазкий В.В. on 05.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "GEPreferences.h"

NSString * const VVVupdateFeedbackTable		=	@"VVVupdateFeedbackTable";
NSString * const VVVupdateParagraphTable	=	@" VVVupdateParagraphTable";


@interface GEPreferences() {
	NSUserDefaults *prefs;
}

@end

NSString * const VVVLastFeedBackDate	=	@"VVVLastFeedBackDate";


@implementation GEPreferences

+ (GEPreferences *) sharedInstance
{
	static GEPreferences *_Preferences;
	if (_Preferences == nil) {
		_Preferences = [[GEPreferences alloc] init];
	}
	return _Preferences;
}

//
// Init set of data for case when actual preference file is not created yet
//
+ (void)initialize
{
	NSMutableDictionary  *defaultValues = [NSMutableDictionary dictionary];
	// set up default parameters
	[defaultValues setObject:[NSDate dateWithTimeIntervalSince1970:1000] forKey:VVVLastFeedBackDate];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
	
}

- (id) init
{
	if (self = [super init]) {
		prefs = [NSUserDefaults standardUserDefaults];
	}
	return self;
}

- (NSDate *) lastFeedbackDate
{
	return [prefs objectForKey:VVVLastFeedBackDate];
}

- (void) setLastFeedbackDate:(NSDate *)lastFeedbackDate
{
	[prefs setObject:lastFeedbackDate forKey:VVVLastFeedBackDate];
}


@end
