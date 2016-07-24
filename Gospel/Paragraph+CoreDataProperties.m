//
//  Paragraph+CoreDataProperties.m
//  Gospel
//
//  Created by Водолазкий В.В. on 15.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Paragraph+CoreDataProperties.h"

@implementation Paragraph (CoreDataProperties)

@dynamic dateCreated, dateDeleted;
@dynamic link;
@dynamic text;
@dynamic title;
@dynamic translation1;
@dynamic translation2;
@dynamic translation3;
@dynamic viewed;
@dynamic recordID;
@dynamic textOffset, translation1Offset, translation2Offset, translation3Offset;

@end
