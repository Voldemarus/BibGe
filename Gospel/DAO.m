//
//  DAO.m
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "DAO.h"
#import "DebugPrint.h"
#ifdef GOBIBLEEDITOR
#import "GEPreferences.h"
#else
#import "Preferences.h"
#import <CloudKit/CloudKit.h>
#endif

@interface DAO () {
#ifndef GOBIBLEEDITOR
	Preferences *prefs;
#else 
	GEPreferences *prefs;
	NSManagedObjectModel *_feedbackManagedObjectModel;
	NSPersistentStoreCoordinator *_feedbackPersistentStoreCoordinator;
#endif
	CKContainer *container;
	CKDatabase *publicDatabase;
	CKDatabase *privateDatabase;
}

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end

@implementation DAO



+ (instancetype) sharedInstance
{
	static DAO *_dao = nil;
	if (!_dao) {
		_dao = [[DAO alloc] init];
	}
	return _dao;
}


- (id) init
{
	if (self = [super init]) {
		[self createDemoSet];
		container = [CKContainer containerWithIdentifier:@"iCloud.com.alex.Gospel"];
		publicDatabase = [container publicCloudDatabase];
		privateDatabase = [container privateCloudDatabase];
#ifndef GOBIBLEEDITOR
		prefs = [Preferences sharedInstance];
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(persistentStoreChanged:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:nil];
		
		[nc addObserverForName:NSPersistentStoreCoordinatorStoresWillChangeNotification
		 object:self.managedObjectContext.persistentStoreCoordinator
		 queue:[NSOperationQueue mainQueue]
		 usingBlock:^(NSNotification *note) {
			 [[NSNotificationCenter defaultCenter] postNotificationName:VVVcloudSyncInProgress object:nil];
			 // disable user interface with setEnabled: or an overlay
			 [self.managedObjectContext performBlock:^{
				 if ([self.managedObjectContext hasChanges]) {
					 NSError *saveError;
					 if (![self.managedObjectContext save:&saveError]) {
						 NSLog(@"Save error: %@", saveError);
					 }
				 } else {
					 // drop any managed object references
					 [self.managedObjectContext reset];
				 }
			 }];
		 }];
		
		[nc addObserverForName:NSPersistentStoreDidImportUbiquitousContentChangesNotification
		 object:self.managedObjectContext.persistentStoreCoordinator
		 queue:[NSOperationQueue mainQueue]
		 usingBlock:^(NSNotification *note) {
			 [self.managedObjectContext performBlock:^{
				 [self.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
				 [[NSNotificationCenter defaultCenter] postNotificationName:VVVpersistentStoreChanged object:nil];
			 }];
		 }];
		// Init CloudKit connectors
//		// Now we try to load data from CloudKit
//		 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
//		CKQuery *query = [[CKQuery alloc] initWithRecordType:@"BibleArticle"
//												   predicate:predicate];
//		[publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
//			if (!error) {
//				DLog(@"%@", results);
//			} else {
//				DLog(@"%@", error);
//			}
//		}];
#else
		prefs = [GEPreferences sharedInstance];
		[self updateFeedback];
#endif
	}
	return self;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
	// The directory the application uses to store the Core Data store file. This code uses a directory named "com.alex.Gospel" in the application's documents directory.
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
	// The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Gospel" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

#ifdef GOBIBLEEDITOR

- (NSManagedObjectModel *)feedbackManagedObjectModel {
	// The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
	if (_feedbackManagedObjectModel != nil) {
		return _feedbackManagedObjectModel;
	}
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Feedback" withExtension:@"momd"];
	_feedbackManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _feedbackManagedObjectModel;
}

- (NSPersistentStoreCoordinator *)feedbackPersistentStoreCoordinator {
	// The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
	if (_feedbackPersistentStoreCoordinator != nil) {
		return _feedbackPersistentStoreCoordinator;
	}
	
	// Create the coordinator and store
	
	_feedbackPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self feedbackManagedObjectModel]];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GospelFeedback.sqlite"];
	NSError *error = nil;
	NSString *failureReason = @"There was an error creating or loading the application's saved data.";
	if (![_feedbackPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
			// Report any error we got.
			NSMutableDictionary *dict = [NSMutableDictionary dictionary];
			dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
			dict[NSLocalizedFailureReasonErrorKey] = failureReason;
			dict[NSUnderlyingErrorKey] = error;
			error = [NSError errorWithDomain:@"GoSpelErrorDomain" code:9999 userInfo:dict];
			// Replace this with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		return _feedbackPersistentStoreCoordinator;
	}

- (NSManagedObjectContext *)feedbackMoc
{
	// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
	if (_feedbackMoc != nil) {
		return _feedbackMoc;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self feedbackPersistentStoreCoordinator];
	if (!coordinator) {
		return nil;
	}
	_feedbackMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	[_feedbackMoc setPersistentStoreCoordinator:coordinator];
	return _feedbackMoc;
}


- (void) updateFeedback
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateCreated > %@",prefs.lastFeedbackDate];
	CKQuery *query = [[CKQuery alloc] initWithRecordType:@"FeedBack" predicate:predicate];
	[publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
	if (!error) {
		 DLog(@"%@", results);
		NSDate *lastDate = prefs.lastFeedbackDate;
		for (CKRecord *record in results) {
			// iterate through received data
			NSString *addres = record[@"userAddress"];
			NSDate *dateCreated = record[@"dateCreated"];
			NSString *message = record[@"message"];
			NSString *deviceInfo = record[@"isVersion"];
			NSString *recordId = record.recordID.recordName;
			Feedback *feedbackRecord = [Feedback getOrCreateFeedbackForRecordId:recordId inMoc:self.feedbackMoc];
			if (feedbackRecord) {
				feedbackRecord.userAddress = addres;
				feedbackRecord.timestamp = dateCreated;
				feedbackRecord.message = message;
				feedbackRecord.deviceInfo = deviceInfo;
				lastDate = [lastDate laterDate:dateCreated];
			}
		}
		NSError *error = nil;
		[self.feedbackMoc save:&error];
		if (!error) {
			prefs.lastFeedbackDate = lastDate;
			[[NSNotificationCenter defaultCenter] postNotificationName:VVVupdateFeedbackTable object:nil];
		}
		
	 } else {
		 DLog(@"%@", error);
	 }
 }];
}


