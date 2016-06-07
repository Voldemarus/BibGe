//
//  Feedback+CoreDataProperties.h
//  Gospel
//
//  Created by Водолазкий В.В. on 05.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Feedback.h"

NS_ASSUME_NONNULL_BEGIN

@interface Feedback (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSString *userAddress;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) NSString *deviceInfo;
@property (nullable, nonatomic, retain) CKRecordID *recordID;

@end

NS_ASSUME_NONNULL_END
