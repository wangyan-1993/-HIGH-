//
//  GoodActivityTableViewCell.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/8.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "GoodActivityTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodActivityTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLable;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;

@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UIImageView *ageBgImageView;

@end


@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kWidth, 90);
    self.activityTitleLable.numberOfLines = 0;
}

- (void)setGoodModel:(GoodActivityModel *)goodModel{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodModel.image]] placeholderImage:nil];
    self.activityTitleLable.text = [NSString stringWithFormat:@"%@", goodModel.title];
    self.activityPriceLable.text = [NSString stringWithFormat:@"%@", goodModel.price];
    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%@",goodModel.counts] forState:UIControlStateNormal];
    self.ageLable.text =  goodModel.age;
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];
   
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:[lat floatValue]  longitude:[lng floatValue]];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:goodModel.lat longitude:goodModel.lng];
    
    CLLocationDistance kilometers=[dist distanceFromLocation:orig]/1000;
    self.activityDistanceLable.text = [NSString stringWithFormat:@"%.fKm", kilometers];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
