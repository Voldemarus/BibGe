//
//  DeletedObjects.m
//  Gospel
//
//  Created by Водолазкий В.В. on 15.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "DeletedObjects.h"
#import "DAO.h"
#import "DebugPrint.h"

@implementation DeletedObjects

+ (DeletedObjects *) addDeletedObject:(CKRecordID *)recId withType:(NSString *)aString
{
	NSManagedObjectContext *moc = [DAO sharedInstance].managedObjectContext;
	NSString *entName = [[self class] description];
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:entName];
	req.predicate = [NSPredicate predicateWithFormat:@"recordID = %@",recId];
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:req error:&error];
	if (!result && error) {
		DLog(@"Error during request to DeletedObject - %@", [error localizedDescription]);
		return nil;
	} else {
		// Prevent creation several record with same ID
		if (result.count > 0) {
			return result[0];
		}
	}
	DeletedObjects *newObj = [NSEntityDescription insertNewObjectForEntityForName:entName inManagedObjectContext:moc];
	if (newObj) {
		newObj.recordID = recId;
		newObj.recordType = aString;
	}
	return newObj;
}


@end
