//
//  WCContactViewController.m
//  WeChat
//
//  Created by apple on 15-3-27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WCContactViewController.h"

@interface WCContactViewController()<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_resultsContr;
}
/**
 * 好友
 */
@property(strong,nonatomic)NSArray *users;

@end

@implementation WCContactViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self loadUsers2];
}

-(void)loadUsers2{
    //显示好友数据 （保存XMPPRoster.sqlite文件）
    
    //1.上下文 关联XMPPRoster.sqlite文件
    NSManagedObjectContext *rosterContext = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2.Request 请求查询哪张表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    
    //过滤
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"subscription != %@",@"none"];
    request.predicate = pre;
    
    //3.执行请求
    //3.1创建结果控制器
    // 数据库查询，如果数据很多，会放在子线程查询
    // 移动客户端的数据库里数据不会很多，所以很多数据库的查询操作都主线程
    _resultsContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:rosterContext sectionNameKeyPath:nil cacheName:nil];
    _resultsContr.delegate = self;
    NSError *err = nil;
    //3.2执行
    [_resultsContr performFetch:&err];
    
    WCLog(@"%@",_resultsContr.fetchedObjects);
}

#pragma mark -结果控制器的代理
#pragma mark -数据库内容改变
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    WCLog(@"%@",[NSThread currentThread]);
    //刷新表格
    [self.tableView reloadData];

}
#pragma mark 加载好友数据方法1
-(void)loadUsers1{
    //显示好友数据 （保存XMPPRoster.sqlite文件）
    
    //1.上下文 关联XMPPRoster.sqlite文件
    NSManagedObjectContext *rosterContext = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2.Request 请求查询哪张表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //3.执行请求
    NSError *error = nil;
    NSArray *users = [rosterContext executeFetchRequest:request error:&error];
    WCLog(@"%@",users);
    self.users = users;

}

#pragma mark 返回多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.users.count;
    return _resultsContr.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //获取对应的好友
    //XMPPUserCoreDataStorageObject *user = self.users[indexPath.row];
    XMPPUserCoreDataStorageObject *user = _resultsContr.fetchedObjects[indexPath.row];
    //标识用户是否在线
    // 0:在线 1：离开 2：离线
    WCLog(@"%@：在线状态%@",user.displayName,user.sectionNum);
    cell.textLabel.text = user.displayName;
    
    
    // 1.通过KVO来监听用户状态的改变
    //[user addObserver:self forKeyPath:@"sectionNum" options:NSKeyValueObservingOptionNew context:nil];
    
    switch ([user.sectionNum integerValue]) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
        default:
            cell.detailTextLabel.text = @"见鬼了";
            break;
    }
    
    //显示好友的头像
    if (user.photo) {//默认的情况，不是程序一启动就有头像
        cell.imageView.image = user.photo;
    }else{
        //从服务器获取头像
        NSData *imgData = [[WCXMPPTool sharedWCXMPPTool].avatar photoDataForJID:user.jid];
        cell.imageView.image = [UIImage imageWithData:imgData];
    }
    
    return cell;
    
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    WCLog(@"====");
//    [self.tableView reloadData];
//}
#pragma mark 实现此方法，就会出现Delete按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XMPPUserCoreDataStorageObject *user = _resultsContr.fetchedObjects[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除好友
        [[WCXMPPTool sharedWCXMPPTool].roster removeUser:user.jid];
    }
    
    //刷新表格？

}

@end
