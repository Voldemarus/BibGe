//
//  CircleIndicator.m
//  Gospel
//
//  Created by Водолазкий В.В. on 04.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "CircleIndicator.h"
#import "DebugPrint.h"

#define BORDER_OFFSET 3

@implementation CircleIndicator

@synthesize internalColor = _internalColor;

- (void) setInternalColor:(UIColor *)internalColor
{
	_internalColor = internalColor;
	self.backgroundColor = [UIColor clearColor];
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	// make drawing zone more compact to remove distortion
	CGFloat lineWidth = 2;
	CGRect borderRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
	// get parameters for filler color
	CGFloat colorRed, colorGreen, colorBlue, alpha;
	BOOL res = [self.internalColor getRed:&colorRed green:&colorGreen
									 blue:&colorBlue alpha:&alpha];
#pragma unused (res)
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetRGBFillColor(context, colorRed, colorGreen, colorBlue, 1.0);
	CGContextSetLineWidth(context, lineWidth);
	CGContextFillEllipseInRect (context, borderRect);
	CGContextStrokeEllipseInRect(context, borderRect);
	CGContextFillPath(context);
}

@end

#pragma mark -

@interface CircleButtonMatrix () {
	NSMutableArray *buttonsArray;
	NSMutableArray *indicatorArray;
	
	Preferences *prefs;
}

@end

@implementation CircleButtonMatrix

- (id) initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		prefs = [Preferences sharedInstance];
		[self setupLayout];
	}
	return self;
}


- (void) setupLayout
{
	DLog(@"setup layout for button matrix");
	prefs = [Preferences sharedInstance];
	[self setBackgroundColor:[UIColor clearColor]];
	NSInteger count = prefs.themeColorsArray.count;
	if (count > 0) {
		// arrays are used to prevent accident release (just anchor to be sure)
		buttonsArray = [[NSMutableArray alloc] initWithCapacity:count];
		indicatorArray = [[NSMutableArray alloc] initWithCapacity:count];
		CGRect drawRect = CGRectInset(self.frame, 4, 4);
		CGFloat buttonHeight = drawRect.size.height;
		// Calculate offset for the first button
		CGFloat freeSpace = drawRect.size.width - buttonHeight * count;
		CGFloat offset = freeSpace / (count + 1);
		
		for (NSInteger i = 0; i < count; i++) {
			// use simple loop to preserve order of themes
			CGFloat originX = offset + i * (offset + buttonHeight);
			CGRect frameRect = CGRectMake(originX, drawRect.origin.y,
										  buttonHeight, buttonHeight);
			// Tune up decoration first
			CircleIndicator *ind = [[CircleIndicator alloc] initWithFrame:frameRect];
			ind.internalColor = prefs.themeColorsArray[i];
			[indicatorArray addObject:ind];
			[self addSubview:ind];
			// Now set up button above it
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = frameRect;
			[button setTag:(i+101)];
			[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
			[buttonsArray addObject:button];
			[self addSubview:button];
		}
	}
}

- (IBAction) buttonTapped:(id)sender
{
	NSInteger themeCode = [(UIButton *)sender tag] - 101;
	prefs.currentTheme = themeCode;
	[[NSNotificationCenter defaultCenter] postNotificationName:VVVthemeChanged object:nil];
	if (_delegate) {
		[_delegate circleButtonMatrixThemeSelected:themeCode];
	}
}

@end



