//
//  MainTableViewCell.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "MainTableViewCell.h"
@interface MainTableViewCell()
//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
//活动名字
@property (weak, nonatomic) IBOutlet UILabel *activityNameLable;
//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPrice;
//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistance;


@end
@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
