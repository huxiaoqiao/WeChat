//
//  WCAddContactViewController.m
//  WeChat
//
//  Created by apple on 15-3-28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WCAddContactViewController.h"

@interface WCAddContactViewController()

@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)addContactBtnClick:(id)sender;


@end

@implementation WCAddContactViewController

#pragma mark 添加好友
- (IBAction)addContactBtnClick:(id)sender {
    
    //添加好友
    // 获取用户输入好友名称
    NSString *user = self.textField.text;
    
    
    
    //1.不能添加自己为好友
    if ([user isEqualToString:[WCAccount shareAccount].loginUser]) {
        [self showMsg:@"不能添加自己为好友"];
        return;
    }
    
    //2.已经存在好友无需添加
    XMPPJID *userJid = [XMPPJID jidWithUser:user domain:[WCAccount shareAccount].domain resource:nil];
    
    BOOL userExists = [[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:userJid xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream];
    if (userExists) {
        [self showMsg:@"好友已经存在"];
        return;
    }
    
    //3.添加好友 (订阅)
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:userJid];
    
    
    /*添加好友在现有openfire存在的问题
     1.添加不存在的好友，通讯录里面也现示了好友
       解决办法1. 服务器可以拦截好友添加的请求，如当前数据库没有好友，不要返回信息
    <presence type="subscribe" to="werqqrwe@teacher.local"><x xmlns="vcard-temp:x:update"><photo>b5448c463bc4ea8dae9e0fe65179e1d827c740d0</photo></x></presence>
     
       解决办法2.过滤数据库的Subscription字段查询请求
       none 对方没有同意添加好友
       to 发给对方的请求
       from 别人发来的请求
       both 双方互为好友
     
     */
   
    
}

-(void)showMsg:(NSString *)msg{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    
    [av show];
}
@end
