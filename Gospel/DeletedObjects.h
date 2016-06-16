//
//  DeletedObjects.h
//  Gospel
//
//  Created by Водолазкий В.В. on 15.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeletedObjects : NSManagedObject

// Register object to delete from CK storage and from all IOS devices
+ (DeletedObjects *) addDeletedObject:(CKRecordID *)recId withType:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END

#import "DeletedObjects+CoreDataProperties.h"
