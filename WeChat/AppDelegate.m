//
//  AppDelegate.m
//  WeChat
//
//  Created by apple on 15-3-25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "DDTTYLogger.h"
#import "DDLog.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    //配置XMPP的日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
//    [self setupStream];
//    [self connectToHost];
    // 判断用户是否登录
    if([WCAccount shareAccount].isLogin){
        //来主界面
        id mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = mainVc;
        
        //自动登录
        [[WCXMPPTool sharedWCXMPPTool] xmppLogin:nil];
    }
    
    return YES;
}


@end
