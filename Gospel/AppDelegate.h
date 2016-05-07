//
//  AppDelegate.h
//  Gospel
//
//  Created by AAA_Develooper on 18/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

