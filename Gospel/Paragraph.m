//
//  Paragraph.m
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//


#ifdef GOBIBLEEDITOR
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif
#import "Paragraph.h"
#import "DebugPrint.h"
#import "DAO.h"

#define CK_RECORD_TYPE	@"BibleArticle"

@implementation Paragraph

#ifdef GOBIBLEEDITOR
- (void)awakeFromInsert
{
	[super awakeFromInsert];
	self.dateCreated = [NSDate date];
	self.title = @"New Record";
}

- (void) willSave
{
	[super willSave];
	if (self.isDeleted) {
		if (self.recordID) {
			// This record just have proper ID to Delete from Server storage
			// if no record ID is present - it means that record was not saved (se nd to server)
			[DeletedObjects addDeletedObject:self.recordID withType:CK_RECORD_TYPE];
		}
	} else if (self.isInserted) {
		// Create new CKRecord and fill it with current fields
		[[DAO sharedInstance] addToInsertArray:self.newCloudKitRecord];
	} else if (self.isUpdated) {
		// Get CKRecord for modified record and update it fields
		[[DAO sharedInstance] addToUpdateArray:self];
	}
}

#endif


+ (Paragraph *)newObjectForParagraphTitle:(NSString *)aTitle date:(NSDate *)aDate linl:(NSString *)aLink  inMoc:(NSManagedObjectContext *)moc
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Paragraph"];
	req.predicate = [NSPredicate predicateWithFormat:@"title = %@",aTitle];
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:req error:&error];
	
	Paragraph *newParagraph = nil;
	if (!result && error) {
		DLog(@"Error - during request %@ ---> %@",req, [error localizedDescription]);
		return nil;
	} if (result.count > 0) {
		newParagraph = result[0];
	} else {
		newParagraph = [NSEntityDescription insertNewObjectForEntityForName:@"Paragraph" inManagedObjectContext:moc];
	}
	if (newParagraph) {
		newParagraph.title = aTitle;
		newParagraph.dateCreated = aDate;
		newParagraph.link = aLink;
		newParagraph.viewed = @(0);
	}
	return newParagraph;
}

- (NSString *) dateCreatedAsString
{
	static NSDateFormatter *df = nil;
	if (!df) {
		df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"dd MMM YYYY"];
	}
	return [df stringFromDate:self.dateCreated];
}


- (CKRecord *) newCloudKitRecord
{
	if (self.recordID) {
		return nil;			// This instance just was placed to CK
	}
	
	// Create record with automatically assigned RecordID
	CKRecord *newRecrod = [[CKRecord alloc] initWithRecordType:@"BibleArticle"];
	if (newRecrod) {
		// store record ID
		self.recordID = newRecrod.recordID;
		// fill fields in record
		newRecrod[@"dateCreated"] = self.dateCreated;
		newRecrod[@"link"] = self.link;
		
		newRecrod[@"text"] =  [NSKeyedArchiver archivedDataWithRootObject:self.text];
		newRecrod[@"title"] = self.title;
		newRecrod[@"trans1"] =  [NSKeyedArchiver archivedDataWithRootObject:self.translation1];
		newRecrod[@"trans2"] =  [NSKeyedArchiver archivedDataWithRootObject:self.translation2];
		newRecrod[@"trans3"] =  [NSKeyedArchiver archivedDataWithRootObject:self.translation3];
	}
	return newRecrod;
}


- (NSString *)description
{
	return [NSString stringWithFormat:@"Paragraph: title = %@ date = %@",
			self.title, self.dateCreated];
}


@end
