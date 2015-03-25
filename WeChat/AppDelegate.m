//
//  AppDelegate.m
//  WeChat
//
//  Created by apple on 15-3-25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"

/* 用户登录流程
 1.初始化XMPPStream

 2.连接服务器(传一个jid)

 3.连接成功，接着发送密码
 
 // 默认登录成功是不在线的
 4.发送一个 "在线消息" 给服务器 ->可以通知其它用户你上线
 */
@interface AppDelegate ()<XMPPStreamDelegate>{
    
    XMPPStream *_xmppStream;//与服务器交互的核心类
}
/**
 *  1.初始化XMPPStream
 */
-(void)setupStream;

/**
 *  2.连接服务器(传一个jid)
 */
-(void)connectToHost;

/**
 *  3.连接成功，接着发送密码
 */
-(void)sendPwdToHost;

/**
 *  4.发送一个 "在线消息" 给服务器
 */
-(void)sendOnline;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupStream];
    [self connectToHost];
    return YES;
}

#pragma mark -私有方法
-(void)setupStream{
    // 创建XMPPStream对象
    _xmppStream = [[XMPPStream alloc] init];
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

-(void)connectToHost{

    // 1.设置登录用户的jid
    // resource 用户登录客户端设备登录的类型
    XMPPJID *myJid = [XMPPJID jidWithUser:@"wangwu" domain:@"teacher.local" resource:@"iphone"];
    _xmppStream.myJID = myJid;
    
    // 2.设置主机地址
    _xmppStream.hostName = @"127.0.0.1";
    
    // 3.设置主机端口号 (默认就是5222，可以不用设置)
    _xmppStream.hostPort = 5222;
    
    // 4.发起连接
    NSError *error = nil;
    // 缺少必要的参数时就会发起连接失败 ? 没有设置jid
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"发起连接成功");
    }
    
}


-(void)sendPwdToHost{
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}


-(void)sendOnline{
    //XMPP框架，已经把所有的指令封闭成对象
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@",presence);
    [_xmppStream sendElement:presence];
}

#pragma mark -XMPPStream的代理
#pragma mark 连接建立成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"%s",__func__);
    [self sendPwdToHost];
}

#pragma mark 登录成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"%s",__func__);
    [self sendOnline];
}

#pragma mark 登录失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"%s %@",__func__,error);
}

#pragma mark -公共方法
#pragma mark 用户登录
-(void)xmppLogin{
 
}

@end
