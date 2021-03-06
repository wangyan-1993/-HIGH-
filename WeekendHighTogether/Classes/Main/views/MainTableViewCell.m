//
//  MainTableViewCell.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>

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
//在model的set方法中 赋值
- (void)setModel:(MainModel *)model{
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:model.image_big] placeholderImage:nil];
    self.activityNameLable.text = model.title;
    self.activityPrice.text = model.price;
    
       NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];
    
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:[lat floatValue]  longitude:[lng floatValue]];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:model.lat longitude:model.lng];
    
    CLLocationDistance kilometers=[dist distanceFromLocation:orig]/1000;
    [self.activityDistance setTitle:[NSString stringWithFormat:@"%.fKm", kilometers] forState:UIControlStateNormal ];
  
    if ([model.type integerValue] != RecommedTypeActivity) {
        self.activityDistance.hidden = YES;
    } else{
        self.activityDistance.hidden = NO;
    }

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
