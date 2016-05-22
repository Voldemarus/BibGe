//
//  Paragraph.h
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Paragraph : NSManagedObject

+ (Paragraph *)newObjectForParagraphTitle:(NSString *)aTitle date:(NSDate *)aDate linl:(NSString *)aLink andText:(NSString *)aText inMoc:(NSManagedObjectContext *)moc;


- (NSString *) dateCreatedAsString;


@end

NS_ASSUME_NONNULL_END

#import "Paragraph+CoreDataProperties.h"
