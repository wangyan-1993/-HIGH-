//
//  City.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/3/1.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "City.h"

@implementation City
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"cat_name"];
        self.cityID = dic[@"cat_id"];
    }
    return self;
}
@end
