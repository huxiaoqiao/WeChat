//
//  WCProfileViewController.m
//  WeChat
//
//  Created by apple on 15-3-27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"

@interface WCProfileViewController()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *wechatNumLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位

@property (weak, nonatomic) IBOutlet UILabel *telLabel;//电话

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation WCProfileViewController



-(void)viewDidLoad{
    [super viewDidLoad];
    // 1.它内部会去数据查找
    // 为什么电子名片的模型是temp,因为解析电子名片的xml没有完善，有此节点并未解析，所以称为临时
    XMPPvCardTemp *myvCard =  [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    // 获取头像
    if (myvCard.photo) {
        self.avatarImgView.image = [UIImage imageWithData:myvCard.photo];
    }
    
    // 微信号 (显示用户名)
    self.wechatNumLabel.text =[WCAccount shareAccount].loginUser;
    
    self.nicknameLabel.text = myvCard.nickname;
    
    //公司
    self.orgNameLabel.text = myvCard.orgName;
    
    //部门
    if (myvCard.orgUnits.count > 0) {
        self.departmentLabel.text = myvCard.orgUnits[0];
    }
    
    //职位
    self.titleLabel.text = myvCard.title;
    
    //电话
    //self.telLabel.text = myvCard.telecomsAddresses[0];
    //使用note充当电话
    self.telLabel.text = myvCard.note;
    
    //邮箱
    // 使用mailer充当
    self.emailLabel.text = myvCard.mailer;

    
}

@end
