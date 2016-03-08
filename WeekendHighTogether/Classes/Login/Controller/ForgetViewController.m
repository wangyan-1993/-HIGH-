//
//  ForgetViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/3/3.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ForgetViewController.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"
@interface ForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *security;
@property (weak, nonatomic) IBOutlet UITextField *userCode;
@property (weak, nonatomic) IBOutlet UITextField *userSecondCode;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    self.userPhoneNum.clearButtonMode =  UITextFieldViewModeUnlessEditing;
    self.security.clearButtonMode =  UITextFieldViewModeUnlessEditing;
    self.userCode.clearButtonMode =  UITextFieldViewModeUnlessEditing;
    self.userSecondCode.clearButtonMode =  UITextFieldViewModeUnlessEditing;
    [self showBackBtnWithImage:@"back"];
}
- (void)viewWillAppear:(BOOL)animated{
    self.userSecondCode.text = nil;
    self.userPhoneNum.text = nil;
    self.userCode.text = nil;
    self.security.text = nil;
}
- (IBAction)sendSecurityAction:(id)sender {
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.userPhoneNum.text andTemplate:@"验证码" resultBlock:^(int number, NSError *error) {
        if (error == nil) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"短信已发送,请注意查看(十分钟内有效)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }

    }];
    
}
- (IBAction)doneAction:(id)sender {
    if ([self chectOut]) {
        
               [BmobUser resetPasswordInbackgroundWithSMSCode:self.security.text andNewPassword:self.userCode.text block:^(BOOL isSuccessful, NSError *error) {
                   if (isSuccessful) {
//                       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码已修改成功,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                       [alertView show];
                       
                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"密码修改成功,请重新登录" preferredStyle:UIAlertControllerStyleActionSheet];
                       UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           [self.navigationController popViewControllerAnimated:YES];
                          
                           
                       }];
                       UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           
                       }];
                       
                       [alert addAction:alertAction1];
                       [alert addAction:alertAction2];
                       [self presentViewController:alert animated:YES completion:nil];

                       
                       
                       
                   }else{
                       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:                        [NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                       [alertView show];
                   }
               }];
    }else{
       
        return;
    }
    
}
- (BOOL)chectOut{
        //两次输入密码一致
    if (![self.userCode.text isEqualToString:self.userSecondCode.text]) {
        //alert提示框
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"两次输入密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    //两次输入的密码不能为空
    if (self.userSecondCode.text.length <= 0 || [self.userSecondCode.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"输入的密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
