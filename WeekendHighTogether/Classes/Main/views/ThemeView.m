//
//  ThemeView.m
//  WeekendHighTogether
//  活动专题视图
//  Created by SCJY on 16/1/8.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ThemeView()



@property(nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic, strong) UIScrollView *mainScrollView;
@end
@implementation ThemeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self congigView];
    }
    return self;
}
#pragma mark---自定义视图
- (void)congigView{
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headerImageView];
}
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"image"]]] placeholderImage:nil];
    [self drawContentWithArray:dataDic[@"content"]];    
    
}
- (void)drawContentWithArray:(NSArray *)contentArray{
    //计算总高度
    CGFloat sumHeight = 186;
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
    self.mainScrollView.contentSize = CGSizeMake(kWidth, sumHeight + 30);
}


#pragma mark---懒加载
- (UIImageView *)headerImageView{
    if (_headerImageView == nil) {
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 186)];
    }
    return _headerImageView;
}

- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    }
    return _mainScrollView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
