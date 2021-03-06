//
//  ListTableViewCell.h
//  Gospel
//
//  Created by AAA_Develooper on 19/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressCircleView.h"

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel     *txtTitle;
@property (weak, nonatomic) IBOutlet UILabel     *txtDetail;

@property (weak, nonatomic) IBOutlet ProgressCircleView *progressCircle;
@end
