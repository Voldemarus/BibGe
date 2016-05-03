//
//  Preferences.m
//  Gospel
//
//  Created by Водолазкий В.В. on 03.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "Preferences.h"

@interface Preferences () {
	NSUserDefaults *prefs;
	NSMutableSet *imagesSelected;
	NSMutableSet *soundsSelected;
	NSMutableArray *_imagePosition;
}

@end

// Basic Theme tint colors

#define RED_COLOR [UIColor colorWithRed:214.0/255.0 green:64.0/255.0 blue:79.0/255.0 alpha:1.0]
#define BLACK_COLOR [UIColor blackColor]
#define DEFAULT_CELL_COLOR [UIColor whiteColor]
#define BLUE_COLOR [UIColor colorWithRed:19.0/255.0 green:141.0/255.0 blue:255.0/255.0 alpha:1.0]
#define DARK_BLUE_COLOR [UIColor colorWithRed:19.0/255.0 green:141.0/255.0 blue:255.0/255.0 alpha:0.75]
#define LOW_WHITE_COLOR [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0]



// Notifications

NSString * const VVVthemeChanged = @"VVVthemeChanged";

// Local keys

NSString * const VVVThemeName = @"VVThemeName";

@implementation Preferences

+ (Preferences *) sharedInstance
{
	static Preferences *_Preferences;
	if (_Preferences == nil) {
		_Preferences = [[Preferences alloc] init];
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
	[defaultValues setObject:@(ThemeDefault) forKey:VVVThemeName];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
	
}

- (id) init
{
	if (self = [super init]) {
		prefs = [NSUserDefaults standardUserDefaults];
	}
	return self;
}


- (void) flush
{
	[[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 

- (ThemeStyle) currentTheme
{
	return [prefs integerForKey:VVVThemeName];
}

- (void) setCurrentTheme:(ThemeStyle)currentTheme
{
	[prefs setInteger:currentTheme forKey:VVVThemeName];
}

- (UIImage *) themeSideBar
{
	NSString *sideBarImage = @"img_sidebar.png";
	switch (self.currentTheme) {
		case ThemeBlue:	sideBarImage = @"img_sidebar_blue.png";
			break;
		case ThemeNightView:	sideBarImage = @"img_sidebar_black.png";
			break;

		default: sideBarImage = @"img_sidebar.png";
			break;
	}
	return [UIImage imageNamed:sideBarImage];
}

- (UIImage *) themeCircle
{
	NSString *themeCircleImage = @"icon_circle_red.png";
	switch (self.currentTheme) {
		case ThemeBlue: themeCircleImage = @"icon_circle_blue.png";
			break;
		default: themeCircleImage = @"icon_circle_red.png";
			break;
	}
	return [UIImage imageNamed:themeCircleImage];
}

- (UIImage *) themeBackButton
{
	NSString *image = @"icon_Back_red.png";
	switch (self.currentTheme) {
		case ThemeBlue: image = @"icon_Back.png";
			break;
		default: image = @"icon_Back_red.png";
			break;
	}
	return [UIImage imageNamed:image];
}

- (UIImage *) themeUploadButton
{
	NSString *image = @"icon_upload_red.png";
	switch (self.currentTheme) {
		case ThemeBlue: image = @"icon_upload_blue.png";
			break;
		default: image = @"icon_upload_red.png";
			break;
	}
	return [UIImage imageNamed:image];
}

- (UIColor *) themeCellBackgroundColor
{
	switch (self.currentTheme) {
		case ThemeNightView: return BLACK_COLOR;
		default: return DEFAULT_CELL_COLOR;
	}
}

- (UIColor *) themeTextColor
{
	switch (self.currentTheme) {
		case ThemeBlue: return BLUE_COLOR;
		case ThemeNightView: return LOW_WHITE_COLOR;
		default: return RED_COLOR;
	}
}

- (UIColor *) themeDetailColor
{
	switch (self.currentTheme) {
		case ThemeBlue: return DARK_BLUE_COLOR;
		case ThemeNightView: return BLACK_COLOR;
		default:
			return [UIColor lightGrayColor];
	}
}

- (UIColor *)themeProgressBorder
{
	switch(self.currentTheme) {
		case ThemeDefault:	return RED_COLOR;
		case ThemeNightView: return [UIColor whiteColor];
		case ThemeBlue: return BLUE_COLOR;
	}
}

- (UIColor *) themeProgressBackgroundColor
{
	switch (self.currentTheme) {
		case ThemeNightView:	return BLACK_COLOR;
		default:	return [UIColor whiteColor];
	}
}

- (UIColor *) themeProgressFiller
{
	switch(self.currentTheme) {
		case ThemeDefault:		return RED_COLOR;
		case ThemeBlue:			return BLUE_COLOR;
		case ThemeNightView:	return [UIColor whiteColor];
	}
}

#pragma mark -

- (void) selectNextTheme
{
	if (self.currentTheme == ThemeNightView) {
		self.currentTheme = ThemeDefault;
	} else {
		self.currentTheme++;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:VVVthemeChanged object:nil];
}

@end
