//
//  DiscoverModel.h
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/12.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *type;
@end
