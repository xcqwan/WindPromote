//
//  PromoteCell.h
//  WindPromote
//
//  Created by Zombie on 8/8/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoteCell : UITableViewCell

@property NSDictionary *data;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;

@end
