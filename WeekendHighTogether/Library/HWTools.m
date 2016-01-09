//
//  HWTools.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/7.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools

#pragma mark---时间转换
+ (NSString *)getDateFromString:(NSString *)timestamp{
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
     NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *time = [formatter stringFromDate:date];
    return time;
}
#pragma mark---获取当前系统时间
+ (NSDate *)getSystemNowDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}





#pragma mark---计算高度

+ (CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize font:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}



@end
