//
//  ThemeTuneViewController.h
//  Gospel
//
//  Created by Водолазкий В.В. on 04.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Preferences.h"
#import "CircleIndicator.h"

@interface ThemeTuneViewController : UIViewController <UITableViewDelegate,
						UITableViewDataSource, CircleButtonMatrixDelegate,
						NSLayoutManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *exampleTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *underlineCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *titleCell;

@property (weak, nonatomic) IBOutlet UIView *tshadowColorView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *exampleSeparator;
@property (weak, nonatomic) IBOutlet UILabel *exampleTitle;

@property (weak, nonatomic) IBOutlet UILabel *exampleText;
@property (weak, nonatomic) IBOutlet UITableView *panelTable;

@property (strong, nonatomic) IBOutlet UITableViewCell *DayNightCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *themeSelectionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *fontSizwSelectionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *lineHeightCell;

@property (weak, nonatomic) IBOutlet UIButton *dayButton;
- (IBAction)dayButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nightButton;
- (IBAction)nightButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet CircleButtonMatrix *themeSelector;

@property (weak, nonatomic) IBOutlet UIImageView *minFontIcon;
@property (weak, nonatomic) IBOutlet UIImageView *maxFontIcon;
@property (weak, nonatomic) IBOutlet UISlider *fontSlider;
- (IBAction)fontSliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *heightDenseButton;
- (IBAction)heightDenseButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *heightNormalButton;
- (IBAction)heightNormalButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *heightLooseButton;
- (IBAction)heightLooseButtonTapped:(id)sender;

@end
