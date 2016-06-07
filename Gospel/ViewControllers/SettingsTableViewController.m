//
//  SettingsTableViewController.m
//  Gospel
//
//  Created by Мария Водолазкая on 03.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "Preferences.h"
#import "DebugPrint.h"
#import "SDIPhoneVersion.h"
#import "DAO.h"
#import "FeedbackViewController.h"

@interface SettingsTableViewController () {
	Preferences *prefs;
	FeedbackViewController *feedbackController;
}


@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	prefs = [Preferences sharedInstance];
	
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBar.barTintColor = prefs.themeNavBarBackgroundColor;
	self.navigationController.navigationBar.tintColor = prefs.themeTintColor;
	self.navigationController.navigationBar.barStyle = (prefs.nightThemeSelected ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : prefs.themeTintColor}];
	self.navigationController.navigationBar.translucent = NO;
	
	self.iCloudSyncSwitch.tintColor = prefs.themeTintColor;
	self.iCloudSyncSwitch.onTintColor = prefs.themeTintColor;
	self.swTrackSwitch.tintColor = prefs.themeTintColor;
	self.swTrackSwitch.onTintColor = prefs.themeTintColor;
	
	self.tableView.tintColor = prefs.themeTintColor;
	
	
	// set up switch positions
	self.swTrackSwitch.on = prefs.trackReading;
	self.iCloudSyncSwitch.on = prefs.storeInCloud;
	// set up theme
	self.view.backgroundColor = prefs.themeBackgroundColor;
	self.tableView.backgroundColor = prefs.themeBackgroundColor;
	
	self.trackReadingLabel.textColor = prefs.themeTextColor;
	self.cloudSyncLabel.textColor = prefs.themeTextColor;
	
	self.swTrackSwitch.tintColor = prefs.themeTintColor;
	self.iCloudSyncSwitch.tintColor = prefs.themeTintColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = nil;
	switch (indexPath.row) {
		case 0:	cell =  self.trackReadingCell; break;
		case 1: cell = self.iCloudCell; break;
		case 2: cell = self.contactUsCell; break;
		default: cell = self.resetReadingCell; break;
	}
	cell.tintColor = prefs.themeTintColor;
	cell.textLabel.textColor = prefs.themeTextColor;
	cell.backgroundColor = prefs.themeCellBackgroundColor;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if (indexPath.row == 0) {
		// switch trackReading
		BOOL newValue = !prefs.trackReading;
		self.swTrackSwitch.on = newValue;
		prefs.trackReading = newValue;
	} else if (indexPath.row == 1) {
		BOOL newValue = !prefs.storeInCloud;
		self.iCloudSyncSwitch.on = newValue;
		prefs.storeInCloud = newValue;
	} else if (indexPath.row == 2) {
		// contact us. Open Mailcomposer if mail account is set up correctly
		[self composeMail];
	} else if (indexPath.row == 3) {
		// reset tracking reading
		[[DAO sharedInstance] resetTrackingIndexes];
	}
}



- (void) composeMail
{
	NSString *appName = PRODUCT_NAME;
	UIDevice *myDevice = [UIDevice currentDevice];
	
	DeviceVersion devNCode = [SDiPhoneVersion deviceVersion];
	NSString *devName = @"";
	
	switch (devNCode) {
		case iPhone4	:	devName = @"iPhone 4"; break;
		case iPhone4S	:	devName = @"iPhone 4S"; break;
		case iPhone5	:	devName = @"iPhone 5/5C"; break;
		case iPhone5S	:	devName = @"iPhone 5S"; break;
		case iPhone6	:	devName = @"iPhone 6"; break;
		case iPhone6Plus:	devName = @"iPhone 6+"; break;
		default:
			devName = @"Non supported Device!";
	}
	
	NSString *deviceModel = [NSString stringWithFormat:@"%@ OS : %@ %@",
							 devName, myDevice.model,
							 myDevice.systemVersion];
	
	NSString *versionString = [NSString stringWithFormat:@"V.%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

	NSString *initialText= [NSString stringWithFormat:@"\n\n--- \nMy Device is: %@,\nApplication Version: %@", deviceModel ,versionString];
	
	if (!feedbackController) {
		feedbackController = [[FeedbackViewController alloc] init];
	}
	feedbackController.deviceInfo = [NSString stringWithFormat:@" %@,\nApplication Version: %@", deviceModel ,versionString];
	feedbackController.initialText = initialText;
	[self.navigationController pushViewController:feedbackController animated:YES];
	
	
}

- (IBAction)trackSwitchChanged:(id)sender {
	prefs.trackReading = self.swTrackSwitch.on;
}

- (IBAction)cloudSwitchChanged:(id)sender {
	prefs.storeInCloud = self.iCloudSyncSwitch.on;
	[[DAO sharedInstance] updatePersistentCoordinator];
}
@end
