//
//  AppDelegate.h
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) UITabBarController *tabBarVC;
@property(nonatomic, copy) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@property(assign, nonatomic) BOOL isLogin;
@property(nonatomic, copy) NSString *username;
@end

