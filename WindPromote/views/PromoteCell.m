//
//  PromoteCell.m
//  WindPromote
//
//  Created by Zombie on 8/8/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "PromoteCell.h"

@implementation PromoteCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *phone = [_data valueForKey:@"phone"];
    NSString *create = [_data valueForKey:@"create_time"];
    NSString *name = [_data valueForKey:@"name"];
    NSNumber *num = [_data valueForKey:@"daily_order_num"];
    NSString *hasOrder = [_data valueForKey:@"is_taken_out"];
    NSString *interested = [_data valueForKey:@"interested"];
    
    _phoneLabel.text = phone;
    NSLog(@"%@", _data);
    if ([name isEqual:[[NSNull alloc] init]]) {
        name = @"";
    }
    _titleLabel.text = name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate *localDate = [formatter dateFromString:create];
    formatter.dateFormat = @"MM月dd日 HH:MM";
    NSString *createdTime = [formatter stringFromDate:localDate];
    
    _createdLabel.text = createdTime;
    
    if (!hasOrder.boolValue) {
        //没外卖
        _orderFlagImageView.hidden = true;
        _orderNumLabel.hidden = true;
        _orderNumTextLabel.hidden = true;
    } else {
        //有外卖
        _orderFlagImageView.hidden = false;
        _orderNumLabel.hidden = false;
        _orderNumTextLabel.hidden = false;
        _orderNumLabel.text = [NSString stringWithFormat:@"%@", num];
    }
    
    if (interested.boolValue) {
        //感兴趣
        _startImageView.hidden = false;
        CGRect frame = _titleLabel.frame;
        frame.origin.x = 40;
        _titleLabel.frame = frame;
    } else {
        //不感兴趣
        _startImageView.hidden = true;
        CGRect frame = _titleLabel.frame;
        frame.origin.x = 20;
        _titleLabel.frame = frame;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
