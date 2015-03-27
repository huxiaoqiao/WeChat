//
//  WCEditVCardViewController.m
//  WeChat
//
//  Created by apple on 15-3-27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WCEditVCardViewController.h"

@interface WCEditVCardViewController()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCEditVCardViewController


-(void)viewDidLoad{
    [super viewDidLoad];

    //WCLog(@"%@",self.cell.detailTextLabel);
    
    //设置标题
    self.title = self.cell.textLabel.text;
    
    
    //设置输入框默认数值
    self.textField.text = self.cell.detailTextLabel.text;
    

}


- (IBAction)saveBtnClick:(id)sender {
    
    //1.把cell的detailTextLabel的值更改
    self.cell.detailTextLabel.text = self.textField.text;
    
    
    [self.cell layoutSubviews];
    
    //2.当前控制器销毁
    [self.navigationController popViewControllerAnimated:YES];
    
    
    //3.通过上一个控制器
    if ([self.delegate respondsToSelector:@selector(editVCardViewController:didFinishedSave:)]) {
        [self.delegate editVCardViewController:self didFinishedSave:sender];
    }
    
}

@end
