//
//  DAO.h
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#import "Paragraph.h"

@interface DAO : NSObject

+ (instancetype) sharedInstance;

- (NSFetchedResultsController *) fetchedController;
- (void) resetTrackingIndexes;

- (void) updatePersistentCoordinator;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
