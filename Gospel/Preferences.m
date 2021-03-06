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
}

@end

// Basic Theme tint colors

#define RED_COLOR [UIColor colorWithRed:214.0/255.0 green:64.0/255.0 blue:79.0/255.0 alpha:1.0]
#define BLACK_COLOR [UIColor blackColor]
#define BLUE_COLOR [UIColor colorWithRed:19.0/255.0 green:141.0/255.0 blue:255.0/255.0 alpha:1.0]
#define YELLOW_COLOR [UIColor colorWithRed:255.0/255.0 green:172.0/255.0 blue:74.0/255.0 alpha:1.0]
#define GRAY_COLOR [UIColor colorWithRed:177.0/255.0 green:177.0/255.0 blue:177.0/255.0 alpha:1.0]

#define DEFAULT_CELL_COLOR [UIColor whiteColor]
#define DARK_BLUE_COLOR [UIColor colorWithRed:19.0/255.0 green:141.0/255.0 blue:255.0/255.0 alpha:0.75]
#define DARK_YELLOW_COLOR [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:0.75]
#define DARK_GRAY_COLOR [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.75]
#define LOW_WHITE_COLOR [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0]

#define DARK_BACKGROUND_COLOR [UIColor colorWithRed:35.0/255.0 green:36.0/255.0 blue:38.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND_COLOR [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]

#define DARK_NAVBAR_COLOR [UIColor colorWithRed:31.0/255.0 green:32.0/255.0 blue:34.0/255.0 alpha:1.0]
#define LIGHT_NAVBAR_COLOR [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]


/*
    To add new designcolor:

    1. add color and detail color as defined constants
    2. add color to (NSArray *)themeColorsArray method
    3. add colorTheme name to preferences.h enum list
    4. add color to switches in this file
*/


// Notifications

NSString * const VVVthemeChanged			= @"VVVthemeChanged";
NSString * const VVVpersistentStoreChanged	= @"VVVpersistentStoreChanged";
NSString * const VVVcloudSyncInProgress		= @"VVVcloudSyncInProgress";
 NSString * const VVVupdateBibleTable		= @"VVVupdateBibleTable";

// Local keys

NSString * const VVVThemeName		=	@"VVThemeName";
NSString * const VVVtrackReading	=	@"VVVTrackReading";
NSString * const VVVstoreInCloud	=	@"VVVstoreInClooud";
NSString * const VVVnightTheme		=	@"VVVnightTheme";
NSString * const VVVfontSize		=	@"VVVfontSize";
NSString * const VVVlineHeight		=	@"VVVlineHeight";
NSString * const VVVsubscribed		=	@"VVVsubscribedCK";
NSString * const VVVlastSynchro		=	@"VVVlastSynchro";

@implementation Preferences

@synthesize selectedParagraph, commentKind;


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
	[defaultValues setObject:@(NO) forKey:VVVnightTheme];
	[defaultValues setObject:@(YES) forKey:VVVtrackReading];
	[defaultValues setObject:@(YES) forKey:VVVstoreInCloud];
	[defaultValues setObject:@(16.0) forKey:VVVfontSize];
	[defaultValues setObject:@(ThemeLineHeightNormal) forKey:VVVlineHeight];
	[defaultValues setObject:@(NO) forKey:VVVsubscribed];
	[defaultValues setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:VVVlastSynchro];
	
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

- (ThemeStyle) actualTheme
{
	return self.currentTheme;
	//return 	(self.nightThemeSelected ? ThemeNightView : self.currentTheme);
}

- (UIImage *) themeSideBar
{
	NSString *sideBarImage = @"img_sidebar.png";
	switch ([self actualTheme]) {
		case ThemeBlue:         sideBarImage = @"img_sidebar_blue.png"; break;
		case ThemeYellow:		sideBarImage = @"img_sidebar_orange.jpg"; break;
		case ThemeGray:			sideBarImage = @"img_sidebar_grey.jpg"; break;
		default:                sideBarImage = @"img_sidebar.png";
			break;
	}
	return [UIImage imageNamed:sideBarImage];
}


