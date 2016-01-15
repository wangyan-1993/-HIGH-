//
//  LoginViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.navigationController.navigationBar.barTintColor = mainColor;
}

- (void)backBtnAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)add:(id)sender {
    BmobObject *user = [BmobObject objectWithClassName:@"MemberUser"];
    [user setObject:@"小明" forKey:@"userName"];
    [user setObject:@22 forKey:@"userage"];
    [user setObject:@"男" forKey:@"userSex"];
    [user setObject:@"18137720236" forKey:@"userPhone"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        WYLog(@"恭喜注册成功");
    }];
    
}
- (IBAction)delete:(id)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    [bquery getObjectInBackgroundWithId:@"988348afdc" block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
            }
        }
    }];
    
}
- (IBAction)change:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找GameScore表里面id为988348afdc的数据
    [bquery getObjectInBackgroundWithId:@"988348afdc" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:@"女" forKey:@"userSex"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
    }];
    
}
- (IBAction)find:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"988348afdc" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *userName = [object objectForKey:@"userName"];
                NSString *userPhone = [object objectForKey:@"userPhone"];
                NSLog(@"%@----%@",userName,userPhone);
            }
        }
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
