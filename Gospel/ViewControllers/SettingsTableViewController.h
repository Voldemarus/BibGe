//
//  SettingsTableViewController.h
//  Gospel
//
//  Created by Мария Водолазкая on 03.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface SettingsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISwitch *swTrackSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *iCloudSyncSwitch;


@property (weak, nonatomic) IBOutlet UITableViewCell *trackReadingCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *iCloudCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *contactUsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *resetReadingCell;


- (IBAction)trackSwitchChanged:(id)sender;
- (IBAction)cloudSwitchChanged:(id)sender;


@end
