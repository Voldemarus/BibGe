//
//  ContentViewController.h
//  Gospel
//
//  Created by AAA_Develooper on 20/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController <NSLayoutManagerDelegate, UIDocumentInteractionControllerDelegate>


- (IBAction)openShareActivirtform:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *uv1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *titleUnderlineImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleUnderlineLabel;

@property (weak, nonatomic) IBOutlet UIButton *tab1;
@property (weak, nonatomic) IBOutlet UIButton *tab2;
@property (weak, nonatomic) IBOutlet UIButton *tab3;

// Share controller
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;


@end
