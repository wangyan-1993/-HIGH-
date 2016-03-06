//
//  ForgetViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/3/3.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ForgetViewController.h"
#import <BmobSDK/Bmob.h>
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
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.userPhoneNum.text andSMSCode:self.security.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [BmobUser resetPasswordInbackgroundWithSMSCode:self.security.text andNewPassword:self.userCode.text block:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                    

                }else{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                    WYLog(@"%@", error);
                }
            }];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码出错,请注意检查" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            

        }
    }];
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
