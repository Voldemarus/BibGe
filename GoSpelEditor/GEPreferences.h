//
//  GEPreferences.h
//  Gospel
//
//  Created by Водолазкий В.В. on 05.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const VVVupdateFeedbackTable;
extern NSString * const VVVupdateParagraphTable;

@interface GEPreferences : NSObject

+ (GEPreferences *) sharedInstance;

@property (nonatomic, retain) NSDate *lastFeedbackDate;
@property (nonatomic, readwrite) BOOL subscribedToCloudKit;

@property (nonatomic, retain) NSDate *lastUpdateDate;

@end
