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
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityTitleLable.text = dataDic[@"title"];
    self.favoriteLable.text = [NSString stringWithFormat:@"%@人已收藏", dataDic[@"fav"]];
    self.activityPriceLable.text = dataDic[@"price"];
    self.activityAddressLable.text = dataDic[@"address"];
    self.activityPhoneLable.text = dataDic[@"tel"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
