//
//  FeedbackWindowController.h
//  Gospel
//
//  Created by Водолазкий В.В. on 05.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Dao.h"

@interface FeedbackWindowController : NSWindowController

@property (nonatomic, retain) NSManagedObjectContext *feedbackMoc;

@end
