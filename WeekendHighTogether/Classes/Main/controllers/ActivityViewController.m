//
//  ActivityViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MBProgressHUD.h"
#import "UIViewController+Common.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    [self showBackBtn];
    
    
    //[self getModel];
}
#pragma mark------custom method

- (void)getModel{
    
    AFHTTPSessionManager *sessionMananger = [AFHTTPSessionManager manager];
    sessionMananger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [sessionMananger GET:[NSString stringWithFormat:@"%@&id=%@", kActivityDetail, self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
