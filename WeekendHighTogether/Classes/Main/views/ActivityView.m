//
//  ActivityView.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/7.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityView()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLable;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressLable;
@property (weak, nonatomic) IBOutlet UILabel *activityPhoneLable;
@end


@implementation ActivityView
- (void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 1000);
}

//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    //活动图片
    NSArray *urls = dataDic[@"urls"];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    //活动标题
    self.activityTitleLable.text = dataDic[@"title"];
    self.favoriteLable.text = [NSString stringWithFormat:@"%@人已收藏", dataDic[@"fav"]];
    //活动价格
    self.activityPriceLable.text = dataDic[@"pricedesc"];
    //活动地址
    self.activityAddressLable.text = dataDic[@"address"];
    //活动联系电话
    self.activityPhoneLable.text = dataDic[@"tel"];
    //活动起止时间
    NSString *startTime = [HWTools getDateFromString:dataDic[@"new_start_date"]];
    NSString *endTime = [HWTools getDateFromString:dataDic[@"new_end_date"]];
    self.activityTimeLable.text = [NSString stringWithFormat:@"正在进行:%@-%@", startTime, endTime];
    
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
