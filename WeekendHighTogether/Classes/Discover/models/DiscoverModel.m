//
//  DiscoverModel.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/12.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.type = dict[@"type"];
    }
    return self;
}
@end
