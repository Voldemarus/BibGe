//
//  ContentViewController.h
//  Gospel
//
//  Created by AAA_Develooper on 20/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dao.h"
#import "Paragraph.h"


@interface ContentViewController : UIViewController <NSLayoutManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,
	UIScrollViewDelegate>


- (IBAction)openShareActivirtform:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tab1;
@property (weak, nonatomic) IBOutlet UIButton *tab2;
@property (weak, nonatomic) IBOutlet UIButton *tab3;

@property (strong, nonatomic) Paragraph *par;
@property (copy, nonatomic) NSIndexPath *indexPath;

// navigation bar elements

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

// Share controller
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;


@end
