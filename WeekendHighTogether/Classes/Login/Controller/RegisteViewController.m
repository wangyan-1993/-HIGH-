//
//  RegisteViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/3/2.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "RegisteViewController.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"
@interface RegisteViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *uesrName;
@property (weak, nonatomic) IBOutlet UITextField *uesrCode;
@property (weak, nonatomic) IBOutlet UITextField *userSecondCode;
@property (weak, nonatomic) IBOutlet UISwitch *uncodeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       [self showBackBtnWithImage:@"back"];
    self.title = @"手机号注册";
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    //密码暗文显示
    self.userSecondCode.secureTextEntry = YES;
    self.uesrCode.secureTextEntry = YES;
    self.userSecondCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.uesrCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.uesrName.clearButtonMode = UITextFieldViewModeWhileEditing;
    //默认switch关闭
    self.uncodeSwitch.on = NO;
}
- (IBAction)registerBtnAction:(id)sender {
    if ([self checkOut]) {
       
        [ProgressHUD show:@"正在为您注册"];
        BmobUser *buser =[[BmobUser alloc]init];
        [buser setUsername:self.uesrName.text];
        [buser setPassword:self.uesrCode.text];
        [buser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //[ProgressHUD showSuccess:@"注册成功"];
                WYLog(@"注册成功");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"注册成功" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];

                [alert addAction:alertAction1];
                [alert addAction:alertAction2];
                [self presentViewController:alert animated:YES completion:nil];

            }else{
                [ProgressHUD showError:@"注册失败"];
                WYLog(@"注册失败");
            }
        }];

    }else{
        return;
    }
}
- (BOOL)checkOut{
    //用户名不能为空且不能为空格
    if (self.uesrName.text.length <= 0 || [self.uesrName.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"用户名不能为空且不能有空格" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    //两次输入密码一致
    if (![self.uesrCode.text isEqualToString:self.userSecondCode.text]) {
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
    
    //正则表达式
    //判断输入的手机号是否有效
    //判断输入邮箱是否正确
    return YES;
}
- (IBAction)switchAction:(id)sender {
    UISwitch *codeswitch = sender;
    if (codeswitch.on) {
        self.userSecondCode.secureTextEntry = NO;
        self.uesrCode.secureTextEntry = NO;
    }else{
        self.userSecondCode.secureTextEntry = YES;
        self.uesrCode.secureTextEntry = YES;
    }
}
#pragma mark---UITextFieldDelegate
//点击右下角回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击空白回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //第一种
    [self.view endEditing:YES];
    //第二种
//    [self.uesrName resignFirstResponder];
//    [self.uesrCode resignFirstResponder];
//    [self.userSecondCode resignFirstResponder];
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
