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
{
    CGFloat sumHeight;
}

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
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 5000);
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
    [self drawContentWithArray:dataDic[@"content"]];
    
    [self drawReminderWithString:dataDic[@"reminder"]];
    
    }
- (void)drawContentWithArray:(NSArray *)contentArray{
    //计算总高度
    sumHeight = 390;
    for (NSDictionary *dic in contentArray) {
        //如果标题存在
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, sumHeight, kWidth - 20, 30)];
            label.text = title;
            [self.mainScrollView addSubview:label];
            //sumHeight加上title的高度
            sumHeight += 30;
        }
        
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kWidth - 20, 1000) font:15.0];
        //每循环一次，label的起始位置变化
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,  sumHeight , kWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        //sumHeight加上label的高度，以便计算一个数组里面的总高度，方便下一个数组起始位置的计算
         sumHeight += height;
        NSArray *urlsArray = dic[@"urls"];
        //计算图片的高度
        CGFloat sum = 0;
        for (NSDictionary *dict in urlsArray) {
            CGFloat width = [dict[@"width"] integerValue] / 2;
            CGFloat imageHeight = [dict[@"height"]integerValue] / 2;
            //每循环一次imageView的位置 加上前一次的高度
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, label.bottom + sum, kWidth - 20, (kWidth - 20) / width * imageHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"url"]] placeholderImage:nil];
            [self.mainScrollView addSubview:imageView];
            //sum加上这一张图片的高度，以便下次循环计算下张图片的起始位置
            sum += (kWidth - 20) / width * imageHeight + 5;
            
        }
        //sumHeight加上图片的高度，以便计算一个数组里面的总高度，方便下一个数组起始位置的计算
        sumHeight += sum;
        
    }
}
//温馨提示下面的东西
- (void)drawReminderWithString:(NSString *)str{
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, sumHeight, kWidth, 5)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.mainScrollView addSubview:view];
    
    UILabel *reminderTitle = [[UILabel alloc]initWithFrame:CGRectMake(38, sumHeight + 5, kWidth - 38, 25)];
    reminderTitle.text = @"温馨提示";
    [self.mainScrollView addSubview:reminderTitle];
    
    UIImageView *litleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, sumHeight + 30, kWidth, 0.5)];
    litleView.backgroundColor = [UIColor lightGrayColor];
    [self.mainScrollView addSubview:litleView];
    
    CGFloat reminderHeight = [HWTools getTextHeightWithText:str bigestSize:CGSizeMake(kWidth - 20, 1000) font:15.0];
    UILabel *reminder = [[UILabel alloc]initWithFrame:CGRectMake(10, sumHeight + 31, kWidth - 20, reminderHeight)];
    reminder.text = str;
    reminder.font = [UIFont systemFontOfSize:15.0];
    reminder.numberOfLines = 0;
    [self.mainScrollView addSubview:reminder];
    self.mainScrollView.contentSize = CGSizeMake(kWidth, reminder.bottom + 30);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
