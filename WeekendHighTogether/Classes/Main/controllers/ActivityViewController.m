//
//  ActivityViewController.m
//  WeekendHighTogether
//  活动详情
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MBProgressHUD.h"
#import "ActivityView.h"
@interface ActivityViewController ()

@property (strong, nonatomic) IBOutlet ActivityView *activityView;
@property (nonatomic, copy) NSString *phoneNum;


@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    [self showBackBtn];
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    //去地图页面
    [self.activityView.mapBtn addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //打电话
    [self.activityView.makeCallBtn addTarget:self action:@selector(makeCallAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getModel];
}
#pragma mark------custom method

- (void)getModel{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager GET:[NSString stringWithFormat:@"%@&id=%@", kActivityDetail, self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       // WYLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         //WYLog(@"%@", responseObject);
        //解析数据
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityView.dataDic = successDic;
            self.phoneNum = successDic[@"tel"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        WYLog(@"error = %@", error);
    }];
}


#pragma mark ---btn method
//地图页面
- (void)mapAction:(UIButton *)btn{
    
}

//打电话页面
- (void)makeCallAction:(UIButton *)btn{
  //程序外打电话，不返回当前程序
    
  //程序内打电话，打完电话之后返回当前应用程序
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.phoneNum]]];
    
    UIWebView *cellPhoneWebView = [[UIWebView alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.phoneNum]]];
    [cellPhoneWebView loadRequest:request];
    [self.view addSubview:cellPhoneWebView];
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
