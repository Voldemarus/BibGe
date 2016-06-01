//
//  Paragraph.m
//  Gospel
//
//  Created by Водолазкий В.В. on 07.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "Paragraph.h"
#import "DebugPrint.h"

@implementation Paragraph

#ifdef GOBIBLEEDITOR
- (void)awakeFromInsert
{
	[super awakeFromInsert];
	self.dateCreated = [NSDate date];
	self.title = @"New Record";
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



- (NSString *)description
{
	return [NSString stringWithFormat:@"Paragraph: title = %@ date = %@",
			self.title, self.dateCreated];
}


@end
