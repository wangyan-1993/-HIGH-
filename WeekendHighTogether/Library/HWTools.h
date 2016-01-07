//
//  HWTools.h
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/7.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTools : NSObject
#pragma mark---时间转换
+ (NSString *)getDateFromString:(NSString *)timestamp;
#pragma mark--根据文字最大显示宽高和文字内容返回文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize font:(CGFloat)font;
@end
