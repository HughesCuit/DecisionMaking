//
//  LoginViewController.m
//  DecisionMaking
//
//  Created by rimi on 15/10/8.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "LoginViewController.h"
#import <MBProgressHUD.h>

@interface LoginViewController ()

- (void) initializeDataSource;/**< 初始化数据源 */


- (void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

- (void)initializeDataSource{
    
}

- (void)initializeUserInterface{
    self.view.backgroundColor = kBlueColor;
    //初始化logo
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultPhoto"]];
    imgV.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)/3, CGRectGetWidth(self.view.bounds)/3);
    imgV.center = CGPointMake(self.view.center.x, 175);
    imgV.layer.cornerRadius = imgV.bounds.size.width/2;
    imgV.layer.masksToBounds = YES;
    [self.view addSubview:imgV];
    
    
    //账号文本框初始化
    UITextField *accTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)*0.6, CGRectGetHeight(self.view.bounds)*0.06)];
    accTF.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(imgV.frame)+40);
    accTF.borderStyle = UITextBorderStyleRoundedRect;
    accTF.placeholder = @"请输入用户名";
    accTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    accTF.tag = 100;
    [self.view addSubview:accTF];
    
    
    //密码文本框初始化
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)*0.6, CGRectGetHeight(self.view.bounds)*0.06)];
    pwdTF.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(accTF.frame)+30);
    pwdTF.borderStyle = UITextBorderStyleRoundedRect;
    pwdTF.placeholder = @"请输入密码";
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.secureTextEntry = YES;
    pwdTF.tag = 101;
    [self.view addSubview:pwdTF];
    
    
    //登陆按钮初始化
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)*0.6, CGRectGetHeight(self.view.bounds)*0.05);
    loginButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(pwdTF.frame)+60);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:200/255.0f green:45/255.0f blue:27/255.0f alpha:1];
    loginButton.tintColor = [UIColor whiteColor];
    [loginButton.layer setCornerRadius:5];
    [loginButton addTarget:self action:@selector(respondsToLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    //注册按钮初始化
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)*0.6, CGRectGetHeight(self.view.bounds)*0.05);
    registerButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(loginButton.frame)+(4*CGRectGetHeight(loginButton.frame))/5);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor colorWithRed:133/255.0f green:180/255.0f blue:255/255.0f alpha:1];
    registerButton.tintColor = [UIColor whiteColor];
    [registerButton.layer setCornerRadius:5];
    [registerButton addTarget:self action:@selector(respondsToRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
}

- (void)respondsToLoginButton{
    UITextField *accTF = (UITextField*)[self.view viewWithTag:100];
    UITextField *pwdTF = (UITextField*)[self.view viewWithTag:101];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BmobUser loginWithUsernameInBackground:accTF.text password:pwdTF.text block:^(BmobUser *user, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            setLogin;
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"登陆错误，请检查你的登陆信息"] preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:^{
                accTF.text = @"";
                pwdTF.text = @"";
            }];
        }
    }];
}

- (void)respondsToRegisterButton{
    UITextField *accTF = (UITextField*)[self.view viewWithTag:100];
    UITextField *pwdTF = (UITextField*)[self.view viewWithTag:101];
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUserName:accTF.text];
    [bUser setPassword:pwdTF.text];
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"Sign up successfully");
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITextField *accTF = (UITextField*)[self.view viewWithTag:100];
    UITextField *pwdTF = (UITextField*)[self.view viewWithTag:101];
    [accTF resignFirstResponder];
    [pwdTF resignFirstResponder];
}
@end
