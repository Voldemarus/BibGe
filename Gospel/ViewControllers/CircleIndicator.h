//
//  CircleIndicator.h
//  Gospel
//
//  Created by Водолазкий В.В. on 04.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Preferences.h"

@interface CircleIndicator : UIView

@property (nonatomic, retain) UIColor *internalColor;

@end


@protocol  CircleButtonMatrixDelegate  <NSObject>

- (void) circleButtonMatrixThemeSelected:(ThemeStyle) selectedTheme;

@end


@interface CircleButtonMatrix : UIView

@property (nonatomic, assign) id <CircleButtonMatrixDelegate> delegate;

- (void) setupLayout;
@end
