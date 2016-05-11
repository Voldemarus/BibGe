//
//  Preferences.h
//  Gospel
//
//  Created by Водолазкий В.В. on 03.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PRODUCT_NAME		@"Bible In One Year (GE)"


// Theme list enumerator
typedef NS_ENUM(NSInteger, ThemeStyle) {
	ThemeDefault,
	ThemeGray,
    ThemeYellow,
    ThemeBlue,
	ThemeNightView,		// always last theme! not included into pa;ette!
};


typedef NS_ENUM(NSInteger, ThemeLineHeight) {
	ThemeLineHeightSmall = 10,
	ThemeLineHeightNormal = 15,
	ThemeLineHeightBig = 20,
};


typedef  NS_ENUM(NSInteger, KindOfComment) {
	CommentKindOldTestament = 0,
	CommentKindNewTestament,
	CommentKindPsalm,
};

// Notifications

extern NSString * const VVVthemeChanged;				// theme is changed
extern NSString * const VVVpersistentStoreChanged;		// iCloud connected/disconnected
extern NSString * const VVVcloudSyncInProgress;


@class Paragraph;

@interface Preferences : NSObject

+ (Preferences *) sharedInstance;

- (void) flush;			// force writing preferences to "disk"

// Theme support
@property (nonatomic, readwrite) ThemeStyle currentTheme;
@property (nonatomic, readwrite) BOOL nightThemeSelected;

@property (nonatomic, readonly) UIImage *themeSideBar;
@property (nonatomic, readonly) UIImage *themeBackButton;
@property (nonatomic, readonly) UIImage *themeUploadButton;
@property (nonatomic, readonly) UIColor *themeTintColor;
@property (nonatomic, readonly) UIColor *themeTextColor;
@property (nonatomic, readonly) UIColor *themeDetailColor;
@property (nonatomic, readonly) UIColor *themeCellBackgroundColor;
@property (nonatomic, readonly) UIColor *themeBackgroundColor;
@property (nonatomic, readonly) UIColor *themeNavBarBackgroundColor;
@property (nonatomic, readonly) NSArray *themeColorsArray;	// colors for day themes indicaors

@property (nonatomic, readwrite) CGFloat fontSize;
@property (nonatomic, readwrite) ThemeLineHeight lineHeight;

// Comment settings

@property (nonatomic, retain) Paragraph *selectedParagraph;
@property (nonatomic, readwrite) KindOfComment commentKind;



// definitions for progrescircle view
@property (nonatomic, readonly) UIColor *themeProgressBorder;
@property (nonatomic, readonly) UIColor *themeProgressFiller;
@property (nonatomic, readonly) UIColor *themeProgressBackgroundColor;

// user settings

@property (nonatomic, readwrite) BOOL trackReading;
@property (nonatomic, readwrite) BOOL storeInCloud;

@end
