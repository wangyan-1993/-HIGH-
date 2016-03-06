//
//  AppDelegate.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <BmobSDK/Bmob.h>
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate ()<WeiboSDKDelegate, WXApiDelegate,CLLocationManagerDelegate >
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [WXApi registerApp:kWeixinAppId];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    //注册BMOB
    [Bmob registerWithAppKey:kBmobAppKey];
    
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        WYLog(@"定位服务当前可能尚未打开，请设置打开");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        CLLocationDistance distance = 10.0;
        _locationManager.distanceFilter = distance;
        [_locationManager startUpdatingLocation];
    }
    //UITabBarController
    self.tabBarVC = [[UITabBarController alloc]init];
    //创建被tabBarVC管理的试图控制器
    //主页
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *mainNav = mainStoryBoard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic.png"];
    //按照上左下右的顺序去设置
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *selectImage1 = [UIImage imageNamed:@"ft_home_selected_ic.png"];
    mainNav.tabBarItem.selectedImage = [selectImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    UIStoryboard *discoverStoryBoard = [UIStoryboard storyboardWithName:@"DiscoverStoryboard" bundle:nil];
    UINavigationController *discoverNav = discoverStoryBoard.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic.png"];
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *selectImage2 = [UIImage imageNamed:@"ft_found_selected_ic.png"];
    discoverNav.tabBarItem.selectedImage = [selectImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    UINavigationController *mineNav = mineStoryBoard.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic.png"];
    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *selectImage3 = [UIImage imageNamed:@"ft_person_selected_ic.png"];
    mineNav.tabBarItem.selectedImage = [selectImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //添加被管理的试图控制器
    self.tabBarVC.viewControllers = @[mainNav, discoverNav, mineNav];
    self.tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark---CLLocationManagerDelegate
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    //取出第一个位置
//    CLLocation *location = [locations lastObject];
//    //获取坐标
//    CLLocationCoordinate2D coordinate = location.coordinate;
//    WYLog(@"经度：%f  维度：%f 海拔：%f 航向：%f行走速度：%f", coordinate.longitude, coordinate.latitude, location.altitude,location.course,location.speed);
//    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
//    [users setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
//    [users setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
//    
//    
//    //在获取到用户位置（经纬度）后，通过逆地理编码将经纬度转化为实际的地名、街道等信息
//    
//    
//    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        CLPlacemark *placeMark = [placemarks firstObject];
//        WYLog(@"%@", placeMark.addressDictionary);
//        [[NSUserDefaults standardUserDefaults]setValue:placeMark.addressDictionary[@"City"] forKey:@"city"];
//        //保存
//        [users synchronize];
//        
//    }];
//    //如果不需要实时定位，使用完即使关闭定位服务
//    [_locationManager stopUpdatingLocation];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    WYLog(@"///%f, ///%f, %f, %f, %f", coordinate.longitude, coordinate.latitude, location.altitude, location.course, location.speed);
    //
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
    [userDef setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        [[NSUserDefaults standardUserDefaults] setValue:placeMark.addressDictionary[@"City"] forKey:@"city"];
        [userDef synchronize];
        WYLog(@"%@", placeMark.addressDictionary);
    }];
    [_locationManager stopUpdatingLocation];
    
}
#pragma mark---weibo share
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark---WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
   }

#pragma mark---WXApiDelegate
- (void)onReq:(BaseReq *)req{
    
}
- (void)onResp:(BaseResp *)resp{
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
