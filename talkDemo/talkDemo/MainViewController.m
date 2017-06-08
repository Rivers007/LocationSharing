//
//  ViewController.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/1/31.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "MainViewController.h"
#import "JGZMainViewCell.h"
#import "JGZAccountTool.h"
#import "JGZSharedLocationController.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *DataSourceArray;
@end

@implementation MainViewController

-(NSMutableArray *)DataSourceArray{
    if (_DataSourceArray==nil) {
        _DataSourceArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _DataSourceArray;
}
-(UITableView *)tableview{
    if (_tableview==nil) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStyleGrouped];
        _tableview.backgroundColor=[UIColor cyanColor];
        _tableview.delegate = self;
        _tableview.dataSource=self;
        [_tableview registerClass:[JGZMainViewCell class] forCellReuseIdentifier:@"JGZMainViewCell"];
        _tableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息";
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self SetNavItem];
    [[EMClient sharedClient].chatManager addDelegate:self];
    [self.view addSubview:self.tableview];
    [self GetChatConversation];
}
-(void)SetNavItem{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick)];
}
-(void)rightBarItemClick{
    [JGZAccountTool LogOut];
}
-(void)GetChatConversation{
    [self.DataSourceArray removeAllObjects];
   NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    [self.DataSourceArray addObjectsFromArray:conversations];
    [self.tableview reloadData];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGZMainViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"JGZMainViewCell" forIndexPath:indexPath];
    EMConversation *conversation = self.DataSourceArray[indexPath.row];
    cell.message =conversation.latestMessage;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMConversation *conversation = self.DataSourceArray[indexPath.row];
//    JGZChatRoomController *ChatRoomController = [[JGZChatRoomController alloc] initWith:conversation];
    JGZSharedLocationController *ChatRoomController = [[JGZSharedLocationController alloc] initWith:conversation];
    [self.navigationController pushViewController:ChatRoomController animated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(void)conversationListDidUpdate:(NSArray *)aConversationList{
NSLog(@"%@",aConversationList.lastObject);
     [self GetChatConversation];
}
- (void)didReceiveMessages:(NSArray *)aMessages{
    NSLog(@"%@",aMessages.lastObject);
    [self GetChatConversation];
}
@end
