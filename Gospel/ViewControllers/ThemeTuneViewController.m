//
//  ThemeTuneViewController.m
//  Gospel
//
//  Created by Водолазкий В.В. on 04.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ThemeTuneViewController.h"

@interface ThemeTuneViewController () {
	Preferences *prefs;
}

@end

@implementation ThemeTuneViewController

- (id) init
{
	if (self = [super initWithNibName:[[self class] description] bundle:nil]) {
		prefs = [Preferences sharedInstance];
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	_panelTable.delegate = self;
	_panelTable.dataSource = self;
	self.themeSelector.delegate = self;
	
	self.exampleText.layoutManager.delegate = self;
	[self.themeSelector setupLayout];
	[self setupLayout];
	
	self.fontSlider.value = prefs.fontSize;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegate Methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0:	return self.DayNightCell;
		case 1: return self.themeSelectionCell;
		case 2: return self.fontSizwSelectionCell;
		default: return self.lineHeightCell;
	}
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Theme Selector delegate -

- (void) circleButtonMatrixThemeSelected:(ThemeStyle) selectedTheme;
{
	[self setupLayout];
}


#pragma mark - Layout manager delegate

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
	return prefs.lineHeight;
}

#pragma mark -

- (void) setupLayout
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:self.exampleText.font.fontName
                                                                      size:(self.fontSlider.value+4.0)]};

    CGRect rect = [self.exampleTitle.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    self.exampleTitle.frame = rect;
    [self.view updateConstraints];
    

    
    
    
    
	[[UINavigationBar appearance]  setTintColor:prefs.themeTintColor];
	
	self.navigationController.navigationBar.barTintColor = prefs.themeNavBarBackgroundColor;
	self.navigationController.navigationBar.tintColor = prefs.themeTintColor;
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : prefs.themeTintColor}];
	self.navigationController.navigationBar.translucent = NO;
    	
	self.exampleTitle.textColor = prefs.themeTextColor;
	self.exampleText.textColor = prefs.themeTextColor;
	self.exampleSeparator.textColor = prefs.themeTintColor;
	
	self.view.backgroundColor = prefs.themeBackgroundColor;
	
	self.panelTable.backgroundColor = (prefs.nightThemeSelected ? [UIColor darkGrayColor] :
									   [UIColor whiteColor]);
	
	[self.panelTable reloadData];
}


#pragma mark - Buttons -

- (IBAction)dayButtonTapped:(id)sender
{
	prefs.nightThemeSelected = NO;
	[self setupLayout];
}

- (IBAction)nightButtonTapped:(id)sender
{
	prefs.nightThemeSelected = YES;
	[self setupLayout];
}

- (IBAction)fontSliderChanged:(id)sender
{
	CGFloat newValue = self.fontSlider.value;
	prefs.fontSize = newValue;
	self.exampleText.font = [UIFont systemFontOfSize:newValue];
	self.exampleTitle.font = [UIFont systemFontOfSize:(newValue+4.0)];
}

- (IBAction)heightDenseButtonTapped:(id)sender
{
	prefs.lineHeight = ThemeLineHeightSmall;
	[self setupLayout];
}

- (IBAction)heightNormalButtonTapped:(id)sender
{
	prefs.lineHeight = ThemeLineHeightNormal;
	[self setupLayout];
}

- (IBAction)heightLooseButtonTapped:(id)sender
{
	prefs.lineHeight = ThemeLineHeightBig;
	[self setupLayout];
}

- (IBAction)backButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
