//
//  WCChatViewController.m
//  WeChat
//
//  Created by apple on 15-3-28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WCChatViewController.h"

@interface WCChatViewController()<NSFetchedResultsControllerDelegate>

{
    NSFetchedResultsController *_resultContr;
}

@end

@implementation WCChatViewController


-(void)viewDidLoad{

    [super viewDidLoad];
    
    //加载数据库的聊天数据
    
    // 1.上下文
    NSManagedObjectContext *msgContext = [WCXMPPTool sharedWCXMPPTool].msgArchivingStorage.mainThreadManagedObjectContext;
    
    // 2.查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    // 过滤 （当前登录用户 并且 好友的聊天消息）
    NSString *loginUserJid = [WCXMPPTool sharedWCXMPPTool].xmppStream.myJID.bare;
    WCLog(@"%@",loginUserJid);
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",loginUserJid,self.friendJid.bare];
    request.predicate = pre;
    
    // 设置时间排序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    // 3.执行请求
    _resultContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:msgContext sectionNameKeyPath:nil cacheName:nil];
    _resultContr.delegate = self;
    NSError *err = nil;
    [_resultContr performFetch:&err];
    WCLog(@"%@",err);
    WCLog(@"%@",_resultContr.fetchedObjects);
}


-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
}
@end
