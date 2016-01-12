//
//  DiscoverTableViewCell.h
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/12.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverModel.h"
@interface DiscoverTableViewCell : UITableViewCell
@property(nonatomic, strong) DiscoverModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;


@end
