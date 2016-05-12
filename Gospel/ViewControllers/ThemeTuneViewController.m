//
//  ThemeTuneViewController.m
//  Gospel
//
//  Created by Водолазкий В.В. on 04.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "ThemeTuneViewController.h"
#import "DebugPrint.h"

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
    self.exampleTableView.delegate = self;
    self.exampleTableView.dataSource = self;
	
	[self.dayButton setTitle:RStr(@"Day") forState:UIControlStateNormal];
	[self.nightButton setTitle:RStr(@"Night") forState:UIControlStateNormal];
	
	//self.exampleText.layoutManager.delegate = self;
	[self.themeSelector setupLayout];
	[self setupLayout];
	
	self.fontSlider.value = prefs.fontSize;

    self.tshadowColorView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.35];

	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegate Methods

-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    if (tableView == self.exampleTableView)
    {
        if (indexPath.row == 0)
        {
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:prefs.fontSize + 4.0f]};
            CGRect rect = [self.exampleTitle.text boundingRectWithSize:CGSizeMake(self.exampleTableView.frame.size.width, MAXFLOAT)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:attributes
                                                               context:nil];
            return rect.size.height + 50;
        }
        if (indexPath.row == 1)
        {
            return 44;
        }
        if (indexPath.row == 2)
        {
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:prefs.fontSize]};
            // NSString class method: boundingRectWithSize:options:attributes:context is
            // available only on ios7.0 sdk.
            CGRect rect = [self.exampleText.text boundingRectWithSize:CGSizeMake(self.exampleTableView.frame.size.width, MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:attributes
                                                              context:nil];
            //contentLabel.frame = rect;
            //cell.frame = rect;
            
            return rect.size.height;
        }

    }
    return 44;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.exampleTableView)
        return 3;
    else
        return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.exampleTableView)
    {
        switch (indexPath.row) {
            case 0:	return self.titleCell;
            case 1: return self.underlineCell;
            case 2: return self.contentCell;
            default: return self.contentCell;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:	return self.DayNightCell;
            case 1: return self.themeSelectionCell;
            case 2: return self.fontSizwSelectionCell;
            default: return self.lineHeightCell;
        }
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
    [self.view updateConstraints];
    
	
	[[UINavigationBar appearance]  setTintColor:prefs.themeTintColor];
	
	self.dayButton.tintColor = prefs.dayModeTintColor;
	self.nightButton.tintColor = prefs.nightModeTintColor;
	self.buttonSeparator.image = prefs.buttonSeparator;
	
	self.navigationController.navigationBar.barTintColor = prefs.themeNavBarBackgroundColor;
	self.navigationController.navigationBar.tintColor = prefs.themeTintColor;
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : prefs.themeTintColor}];
	self.navigationController.navigationBar.translucent = NO;
    	
	self.exampleTitle.textColor = prefs.themeTextColor;
	self.exampleTitle.textAlignment = NSTextAlignmentCenter;
	self.exampleText.textColor = prefs.themeTextColor;
	self.exampleSeparator.textColor = prefs.themeTintColor;
	
	self.fontSlider.tintColor = prefs.fontSliderTintColor;
	
	self.view.backgroundColor = prefs.themeBackgroundColor;
	
	self.panelTable.backgroundColor = (prefs.nightThemeSelected ? [UIColor darkGrayColor] :
									   [UIColor whiteColor]);
    self.exampleTableView.backgroundColor = (prefs.nightThemeSelected ? prefs.themeBackgroundColor :
                                             [UIColor whiteColor]);
    
    
    self.contentCell.backgroundColor = (prefs.nightThemeSelected ? prefs.themeBackgroundColor :
                                        [UIColor whiteColor]);
    self.underlineCell.backgroundColor = (prefs.nightThemeSelected ? prefs.themeBackgroundColor :
                                          [UIColor whiteColor]);
    self.titleCell.backgroundColor = (prefs.nightThemeSelected ? prefs.themeBackgroundColor :
                                      [UIColor whiteColor]);

    
    
    self.DayNightCell.backgroundColor = (prefs.nightThemeSelected ? [UIColor darkGrayColor] :
                                         [UIColor whiteColor]);
    self.lineHeightCell.backgroundColor = (prefs.nightThemeSelected ? [UIColor darkGrayColor] :
                                           [UIColor whiteColor]);
    self.themeSelectionCell.backgroundColor = (prefs.nightThemeSelected ? [UIColor darkGrayColor] :
                                               [UIColor whiteColor]);
    self.fontSizwSelectionCell.backgroundColor = (prefs.nightThemeSelected ? [UIColor darkGrayColor] :
                                                    [UIColor whiteColor]);


    
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"ქვეყანაზე არსებულ წიგნებს შორის ყველაზე ჭეშმარიტი და სასარგებლო წმინდა ბიბლიაა. სიტყვა ბიბლია ბერძნულია და „წიგნებს\" ნიშნავს. რატომაა ბიბლია ერთი წიგნი, ხოლო ჰქვია „წიგნები\"? იმიტომ, რომ ბიბლიაში სინამდვილეში არა ერთი ან ორი, არამედ რამდენიმე წიგნია თავმოყრილი, ისინი ერთ წიგნადაა შეკრებილი და ჰქვია წმ.\n\n\nბიბლია ან წმინდა წიგნი. წმინდა იმიტომ ეწოდებათ, რომ ისინი დაწერილია სულიწმიდის შთაგონებით, წმიდა ადამიანების მიერ.\n\n\nვინ და როდის დაწერა ბიბლია? ის დაიწერა სხვადასხვა ადამიანების მიერ სხვადასხვა დროს. ერთი ნაწილი წიგნებისა დაწერილია ქრისტეს შობამდე და მათ ეწოდებათ „ძველი აღთქმის\" წიგნები."];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:prefs.lineHeight];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, attrString.length)];
    self.exampleText.attributedText = attrString;
    
	
	[self.panelTable reloadData];
    [self.exampleTableView reloadData];
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
    [self.exampleTableView reloadData];
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
