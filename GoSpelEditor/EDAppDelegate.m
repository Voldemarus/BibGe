//
//  AppDelegate.m
//  GoSpelEditor
//
//  Created by Водолазкий В.В. on 17.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "EDAppDelegate.h"
#import "GEPreferences.h"

@interface EDAppDelegate () {
	DAO *dao;
	Paragraph *selectedParagraph;
	GEPreferences *prefs;
}

- (IBAction)dateModificationTapped:(id)sender;

@property (weak) IBOutlet NSArrayController *sataController;
@property (weak) IBOutlet NSPopover *dateSelectorView;
@property (weak) IBOutlet NSDatePicker *dateSelectorPicker;
@property (weak) IBOutlet NSButton *dateSelectorButton;

- (IBAction)dateSelectorChanged:(id)sender;
- (IBAction)dateSelectorCanceled:(id)sender;

@property (weak) IBOutlet NSWindow *window;
- (IBAction)saveAction:(id)sender;

- (IBAction) showFeedbackWindow:(id)sender;
- (IBAction)refreshDatePressed:(id)sender;
- (IBAction)checkLinkPressed:(id)sender;

@property (weak) IBOutlet NSTextField *creationDateLabel;
@property (weak) IBOutlet NSTextField *recordTitleField;
@property (weak) IBOutlet NSTextField *linkTextField;

@property (unsafe_unretained) IBOutlet NSTextView *textEditor;
@property (unsafe_unretained) IBOutlet NSTextView *translation1Editor;
@property (unsafe_unretained) IBOutlet NSTextView *translation2Editor;
@property (unsafe_unretained) IBOutlet NSTextView *translation3Editor;

@property (weak) IBOutlet NSTextField *uploadInfoLabel;
- (IBAction)uploadButtonTapped:(id)sender;


@end

@implementation EDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	dao = [DAO sharedInstance];
	prefs = [GEPreferences sharedInstance];
	self.moc = dao.managedObjectContext;
	
	[self.textEditor setUsesRuler:YES];
	[self.translation1Editor setUsesRuler:YES];
	[self.translation2Editor setUsesRuler:YES];
	[self.translation3Editor setUsesRuler:YES];
	
	self.uploadInfoLabel.stringValue = @"Press button below to propagate local changes";
	// Register CloudKit notifications
	
	
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

#pragma mark - Notifications from CloudKit


- (void)application:(NSApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	CKNotification *cloudKitNotification = [CKNotification notificationFromRemoteNotificationDictionary:userInfo];
	if (cloudKitNotification.notificationType == CKNotificationTypeQuery) {
		CKQueryNotification *queryNotification = (CKQueryNotification *)cloudKitNotification;
		
		if (queryNotification.queryNotificationReason == CKQueryNotificationReasonRecordDeleted) {
			// If the record has been deleted in CloudKit then delete the local copy here
		} else {
			// If the record has been created or changed, we fetch the data from CloudKit
			CKDatabase *database;
			if (queryNotification.isPublicDatabase) {
				database = [[CKContainer defaultContainer] publicCloudDatabase];
			} else  {
				database = [[CKContainer defaultContainer] privateCloudDatabase];
			}
			[database fetchRecordWithID:queryNotification.recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
				if (error) {
					NSLog(@"Error during notification processing - %@", [error localizedDescription]);
				} else {
					if (queryNotification.queryNotificationReason == CKQueryNotificationReasonRecordUpdated) {
						// Use the information in the record object to modify your local data
					} else {
						// Use the information in the record object to create a new local object
					}
				}
			}];
		}
	}
}



#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    if (![[dao managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if ([[dao managedObjectContext] hasChanges] && ![[dao managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (IBAction)refreshDatePressed:(id)sender
{
	Paragraph *currentParagraph = [[self.sataController selectedObjects] objectAtIndex:0];
	currentParagraph.dateCreated = [NSDate date];
	NSError *error = nil;
	[dao.managedObjectContext processPendingChanges];
	[self.sataController fetchWithRequest:nil merge:YES error:&error];
	if (error) {
		NSLog(@"Cannot reload data - %@", [error localizedDescription]);
	}
	[self.sataController rearrangeObjects];
}

- (IBAction)checkLinkPressed:(id)sender
{
	// open Web page in separate process
	Paragraph *currentParagraph = [[self.sataController selectedObjects] objectAtIndex:0];
	NSURL *myURL = [NSURL URLWithString:currentParagraph.link];
	[[NSWorkspace sharedWorkspace] openURL:myURL];

}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[dao managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    
    if (![dao managedObjectContext]) {
        return NSTerminateNow;
    }
    
    if (![[dao managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[dao managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[dao managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertFirstButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}


- (IBAction) showFeedbackWindow:(id)sender
{
	if (!self.feedbackController) {
		self.feedbackController = [[FeedbackWindowController alloc] init];
	}
	[self.feedbackController showWindow:self];
}


- (IBAction)dateModificationTapped:(id)sender
{
	CGRect frame = self.dateSelectorButton.frame;
	// set up initial value from the selected Paragraph record
	NSArray *selObjects = self.sataController.selectedObjects;
	if (selObjects.count > 0) {
		selectedParagraph = selObjects[0];
		self.dateSelectorPicker.dateValue = selectedParagraph.dateCreated;
		[self.dateSelectorView showRelativeToRect:frame
										   ofView:self.window.contentView preferredEdge:NSMaxYEdge];
	}
	
}
- (IBAction)dateSelectorChanged:(id)sender
{
	selectedParagraph.dateCreated = self.dateSelectorPicker.dateValue;
	[self.dateSelectorView close];
	
}

- (IBAction)dateSelectorCanceled:(id)sender
{
	[self.dateSelectorView close];
}
- (IBAction)uploadButtonTapped:(id)sender
{
	NSError *error = nil;
	[dao clearWorkingArrays];
	[dao.managedObjectContext save:&error];
	if (!error) {
		[dao processCKUpdate];
	} else {
		NSLog(@"Error during database saving - %@", [error localizedDescription]);
	}
	NSBeep();
}

//
// Mark selected record to be deleted on client side
//

- (IBAction)markasDeleted:(id)sender
{
	NSArray *selObjects = self.sataController.selectedObjects;
	if (selObjects.count > 0) {
		selectedParagraph = selObjects[0];
		[selectedParagraph markAsDeleted];
	}
	[self.tableView reloadData];
}
@end
