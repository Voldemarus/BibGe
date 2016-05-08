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


@interface ContentViewController : UIViewController <NSLayoutManagerDelegate, UITableViewDelegate, UITableViewDataSource>


- (IBAction)openShareActivirtform:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tab1;
@property (weak, nonatomic) IBOutlet UIButton *tab2;
@property (weak, nonatomic) IBOutlet UIButton *tab3;

@property (strong, nonatomic) Paragraph *par;

// Share controller
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;


@end
