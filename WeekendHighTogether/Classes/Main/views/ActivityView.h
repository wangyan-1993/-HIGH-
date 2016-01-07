//
//  ActivityView.h
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/7.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIButton *makeCallBtn;
@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end