#endif

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	// The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	// Create the coordinator and store
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Gospel.sqlite"];
	NSError *error = nil;
	NSString *failureReason = @"There was an error creating or loading the application's saved data.";
#ifdef GOBIBLEEDITOR
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
#else
	
	NSDictionary *options = (prefs.storeInCloud ?
							 @{NSPersistentStoreUbiquitousContentNameKey: @"MyAppCloudStore",
							   NSMigratePersistentStoresAutomaticallyOption: @YES,
							   NSInferMappingModelAutomaticallyOption: @YES} :
							 @{ NSMigratePersistentStoresAutomaticallyOption: @YES,
							   NSInferMappingModelAutomaticallyOption: @YES}
							 );
	DLog(@"options fot store = %@", options);
	NSPersistentStore *actualStore= [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
	if (!actualStore) {
#endif
		// Report any error we got.
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
		dict[NSLocalizedFailureReasonErrorKey] = failureReason;
		dict[NSUnderlyingErrorKey] = error;
		error = [NSError errorWithDomain:@"GoSpelErrorDomain" code:9999 userInfo:dict];
		// Replace this with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
#ifndef GOBIBLEEDITOR
	NSURL *actualURL = [actualStore URL];
	DLog(@"actualURL = %@", actualURL);
#endif
	return _persistentStoreCoordinator;
}

#ifndef GOBIBLEEDITOR
- (void) updatePersistentCoordinator
{
	NSError *error = nil;
	[self.managedObjectContext save:&error];
	if (error) {
		DLog(@"Cannot save context - %@",[error localizedDescription]);
	} else {
		_persistentStoreCoordinator = nil;	// remove old persistent store reference to force new initialization
		_managedObjectContext = nil;
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVpersistentStoreChanged object:nil];
	}
}
#endif


