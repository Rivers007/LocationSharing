//
//  JGZLoginController.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/1/31.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "JGZLoginController.h"
#import "JGZAccountTool.h"
#import "JGZAccount.h"
@interface JGZLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *AccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;
- (IBAction)LoginBtnClick:(id)sender;
- (IBAction)RegisterBtnClick:(id)sender;

@end

@implementation JGZLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LoginBtn.layer.cornerRadius=3;
    self.LoginBtn.layer.masksToBounds=YES;
    self.RegisterBtn.layer.cornerRadius=3;
    self.RegisterBtn.layer.masksToBounds=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)LoginBtnClick:(id)sender {

    JGZAccount *AccountModel = [[JGZAccount alloc] init];
    AccountModel.Account = self.AccountTextField.text;
    AccountModel.PassWord = self.PassWordTextField.text;
    BOOL flag=[JGZAccountTool LoginAccount:AccountModel];
    if (flag==YES) {
        NSLog(@"登陆成功");
    }else{
     NSLog(@"登陆失败");
    }
}

- (IBAction)RegisterBtnClick:(id)sender {
    JGZAccount *AccountModel = [[JGZAccount alloc] init];
    AccountModel.Account = self.AccountTextField.text;
    AccountModel.PassWord = self.PassWordTextField.text;
    BOOL flag=[JGZAccountTool RegisterAccount:AccountModel];
    if (flag==YES) {
        NSLog(@"注册成功");
    }else{
        NSLog(@"注册失败");
    }
}
@end
