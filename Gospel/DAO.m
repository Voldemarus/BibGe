//
//  DAO.m
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "DAO.h"
#import "DebugPrint.h"
#ifndef GOBIBLEEDITOR
#import "Preferences.h"
#endif

@interface DAO () {
#ifndef GOBIBLEEDITOR
	Preferences *prefs;
#endif
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
		error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
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
		NSCalendar *cal = [NSCalendar currentCalendar];
		for (NSInteger i = 0; i < 30; i++) {
			NSDate *newDate = [cal dateFromComponents:comps];
			comps.day++;
			NSString *title = [NSString stringWithFormat:@"saRvTo liturgia - %ld", (long)i];
			NSMutableString *newStr = [[NSMutableString alloc] initWithCapacity:30];
			NSMutableString *tr1 = [[NSMutableString alloc] initWithCapacity:20];
			NSMutableString *tr2 = [[NSMutableString alloc] initWithCapacity:20];
			NSMutableString *tr3 = [[NSMutableString alloc] initWithCapacity:20];
			
			for (NSInteger j = 0; j < 40; j++) {
				NSString *t = [NSString stringWithFormat:@"Record #%ld line %ld\n",(long)i,(long)j];
//				[newStr appendString:t];
				t = [NSString stringWithFormat:@"Translation %ld/1 line %ld\n",
					 (long) i, (long) j];
				[tr1 appendString:t];
				t = [NSString stringWithFormat:@"Translation %ld/2 line %ld\n",
					 (long) i, (long) j];
				[tr2 appendString:t];
				t = [NSString stringWithFormat:@"Translation %ld/3 line %ld\n",
					 (long) i, (long) j];
				[tr3 appendString:t];
				
			}
			
			newStr = @"imis gamo, rom Zveli qarTuli ena sagrZnoblad daSorda Tanamedrove qarTuls, saWirod miviCnieT, wminda ioane oqropiris saRvTo liturgia Zvelidan Tanamedrove qarTul enaze gadmogveRo. winamdebare Targmanis mizania, taZarSi misul mrevls gauadvildes wirvaze aRsrulebuli locvebisa da saga-loblebis gageba.";
			
			NSString *link = (i %2 ? @"http://armada.cardarmy.ru" : @"http://geomatix.sweb.cz");
			
			Paragraph *newRec = [Paragraph newObjectForParagraphTitle:title date:newDate linl:link andText:newStr inMoc:self.managedObjectContext];
			newRec.translation1 = tr1;
			newRec.translation2 = tr2;
			newRec.translation3 = tr3;
#pragma unused (newRec)
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
#endif
@end
