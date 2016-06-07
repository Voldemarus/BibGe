//
//  Feedback.m
//  Gospel
//
//  Created by Водолазкий В.В. on 05.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "Feedback.h"
#import "DebugPrint.h"

@implementation Feedback

+ (Feedback *) getOrCreateFeedbackForRecordId:(NSString *)aRecordId
										inMoc:(NSManagedObjectContext *)moc
{
	NSString *entityName = [[self class] description];
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:entityName];
	req.predicate = [NSPredicate predicateWithFormat:@"recordID = %@", aRecordId];
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:req error:&error];
	if (!result && error) {
		DLog(@"Cannot get data - %@ ==> %@",req, [error localizedDescrioption]);
		return nil;
	}
	if (result.count > 0) {
		return result[0];
	}
	Feedback *newRecord  = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
	if (newRecord) {
		newRecord.recordID = aRecordId;
	}
	return newRecord;
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%@ : %@ (%@) %@",
			[self class], self.userAddress, self.timestamp, self.deviceInfo];
}


- (NSString *) timeString{
	static NSDateFormatter *df = nil;
	if (!df) {
		df = [[NSDateFormatter alloc] init];
		// "Apr 04, 2016 11:22 PM"  -- fateFormat
		NSLocale *                  enUSPOSIXLocale;
		enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
		[df setLocale:enUSPOSIXLocale];
		[df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
		[df setDateFormat:@"MMM dd, yyyy hh:mm aaa"];
	}
	return [df stringFromDate:self.timestamp];
}

@end
