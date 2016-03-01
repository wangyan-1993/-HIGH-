//
//  City.h
//  WeekendHighTogether
//
//  Created by SCJY on 16/3/1.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *cityID;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
