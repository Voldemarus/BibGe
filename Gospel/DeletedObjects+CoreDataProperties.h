//
//  DeletedObjects+CoreDataProperties.h
//  Gospel
//
//  Created by Водолазкий В.В. on 15.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DeletedObjects.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeletedObjects (CoreDataProperties)

@property (nullable, nonatomic, retain) CKRecordID *recordID;
@property (nullable, nonatomic, retain) NSString *recordType;

@end

NS_ASSUME_NONNULL_END
