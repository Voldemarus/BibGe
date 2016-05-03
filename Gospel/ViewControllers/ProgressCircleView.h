//
//  ProgressCircleView.h
//  Gospel
//
//  Created by Водолазкий В.В. on 03.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Preferences.h"

@interface ProgressCircleView : UIView

@property (nonatomic, readwrite) CGFloat progressValue;		// 0..1.0
@property (nonatomic, readwrite) UIColor *color;


@end
