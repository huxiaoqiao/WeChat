//
//  WCLoginViewController.m
//  WeChat
//
//  Created by apple on 15-3-25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WCLoginViewController.h"
#import "AppDelegate.h"

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
    
    // 2.登录服务器
    // 2.1把用户名和密码保存到沙盒
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userField.text forKey:@"user"];
    [defaults setObject:self.pwdField.text forKey:@"pwd"];
    [defaults synchronize];
    
    // 2.2调用AppDelegate的xmppLogin方法
    
    // ?怎么把appdelegate的登录结果告诉WCLoginViewControllers控制器
    // 》代理
    // 》block
    // 》通知
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate xmppLogin:^(XMPPResultType resultType) {
        
        if (resultType == XMPPResultTypeLoginSucess) {
            NSLog(@"%s 登录成功",__func__);
            // 3.登录成功切换到主界面
            [self changeToMain];
        }else{
            NSLog(@"%s 登录失败",__func__);
        }
    }];
    
    
    }


-(void)changeToMain{
    //回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        // 1.获取Main.storyboard的第一个控制器
        id vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        
        // 2.切换window的根控制器
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    });
    
    
}
@end
