//
//  Paragraph+CoreDataProperties.h
//  Gospel
//
//  Created by Водолазкий В.В. on 15.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Paragraph.h"

NS_ASSUME_NONNULL_BEGIN

@interface Paragraph (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSDate *dateDeleted;
@property (nullable, nonatomic, retain) id text;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) id translation1;
@property (nullable, nonatomic, retain) id translation2;
@property (nullable, nonatomic, retain) id translation3;
@property (nullable, nonatomic, retain) NSNumber *viewed;
@property (nullable, nonatomic, retain) CKRecordID *recordID;

@end

NS_ASSUME_NONNULL_END
