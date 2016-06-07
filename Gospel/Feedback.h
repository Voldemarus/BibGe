//
//  Feedback.h
//  Gospel
//
//  Created by Водолазкий В.В. on 05.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Feedback : NSManagedObject

+ (Feedback *) getOrCreateFeedbackForRecordId:(NSString *)aRecordId
										inMoc:(NSManagedObjectContext *)moc;

@property (nonatomic, readonly) NSString *timeString;
@end

NS_ASSUME_NONNULL_END

#import "Feedback+CoreDataProperties.h"
