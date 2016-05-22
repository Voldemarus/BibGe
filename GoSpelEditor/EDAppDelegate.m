//
//  AppDelegate.m
//  GoSpelEditor
//
//  Created by Водолазкий В.В. on 17.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "EDAppDelegate.h"

@interface EDAppDelegate () {
	DAO *dao;
}


@property (weak) IBOutlet NSArrayController *sataController;

@property (weak) IBOutlet NSWindow *window;
- (IBAction)saveAction:(id)sender;

- (IBAction)refreshDatePressed:(id)sender;
- (IBAction)checkLinkPressed:(id)sender;

@property (weak) IBOutlet NSTextField *creationDateLabel;
@property (weak) IBOutlet NSTextField *recordTitleField;
@property (weak) IBOutlet NSTextField *linkTextField;

@end

@implementation EDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	dao = [DAO sharedInstance];
	self.moc = dao.managedObjectContext;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

#pragma mark - Core Data stack


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
	self.creationDateLabel.stringValue = [currentParagraph dateCreatedAsString];
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

@end
