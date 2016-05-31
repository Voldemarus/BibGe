//
//  InfoViewController.m
//  Gospel
//
//  Created by Водолазкий В.В. on 31.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import "InfoViewController.h"
#import "Preferences.h"
#import "DebugPrint.h"

#define INFO_FILE_NAME		@"InfoText"		
#define INFO_FILE_EXT		@"rtf"

@interface InfoViewController () {
	Preferences *prefs;
}
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end

@implementation InfoViewController

- (id) init
{
	if (self = [super initWithNibName:[[self class] description] bundle:nil]) {
		prefs = [Preferences sharedInstance];
	}
	return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	// load file into textvies
	NSBundle *mb = [NSBundle mainBundle];
	NSURL *url = [mb URLForResource:INFO_FILE_NAME withExtension:INFO_FILE_EXT];
	if (url) {
		// file is found
		NSError *error = nil;
		NSData *data = [[NSFileManager defaultManager] contentsAtPath:[url path]];
		NSAttributedString *infoString = [[NSAttributedString alloc] initWithData:data
								options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType}
									  documentAttributes:nil
						   error:&error];
		if (!error) {
			self.infoTextView.attributedText = infoString;
			// set up theme colors
			self.infoTextView.backgroundColor = prefs.themeBackgroundColor;
			self.infoTextView.textColor = prefs.themeTextColor;
		} else {
			DLog(@"cannot load infoString from file - %@", [error localizedDescription]);
		}
		self.navigationController.title = RStr(@"About application");
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
