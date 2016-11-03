//
//  VCChat.m
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCChat.h"
#import "Message.h"
#import "VCChatCell.h"
#import "ChatInputView.h"

@interface VCChat ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ChatInputView *inputText;
@property (nonatomic, assign) int lastWho;
@end

@implementation VCChat

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
    [self.view addSubview:self.inputText];
    self.dataSource = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[XmppTools sharedManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *msg = [self.dataSource objectAtIndex:indexPath.row];
    return [VCChatCell calHeight:msg];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VCChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VCChatCell"];
    Message *msg = [self.dataSource objectAtIndex:indexPath.row];
    [cell loadData:msg];
    return cell;
}


#pragma mark - Message
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *from = message.from.bare;
    if ([from isEqualToString:XMPP_HOST]) {
        from = @"系统消息";
    }else{
        NSRange range = [from rangeOfString:@"@"];
        from = [from substringToIndex:range.location];//截取范围类的字符串
    }
    if ([self.toUser isEqualToString:from]) {
        if ([message.type intValue] == TEXT) {
            Message *m = [Message new];
            m.content = message.body;
            m.msgType = TEXT;
            m.from = from;
            m.type = OTHER;
            
            [self.dataSource addObject:m];
            [self reload];
        }else if([message.type intValue] == IMAGE){
            NSString *content;
            for (XMPPElement *node in message.children) {
                if ([node.name isEqualToString:@"attachment"]) {
                    content = node.stringValue;
                    break;
                }
                
            }
            Message *m = [Message new];
            m.content = content;
            m.msgType = IMAGE;
            m.from = from;
            m.type = OTHER;
            [self.dataSource addObject:m];
            [self reload];
        }else if([message.type intValue] == RECORD){
            NSString *content;
            NSString *time;
            for (XMPPElement *node in message.children) {
                if ([node.name isEqualToString:@"attachment"]) {
                    content = node.stringValue;
                }else if([node.name isEqualToString:@"time"]){
                    time = node.stringValue;
                }
                
            }
            Message *m = [Message new];
            m.voiceTime = [NSString stringWithFormat:@"%.2f",[time floatValue]];
            m.content = content;
            m.msgType = RECORD;
            m.from = from;
            m.type = OTHER;
            [self.dataSource addObject:m];
            [self reload];
        }
        
        NSLog(@"type:--%@",message.type);
    }
}

- (void)reload{
    [self.table reloadData];
    [self scrollToBottom];
}


-(void)scrollToBottom{
    if (self.dataSource.count > 0) {
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)hideInput{
    [self.inputText hide];
}

#pragma mark - 监听事件
- (void) keyboardWillChangeFrame:(NSNotification *)note{
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat transformY = keyboardFrame.origin.y - self.view.height;
    [UIView animateWithDuration:duration animations:^{
        self.inputText.transform = CGAffineTransformMakeTranslation(0, transformY-64);
        CGRect f = self.table.frame;
        if(transformY < 0){
            self.table.height = self.table.height+transformY;
        }else{
            self.table.height = self.view.height-50;
        }
        self.table.frame = f;
    } completion:^(BOOL finished) {
        [self scrollToBottom];
    }];
}

- (UITableView*)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT-NAV_STATUS_HEIGHT-50) style:UITableViewStylePlain];
        [_table registerClass:[VCChatCell class] forCellReuseIdentifier:@"VCChatCell"];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.backgroundColor = [UIColor clearColor];
    }
    return _table;
}


- (ChatInputView*)inputText{
    if (!_inputText) {
        _inputText = [[ChatInputView alloc]initWithFrame:CGRectMake(0, self.table.bottom, DEVICEWIDTH, 50)];
        //_inputText.delegate = self;
    }
    return _inputText;
}

@end
