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
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *code;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtnWithImage:@"back"];
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    self.title = @"登录";
    self.name.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.code.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.code.secureTextEntry = YES;
    
}
- (IBAction)loginBtn:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.name.text password:self.code.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            WYLog(@"%@", user);
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            delegate.isLogin=YES;
            delegate.username = self.name.text;
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"用户名或密码有错误,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
 
        }
    }];
    
    
}
- (IBAction)forgetCodeBtn:(id)sender {
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)backBtnAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
