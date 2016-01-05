//
//  MainModel.h
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/5.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    RecommedTypeActivity = 1,//推荐活动
    RecommedTypeTheme//推荐专题

}RecommedType;

@interface MainModel : NSObject
//首页大图
@property(nonatomic, copy) NSString * image_big;
//标题
@property(nonatomic, copy) NSString * title;
//价格
@property(nonatomic, copy) NSString * price;
//经纬度
@property(nonatomic, assign) CGFloat lat;
@property(nonatomic, assign) CGFloat lng;

@property(nonatomic, copy) NSString * address;
@property(nonatomic, copy) NSString * startTime;
@property(nonatomic, copy) NSString * counts;
@property(nonatomic, copy) NSString * endTime;
@property(nonatomic, copy) NSString * actuvityId;
@property(nonatomic, copy) NSString * type;
@property(nonatomic, copy) NSString * activityDescription;
- (instancetype) initWithDictionary:(NSDictionary *)dic;

@end
