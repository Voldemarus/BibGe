//
//  ProgressCircleView.m
//  Gospel
//
//  Created by Водолазкий В.В. on 03.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ProgressCircleView.h"

@interface ProgressCircleView () {
	Preferences *prefs;
}

@end


@implementation ProgressCircleView

@synthesize progressValue = _progressValue;;

- (id) initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		prefs = [Preferences sharedInstance];
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}


- (void) setProgressValue:(CGFloat)progressValue
{
	if (progressValue < 0.0) progressValue = 0.0;
	if (progressValue > 1.0) progressValue = 1.0;
	_progressValue = progressValue;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	// set border color
	UIColor *foreColor = prefs.themeProgressBorder;
	CGFloat red, green, blue, alpha;
	BOOL get = [foreColor getRed:&red green:&green blue:&blue alpha:&alpha];
	CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
	UIColor *fillColor = prefs.themeProgressFiller;
	get = [fillColor getRed:&red green:&green blue:&blue alpha:&alpha];
	CGContextSetRGBFillColor(context, red, green, blue, alpha);
	// draw circle border
	CGContextSetLineWidth(context, 1.0);
	CGContextStrokeEllipseInRect(context, rect);

	// and fill it if progress is defined
	if (_progressValue > 0.05) {
		CGFloat angle = (M_PI * 2 / _progressValue);
		CGContextAddArc(context, rect.size.width/2.0, rect.size.height/2.0,
						rect.size.width/2.0,
						0.0, angle , 1);
	}
	
	CGContextFillPath(context);
	
	
}


@end