- (NSManagedObjectContext *)managedObjectContext {
	// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (!coordinator) {
		return nil;
	}
	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	if (managedObjectContext != nil) {
		NSError *error = nil;
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

#pragma mark - 

- (void) createDemoSet
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Paragraph"];
	NSError *error = nil;
	NSInteger count = [self.managedObjectContext countForFetchRequest:req error:&error];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	comps.year = 2016;
	comps.day = 1;
	comps.month = 3;
	if (count == 0) {
		NSBundle *mb = [ NSBundle mainBundle];

		NSCalendar *cal = [NSCalendar currentCalendar];
		for (NSInteger i = 1; i < 9; i++) {
			NSDate *newDate = [cal dateFromComponents:comps]; // for demo only!
			comps.day++;
			NSString *title = [NSString stringWithFormat:@"%ld იანვარი", (long)i];
			NSString *articleName = [NSString stringWithFormat:@"article%ld",(long)i];
			NSURL *url = [mb URLForResource:articleName withExtension:@"rtf"];
			
			NSData *data = [[NSFileManager defaultManager] contentsAtPath:[url path]];
			// attributed string can be stored in warehouse as such due to transformation
			NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType};
			NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
													 initWithData:data
													 options:options
													 documentAttributes:nil
													 error:nil];

			NSString *link = (i %2 ? @"http://armada.cardarmy.ru" : @"http://geomatix.sweb.cz");
			Paragraph *newRec = [Paragraph newObjectForParagraphTitle:title date:newDate linl:link  inMoc:self.managedObjectContext];
			newRec.text = attrString;
			newRec.translation1 = attrString;
			newRec.translation2 = attrString;
			newRec.translation3 = attrString;
		}
	}
	[self.managedObjectContext save:nil];
}

#ifndef GOBIBLEEDITOR
- (NSFetchedResultsController *) fetchedController
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Paragraph"];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]];
	NSFetchedResultsController *rc =
							[[NSFetchedResultsController alloc] initWithFetchRequest:req
										managedObjectContext:self.managedObjectContext
										 sectionNameKeyPath:nil cacheName:nil];
	if (rc) {
		NSError *error = nil;
		[rc performFetch:&error];
		if (error) {
			DLog(@"Error during fetch - %@ --> %@", req, [error localizedDescription]);
			return nil;
		}
	}
	return rc;
}


- (void) resetTrackingIndexes
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Paragraph"];
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!result && error) {
		return;
	}
	for (Paragraph *p in result) {
		p.viewed = @(0);
	}
	[self.managedObjectContext save:nil];
}


#pragma mark - Selectors -

- (void) persistentStoreChanged:(NSNotification *)note
{
	if (self.managedObjectContext) {
		[self.managedObjectContext reset];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:VVVpersistentStoreChanged object:nil];
}
	
#pragma mark - Client side CloudKit support -
	
- (void) sendFeedbackFrom:(NSString *)address withMessae:(NSString *)aMessage andDeviceInfo:(NSString *)aDevInfo
{
	if (!address || !aMessage) return;
	// Will use default Record ID generation
	CKRecord *postRecrod = [[CKRecord alloc] initWithRecordType:@"FeedBack"];
	postRecrod[@"userAddress"] = address;
	postRecrod[@"message"] = aMessage;
	postRecrod[@"isVersion"] = aDevInfo;
	postRecrod[@"dateCreated"] = [NSDate date];
	[publicDatabase saveRecord:postRecrod completionHandler:^(CKRecord *record, NSError *error) {
	 if(error) {
		 NSLog(@"%@", error);
	 } else {
		 NSLog(@"Saved successfully");
	 }
 }];
}
	
	
	
#endif
	
@end
