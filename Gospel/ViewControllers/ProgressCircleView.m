//
//  ProgressCircleView.m
//  Gospel
//
//  Created by Водолазкий В.В. on 03.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ProgressCircleView.h"
#import "DebugPrint.h"

#define BORDER_OFFSET	3

@implementation ProgressCircleView

@synthesize progressValue = _progressValue;;
@synthesize color;

- (void) setProgressValue:(CGFloat)progressValue
{
	if (progressValue < 0.0) progressValue = 0.0;
	if (progressValue > 1.0) progressValue = 1.0;
	_progressValue = progressValue;
	Preferences *prefs = [Preferences sharedInstance];
	self.backgroundColor = prefs.themeProgressBackgroundColor;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	Preferences *prefs = [Preferences sharedInstance];
	CGContextRef context = UIGraphicsGetCurrentContext();
	// make drawing zone more compact to remove distortion
	CGRect inRect;
	inRect.origin.x = rect.origin.x + BORDER_OFFSET;
	inRect.origin.y = rect.origin.y + BORDER_OFFSET;
	inRect.size.width = rect.size.width - BORDER_OFFSET*2;
	inRect.size.height = rect.size.height - BORDER_OFFSET*2;
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
	CGContextStrokeEllipseInRect(context, inRect);

	// and fill it if progress is defined
	if (_progressValue > 0.05) {
		CGFloat center = rect.size.width * 0.5;
		CGFloat angle = - M_PI_2 + (M_PI * 2 * _progressValue);
		CGContextMoveToPoint(context, center, center);
		CGContextAddArc(context, center, center,
						center-BORDER_OFFSET,
						-M_PI_2, angle , 0);
		CGContextClosePath(context);
	}
	
	CGContextFillPath(context);
	
	
}


@end
