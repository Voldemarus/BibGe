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

@interface SettingsTableViewController () {
	Preferences *prefs;
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
	// set up switch positions
	self.swTrackSwitch.on = prefs.trackReading;
	self.iCloudSyncSwitch.on = prefs.storeInCloud;
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
 	
	switch (indexPath.row) {
		case 0:	return self.trackReadingCell;
		case 1: return self.iCloudCell;
		case 2: return self.contactUsCell;
		default: return self.resetReadingCell;
	}
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
		DLog(@"Reset Tracking TODO!!!!!");
	}
}




- (void) composeMail
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	NSString *appName = PRODUCT_NAME;
	NSString *subject = [NSString stringWithFormat:RStr(@"%@ feedback"),
						 appName];
	[picker setSubject:subject];
//	[picker setToRecipients:@[@"pinwheelsoftware@gmail.com"]];
	
	[picker setToRecipients: @[RStr(@"FeedbackEmailID") ]];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	
	DeviceVersion devNCode = [SDiPhoneVersion deviceVersion];
	NSString *devName = @"";
	
	switch (devNCode) {
		case iPhone4	:	devName = @"iPhone 4"; break;
		case iPhone4S	:	devName = @"iPhone 4S"; break;
		case iPhone5	:	devName = @"iPhone 5/5C"; break;
		case iPhone5S	:	devName = @"iPhone 5S"; break;
		case iPhone6	:	devName = @"iPhone 6"; break;
		case iPhone6Plus:	devName = @"iPhomne 6+"; break;
		default:
			devName = @"Non supported Device!";
	}
	
	NSString *deviceModel = [NSString stringWithFormat:@"%@ OS : %@ %@",
							 devName, myDevice.model,
							 myDevice.systemVersion];
	
	NSString *versionString = [NSString stringWithFormat:@"V.%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

	NSString *initialText= [NSString stringWithFormat:@"\n\n--- \nMy Device is: %@,\nApplication Version: %@", deviceModel ,versionString];
	
	[picker setMessageBody:initialText isHTML:NO];
	
	if (picker) {
		[self presentViewController:picker animated:YES completion:^(void) {
			
		}];
	} else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:RStr(@"Cannot send E-Mail")
							  message:RStr(@"Your Email account is not set up properly") delegate:nil
							  cancelButtonTitle:RStr(@"Cancel")
							  otherButtonTitles:nil];
		[alert show];
		return;
	}
}

-(void)mailComposeController:(MFMailComposeViewController*)controller
		 didFinishWithResult:(MFMailComposeResult)result
					   error:(NSError*)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)trackSwitchChanged:(id)sender {
	prefs.trackReading = self.swTrackSwitch.on;
}

- (IBAction)cloudSwitchChanged:(id)sender {
	prefs.storeInCloud = self.iCloudSyncSwitch.on;
}
@end
