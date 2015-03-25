//
//  WCAccount.h
//  WeChat
//
//  Created by apple on 15-3-25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCAccount : NSObject
@property(nonatomic,copy)NSString *user;
@property(nonatomic,copy)NSString *pwd;
/**
 *  判断用户是否登录
 */
@property(nonatomic,assign,getter=isLogin)BOOL login;


+(instancetype)shareAccount;

/**
 *  保存最新的登录用户数据到沙盒
 */
-(void)saveToSandBox;
@end
