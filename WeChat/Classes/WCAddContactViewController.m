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
    
}

-(void)showMsg:(NSString *)msg{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    
    [av show];
}
@end
