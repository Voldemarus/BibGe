//
//  DAO.m
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "DAO.h"
#import "DebugPrint.h"

@interface DAO ()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end

@implementation DAO

+ (instancetype) sharedInstance
{
	static DAO *_dao = nil;
	if (!_dao) {
		_dao = [[DAO alloc] init];
		[_dao createDemoSet];
	}
	return _dao;
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
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
	
	return _persistentStoreCoordinator;
}


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
			NSString *title = [NSString stringWithFormat: @"Article #%ld - წმინდა ბიბლიის შესახებ წმინდა ბიბლიის შესახებ წმინდა ბიბლიის შესახებ წმინდა ბიბლიის შესახებ წმინდა ბიბლიის შესახებ წმინდა ბიბლიის შესახებ!",(long)i];
			NSMutableString *newStr = [[NSMutableString alloc] initWithCapacity:30];
			for (NSInteger j = 0; j < 40; j++) {
				NSString *t = [NSString stringWithFormat:@"Record #%ld line %ld\n",(long)i,(long)j];
				[newStr appendString:t];
			}
			NSString *link = (i %2 ? @"http://armada.cardarmy.ru" : @"http://geomatix.sweb.cz");
			
			Paragraph *newRec = [Paragraph newObjectForParagraphTitle:title date:newDate linl:link andText:newStr inMoc:self.managedObjectContext];
#pragma unused (newRec)
		}
	}
	[self.managedObjectContext save:nil];
}


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




@end