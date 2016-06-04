//
//  FeedbackViewController.h
//  Gospel
//
//  Created by Водолазкий В.В. on 03.06.16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *mwssageLabel;
@property (weak, nonatomic) IBOutlet UITextField *mailAddressField;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

@property (nonatomic, retain) NSString *deviceInfo;
@property (nonatomic, retain) NSString *initialText;

- (IBAction)sendMessageButtonTapped:(id)sender;

@end
