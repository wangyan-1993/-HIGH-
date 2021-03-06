//
//  ActivityViewController.m
//  WeekendHighTogether
//  精选活动，推荐活动
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface ActivityViewController ()
{
    CLGeocoder *_geocoder;

}
@property (strong, nonatomic) IBOutlet ActivityView *activityView;
@property (nonatomic, copy) NSString *phoneNum;
@property(nonatomic, copy) NSString *address;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    [self showBackBtnWithImage:@"back"];
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    //去地图页面
    [self.activityView.mapBtn addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //打电话
    [self.activityView.makeCallBtn addTarget:self action:@selector(makeCallAction:) forControlEvents:UIControlEventTouchUpInside];
     _geocoder=[[CLGeocoder alloc]init];
    [self getModel];
}
#pragma mark------custom method

- (void)getModel{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];
    [manager GET:[NSString stringWithFormat:@"%@&id=%@&lat=%@&lng=%@", kActivityDetail, self.activityId, lat, lng] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       // WYLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         //WYLog(@"%@", responseObject);
        //解析数据
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityView.dataDic = successDic;
            self.phoneNum = successDic[@"tel"];
            self.address = successDic[@"address"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        WYLog(@"error = %@", error);
    }];
}


#pragma mark ---btn method
//地图页面
- (void)mapAction:(UIButton *)btn{
    [self location];
    
}
- (void)location{
    
    [_geocoder geocodeAddressString:self.address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkplacemark=[[MKPlacemark alloc]initWithPlacemark:clPlacemark];//定位地标转化为地图的地标
        NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
        MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:mkplacemark];
        [mapItem openInMapsWithLaunchOptions:options];
    }];
    
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
