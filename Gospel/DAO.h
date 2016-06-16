//
//  DAO.h
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#ifdef GOBIBLEEDITOR
#import <Cocoa/Cocoa.h>
#import "Feedback.h"
#import "DeletedObjects.h"
#else
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#endif
#import "Paragraph.h"

@interface DAO : NSObject

+ (instancetype) sharedInstance;

#ifndef GOBIBLEEDITOR
- (NSFetchedResultsController *) fetchedController;
- (void) resetTrackingIndexes;
- (void) updatePersistentCoordinator;

- (void) sendFeedbackFrom:(NSString *)address withMessae:(NSString *)aMessage
			andDeviceInfo:(NSString *)aDevInfo;

- (void)subscribeToBibleArticleChanges;
#else
- (void)subscribeToFeedbackChanges;

- (void) addToInsertArray:(CKRecord *)newRecord;
- (void) addToUpdateArray:(Paragraph *) updateParagraph;
- (void) clearWorkingArrays;
- (void) processCKUpdate;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *feedbackPersistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *feedbackManagedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *feedbackMoc;

#endif

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
