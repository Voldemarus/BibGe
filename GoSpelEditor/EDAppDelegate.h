//
//  AppDelegate.h
//  GoSpelEditor
//
//  Created by Водолазкий В.В. on 17.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Dao.h"
#import "FeedbackWindowController.h"

@interface EDAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, assign) IBOutlet NSManagedObjectContext *moc;
@property (weak) IBOutlet NSTableView *tableView;
- (IBAction)markasDeleted:(id)sender;

@property (nonatomic, retain) NSFont *georgianFont;

@property (nonatomic, retain) FeedbackWindowController *feedbackController;




@end

