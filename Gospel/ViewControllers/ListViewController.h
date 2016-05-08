//
//  ListViewController.h
//  Gospel
//
//  Created by AAA_Develooper on 19/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeTuneViewController.h"

@interface ListViewController : UIViewController

@property (nonatomic, retain) ThemeTuneViewController *tuneController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
