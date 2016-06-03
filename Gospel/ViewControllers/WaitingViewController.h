//
//  WaitingViewController.h
//  Gospel
//
//  Created by Водолазкий В.В. on 11.05.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void) showOnScreen;
- (void) hideFromScreen;

@end