- (UIImage *) themeBackButton
{
	NSString *image = @"icon_Back_red.png";
	switch ([self actualTheme]) {
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
	switch ([self actualTheme]) {
		case ThemeBlue: image = @"icon_upload_blue.png";
			break;
		default: image = @"icon_upload_red.png";
			break;
	}
	return [UIImage imageNamed:image];
}

- (UIColor *) themeCellBackgroundColor
{
	return (self.nightThemeSelected ? DARK_BACKGROUND_COLOR : LIGHT_BACKGROUND_COLOR);
}

- (UIColor *) themeBackgroundColor
{
	return (self.nightThemeSelected ? DARK_BACKGROUND_COLOR : LIGHT_BACKGROUND_COLOR);
}

- (UIColor *) themeNavBarBackgroundColor
{
	return (self.nightThemeSelected ? DARK_NAVBAR_COLOR : LIGHT_NAVBAR_COLOR);
}


- (UIColor *) themeTextColor
{
		return (self.nightThemeSelected ? LOW_WHITE_COLOR : BLACK_COLOR);
}

- (UIColor *) themeTintColor
{
    switch ([self actualTheme]) {
        case ThemeBlue:         return [self colorWithIntRed:19 green:141 andBlue:255];
        case ThemeYellow:       return [self colorWithIntRed:255 green:172 andBlue:74];
        case ThemeGray:         return [self colorWithIntRed:177 green:177 andBlue:177];
        //case ThemeNightView:    return BLACK_COLOR;
        default:                return[self colorWithIntRed:214 green:64 andBlue:79];
    }
}

- (UIColor *) themeDetailColor
{
	switch ([self actualTheme]) {
		case ThemeBlue:         return [self colorWithIntRed:19 green:141 andBlue:255];
        case ThemeYellow:       return [self colorWithIntRed:153 green:102 andBlue:51];
		case ThemeNightView:    return BLACK_COLOR;
        case ThemeGray:         return [self colorWithIntRed:102 green:102 andBlue:102];
		default:
			return [UIColor lightGrayColor];
	}
}

- (UIColor *)themeProgressBorder
{
	return self.themeTintColor;
//	switch([self actualTheme]) {
//		case ThemeDefault:      return RED_COLOR;
//		case ThemeNightView:    return self.themeTintColor;
//		case ThemeBlue:         return BLUE_COLOR;
//        case ThemeGray:         return GRAY_COLOR;
//        case ThemeYellow:       return YELLOW_COLOR;
//	}
}

- (UIColor *) themeProgressBackgroundColor
{
	return (self.nightThemeSelected ? DARK_BACKGROUND_COLOR : LIGHT_BACKGROUND_COLOR);
}

- (UIColor *) themeProgressFiller
{
	switch([self actualTheme]) {
		case ThemeDefault:		return [self colorWithIntRed:214 green:64 andBlue:79];
		case ThemeBlue:			return [self colorWithIntRed:19 green:141 andBlue:255];
        case ThemeYellow:       return [self colorWithIntRed:255 green:172 andBlue:74];
        case ThemeGray:         return [self colorWithIntRed:177 green:177 andBlue:177];
		case ThemeNightView:	return self.themeTintColor;
	}
}

- (NSArray *) themeColorsArray
{
	return @[
             RED_COLOR,
             GRAY_COLOR,
             YELLOW_COLOR,
			 BLUE_COLOR,			// NihtView theme is not included here! 
			 ];
}

- (UIColor *) colorWithIntRed:(int)aRed green:(int)aGreen andBlue:(int)aBlue
{
	CGFloat red  = aRed/255.0;
	CGFloat green = aGreen / 255.0;
	CGFloat blue = aBlue / 255.0;
	return [UIColor colorWithRed:red green:green blue:blue alpha:(self.nightThemeSelected ? 0.6 : 1.0)];
}


- (UIColor *)dayModeTintColor
{
	return [self colorWithIntRed:0xcc green:0xcc andBlue:0xcc];
}

- (UIColor *) nightModeTintColor
{
	return [self colorWithIntRed:220 green:63 andBlue:81];
}

- (UIColor *) dayButtonTintColor
{
    return self.themeTintColor;
}

- (UIColor *) nightButtonTintColor
{
    return self.themeTintColor;
}


- (UIColor *) fontSliderTintColor
{
	return self.themeTintColor;
}

- (UIImage *) buttonSeparator
{
	return [UIImage imageNamed:(self.nightThemeSelected ? @"day_nigh_hrt.png" : @"day_nigh_hrt_day.png")];
}

- (BOOL) nightThemeSelected
{
	return [prefs boolForKey:VVVnightTheme];
}

- (void) setNightThemeSelected:(BOOL)nightThemeSelected
{
	[prefs setBool:nightThemeSelected forKey:VVVnightTheme];
}

- (CGFloat) fontSize
{
	return [prefs doubleForKey:VVVfontSize];
}

- (void) setFontSize:(CGFloat)fontSize
{
	[prefs setDouble:fontSize forKey:VVVfontSize];
}

- (ThemeLineHeight) lineHeight
{
	return [prefs integerForKey:VVVlineHeight];
}

- (void) setLineHeight:(ThemeLineHeight)lineHeight
{
	[prefs setInteger:lineHeight forKey:VVVlineHeight];
}


#pragma mark -

- (BOOL) trackReading
{
	return [prefs boolForKey:VVVtrackReading];
}

- (void) setTrackReading:(BOOL)trackReading
{
	[prefs setBool:trackReading forKey:VVVtrackReading];
}

- (BOOL) storeInCloud
{
	return [prefs boolForKey:VVVstoreInCloud];
}

- (void) setStoreInCloud:(BOOL)storeInCloud
{
	[prefs setBool:storeInCloud forKey:VVVstoreInCloud];
}

#pragma mark - CK support

- (BOOL) subscribedToCloudKit
{
	return [prefs boolForKey:VVVsubscribed];
}

- (void) setSubscribedToCloudKit:(BOOL)subscribedToCloudKit
{
	[prefs setBool:subscribedToCloudKit forKey:VVVsubscribed];
}

- (NSDate *) lastSynchroDate
{
	return [prefs objectForKey:VVVlastSynchro];
}

- (void)setLastSynchroDate:(NSDate *)lastSynchroDate
{
	[prefs setObject:lastSynchroDate forKey:VVVlastSynchro];
}

@end
