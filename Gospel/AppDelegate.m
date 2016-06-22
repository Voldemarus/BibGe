//
//  AppDelegate.m
//  Gospel
//
//  Created by AAA_Develooper on 18/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "AppDelegate.h"
#import "Preferences.h"
#import "DAO.h"
#import "DebugPrint.h"

@interface AppDelegate () {
	Preferences *prefs;
	DAO *dao;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	dao = [DAO sharedInstance];
	prefs = [Preferences sharedInstance];
	
	// Register CloudKit notifications
	UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
	[application registerUserNotificationSettings:notificationSettings];
	[application registerForRemoteNotifications];
	
	
	// subscribe to notification
	[dao checkAndUpdateArticles];
	

	return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	CKNotification *cloudKitNotification = [CKNotification notificationFromRemoteNotificationDictionary:userInfo];
	if (cloudKitNotification.notificationType == CKNotificationTypeQuery) {
		CKQueryNotification *queryNotification = (CKQueryNotification *)cloudKitNotification;
		
		if (queryNotification.queryNotificationReason == CKQueryNotificationReasonRecordDeleted) {
			// If the record has been deleted in CloudKit then delete the local copy here
		} else {
			// If the record has been created or changed, we fetch the data from CloudKit
			CKDatabase *database;
			if (queryNotification.isPublicDatabase) {
				database = [[CKContainer defaultContainer] publicCloudDatabase];
			} else  {
				database = [[CKContainer defaultContainer] privateCloudDatabase];
			}
			[database fetchRecordWithID:queryNotification.recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
				if (error) {
					// Handle the error here
					DLog(@"error - %@",error);
				} else {
					if (queryNotification.queryNotificationReason == CKQueryNotificationReasonRecordUpdated) {
						// Use the information in the record object to modify your local data
					} else {
						// Use the information in the record object to create a new local object
						DLog(@"recordId - %@",record.recordID.recordName);
					}
				}
			}];
		}
	}
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[Preferences sharedInstance] flush];
	[self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[[DAO sharedInstance] checkAndUpdateArticles];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
	[[Preferences sharedInstance] flush];
	[self saveContext];
}

- (void) saveContext
{
	[[DAO sharedInstance].managedObjectContext save:nil];
}

@end
