//
//  WCXMPPTool.h
//  WeChat
//
//  Created by apple on 15-3-25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef enum {
    XMPPResultTypeLoginSucess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeRegisterSucess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

/**
 *  与服务器交互的结果
 */
typedef void (^XMPPResultBlock)(XMPPResultType);


@interface WCXMPPTool : NSObject
singleton_interface(WCXMPPTool)

/**
 *  标识 连接服务器 到底是 "登录连接"还是 “注册连接”
 *  NO 代表登录操作
 *  YES 代表注册操作
 */
@property(assign,nonatomic,getter=isRegisterOperation)BOOL registerOperation;

/**
 *  XMPP用户登录
 */
-(void)xmppLogin:(XMPPResultBlock)resultBlock;

/**
 *  用户注册
 *
 */
-(void)xmppRegister:(XMPPResultBlock)resultBlock;
/**
 *  用户注销
 */
-(void)xmppLogout;

@end
