//
//  HWTools.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/7.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools
+ (NSString *)getDateFromString:(NSString *)timestamp{
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
     NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *time = [formatter stringFromDate:date];
    return time;
}
@end
