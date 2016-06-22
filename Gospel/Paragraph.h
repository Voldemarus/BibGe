//
//  Paragraph.h
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>
#import "DeletedObjects.h"

NS_ASSUME_NONNULL_BEGIN

@interface Paragraph : NSManagedObject

+ (Paragraph *)newObjectForParagraphTitle:(NSString *)aTitle date:(NSDate *)aDate linl:(NSString *)aLink  inMoc:(NSManagedObjectContext *)moc;

+ (Paragraph *) getOrCreateParagraphForRecordId:(CKRecordID *)recordId
										 inMoc:(NSManagedObjectContext *)moc;

- (NSString *) dateCreatedAsString;
- (CKRecord *) newCloudKitRecord;			// Returns new record, if no ID is stored

- (void) markAsDeleted;						// mark current record as Deleted

@end

NS_ASSUME_NONNULL_END

#import "Paragraph+CoreDataProperties.h"
