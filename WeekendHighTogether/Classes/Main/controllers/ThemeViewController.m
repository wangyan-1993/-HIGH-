//
//  ThemeViewController.m
//  WeekendHighTogether
//  热门专题， 推荐专题
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ThemeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ThemeView.h"
@interface ThemeViewController ()
@property(nonatomic, strong) ThemeView *themeView;
@end

@implementation ThemeViewController
- (void)loadView{
    [super loadView];
    self.themeView = [[ThemeView alloc]initWithFrame:self.view.frame];
        self.view = self.themeView;
    [self getModel];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    [self showBackBtnWithImage:@"back"];
    
    
}

#pragma mark ------ custom method
- (void)getModel{
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    City *cityModel = [dbManager selectAllCity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];
    [manager GET:[NSString stringWithFormat:@"%@&id=%@&cityid=%ld&lat=%@&lng=%@", kActivityTheme, self.themeid, [cityModel.cityID integerValue], lat, lng] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
         WYLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            self.themeView.dataDic = dic[@"success"];
            self.title = dic[@"success"][@"title"];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        WYLog(@"error = %@", error);
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
