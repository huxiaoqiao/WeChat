//
//  WCLoginViewController.m
//  WeChat
//
//  Created by apple on 15-3-25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WCLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+HM.h"

@interface WCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)loginBtnClick:(id)sender {
    
    // 1.判断有没有输入用户名和密码
    if (self.userField.text.length == 0 || self.pwdField.text.length == 0) {
        NSLog(@"请求输入用户名和密码");
        
        return;
    }
    
    
    // 给用户提示
    [MBProgressHUD showMessage:@"正在登录ing...."];
    
    // 2.登录服务器
//    // 2.1把用户名和密码保存到沙盒
//    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
//    [defaults setObject:self.userField.text forKey:@"user"];
//    [defaults setObject:self.pwdField.text forKey:@"pwd"];
//    [defaults synchronize];
   // 2.1把用户和密码先放在Account单例
    [WCAccount shareAccount].loginUser = self.userField.text;
    [WCAccount shareAccount].loginPwd = self.pwdField.text;
    
    
    
    // 2.2调用AppDelegate的xmppLogin方法
    
    // ?怎么把appdelegate的登录结果告诉WCLoginViewControllers控制器
    // 》代理
    // 》block
    // 》通知
    
    // block会对self进行强引用
    __weak typeof(self) selfVc = self;
    //自己写的block ，有强引用的时候，使用弱引用,系统block,我基本可次理
    
    //设置标识
    [WCXMPPTool sharedWCXMPPTool].registerOperation = NO;
    
    [[WCXMPPTool sharedWCXMPPTool] xmppLogin:^(XMPPResultType resultType) {
        
        [selfVc handlXMPPResultType:resultType];
        
    }];

}


#pragma mark 处理结果
-(void)handlXMPPResultType:(XMPPResultType)resultType{
    //回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        if (resultType == XMPPResultTypeLoginSucess) {
            NSLog(@"%s 登录成功",__func__);
            // 3.登录成功切换到主界面
            [UIStoryboard showInitialVCWithName:@"Main"];
            // 设置当前的登录状态
            [WCAccount shareAccount].login = YES;
            
            // 保存登录帐户信息到沙盒
            [[WCAccount shareAccount] saveToSandBox];
            
        }else{
            NSLog(@"%s 登录失败",__func__);
            [MBProgressHUD showError:@"用户名或者密码不正确"];
        }
    });

    
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}


//#pragma mark 切换到主界面
//-(void)changeToMain{
//    // 1.获取Main.storyboard的第一个控制器
//    id vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//    
//    // 2.切换window的根控制器
//    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
//    
//    }
@end
