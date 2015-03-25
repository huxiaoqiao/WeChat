//
//  AppDelegate.h
//  WeChat
//
//  Created by apple on 15-3-25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  XMPP用户登录
 */
-(void)xmppLogin;
@end

