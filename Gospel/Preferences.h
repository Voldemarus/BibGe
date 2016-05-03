//
//  Preferences.h
//  Gospel
//
//  Created by Водолазкий В.В. on 03.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Theme list enumerator
typedef NS_ENUM(NSInteger, ThemeStyle) {
	ThemeDefault,
	ThemeBlue,
	ThemeNightView,
};


// Notifications

extern NSString * const VVVthemeChanged;		// theme is changed



@interface Preferences : NSObject

+ (Preferences *) sharedInstance;

- (void) flush;			// force writing preferences to "disk"

// Theme support
@property (nonatomic, readwrite) ThemeStyle currentTheme;
@property (nonatomic, readonly) UIImage *themeSideBar;
@property (nonatomic, readonly) UIImage *themeCircle;
@property (nonatomic, readonly) UIImage *themeBackButton;
@property (nonatomic, readonly) UIImage *themeUploadButton;
@property (nonatomic, readonly) UIColor *themeTintColor;
@property (nonatomic, readonly) UIColor *themeTextColor;
@property (nonatomic, readonly) UIColor *themeDetailColor;
@property (nonatomic, readonly) UIColor *themeCellBackgroundColor;


- (void) selectNextTheme;


@end
