//
//  JGZChatRoomController.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/2/1.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "JGZChatRoomController.h"
#import "JGZChatRoomCell.h"
#import "JGZToolBar.h"
#import "JGZInputTextView.h"

@interface JGZChatRoomController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,JGZToolBarDelegate>
@property (nonatomic,strong) EMConversation *ConverSation;
@property (nonatomic,strong) NSMutableArray *MessageArray;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) JGZToolBar *ToolBar;

@property (nonatomic,assign) CGRect oldtestlabelFrame;
@end

@implementation JGZChatRoomController
-(instancetype)initWith:(EMConversation *)ConverSation{
    if (self=[super init]) {
        self.ConverSation=ConverSation;
        [self GetAllMessage];
    }
    return self;
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-40) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource=self;
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.oldtestlabelFrame=self.tableview.frame;
        [_tableview registerClass:[JGZChatRoomCell class] forCellReuseIdentifier:@"JGZChatRoomCell"];
    }
    return _tableview;
}
-(NSMutableArray *)MessageArray{
    if (!_MessageArray) {
        _MessageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _MessageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.ConverSation.latestMessage.direction==EMMessageDirectionSend) {
        self.title=self.ConverSation.latestMessage.to;
    }else{
        self.title=self.ConverSation.latestMessage.from;;
    }
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor grayColor];
    [[EMClient sharedClient].chatManager addDelegate:self];
    [self.view addSubview:self.tableview];
    [self CreatToolBar];
}
-(void)CreatToolBar{
    JGZToolBar *ToolBar = [[JGZToolBar alloc] initWithFrame:CGRectMake(0, UIScreenSize.height-40, UIScreenSize.width, 40)];
    self.ToolBar= ToolBar;
    ToolBar.delegate=self;
    __weak typeof(self) weakself = self;
    [self.ToolBar getToolBarMinYBlock:^(JGZToolBar *ToolBar, CGFloat ToolBarMinY) {
        if (CGRectGetMaxY(self.oldtestlabelFrame)>ToolBarMinY) {
            CGRect tableviewframe=weakself.tableview.frame;
            tableviewframe.origin.y=ToolBarMinY-self.oldtestlabelFrame.size.height;
            [UIView animateWithDuration:0.25 animations:^{
                weakself.tableview.frame = tableviewframe;
            }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                weakself.tableview.frame = self.oldtestlabelFrame;
            }];
            
        }

    }];
    [self.view addSubview:ToolBar];
    
    
}
-(void)GetAllMessage{
    [self.ConverSation loadMessagesWithKeyword:@"" timestamp:-1 count:20 fromUser:@"" searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        [self.MessageArray addObjectsFromArray:aMessages];
        [self.tableview reloadData];
        [self.tableview scrollToRow:self.MessageArray.count-1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    
//            EMMessage *message=[aMessages lastObject];
//            EMTextMessageBody *body=message.body;
//            NSLog(@"%@\n%@",body.text,message.ext);

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MessageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGZChatRoomCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"JGZChatRoomCell" forIndexPath:indexPath];
    EMMessage *message=self.MessageArray[indexPath.row];
    EMTextMessageBody *body=(EMTextMessageBody *)message.body;
    if (message.direction==EMMessageDirectionSend) {
        //发送者
        cell.BodyDetailLabel.textAlignment=NSTextAlignmentRight;
    }else{
    cell.BodyDetailLabel.textAlignment=NSTextAlignmentLeft;
    }
    cell.BodyDetailLabel.text =body.text;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)didReceiveMessages:(NSArray *)aMessages{
    NSLog(@"%@",aMessages.lastObject);
    [self.MessageArray addObject:aMessages.lastObject];
    [self.tableview insertRow:self.MessageArray.count-1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    [self.tableview scrollToRow:self.MessageArray.count-1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)SendButtonDidClick:(NSString *)string{
    NSDictionary *dict =@{@"jgzhu":@"123"};
   EMMessage *message= [EMSDKHelp SendTextMessage:string messageExt:dict chatType:EMChatTypeChat Conversation:self.ConverSation];
    [self.MessageArray addObject:message];
    [self.tableview insertRow:self.MessageArray.count-1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    [self.tableview scrollToRow:self.MessageArray.count-1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //NSLog(@"%@",string);
//    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"expressionImage_custom" bundleName:@"JGZEmoji_Expression"];
//    
//    self.testlabel.attributedText = [[[MLExpressionManager GetEmojiToStringOfLabel:self.testlabel] stringByAppendingString:string] expressionAttributedStringWithExpression:exp];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.ToolBar.inputtextview resignFirstResponder];
}

@end
