//
//  MainModel.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/5.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
         self.type = dic[@"type"];
        //如果是推荐活动
        if ([self.type integerValue] == RecommedTypeActivity) {
            self.price = dic[@"price"];
            self.lat = [dic[@"lat"] floatValue];
            self.lng = [dic[@"lng"] floatValue];
            self.address = dic[@"address"];
            self.counts = dic[@"counts"];
            self.startTime = dic[@"startTime"];
            self.endTime = dic[@"endTime"];
        }else{
            //如果是推荐专题
            self.activityDescription = dic[@"description"];
        }
        self.image_big = dic[@"image_big"];
        self.title = dic[@"title"];
        self.actuvityId = dic[@"id"];
        
    }
    return self;
}


@end
