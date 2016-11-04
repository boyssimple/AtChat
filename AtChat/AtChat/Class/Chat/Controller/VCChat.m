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

@interface VCChat ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChatInputDelegate>
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideInput];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideInput];
}


#pragma mark - Message
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    NSString *sgtype = [[message attributeForName:@"type"] stringValue];
    if ([sgtype isEqualToString:@"chat"]) {
        int type = TEXT;
        for (XMPPElement *node in message.children) {
            if ([node.name isEqualToString:@"MSGTYPE"]) {
                type = node.stringValueAsInt;
            }
        }
        
        NSString *from = message.from.bare;
        if ([from isEqualToString:XMPP_HOST]) {
            from = @"系统消息";
        }else{
            NSRange range = [from rangeOfString:@"@"];
            from = [from substringToIndex:range.location];//截取范围类的字符串
        }
        if ([self.toUser isEqualToString:from]) {
            if (type == TEXT) {
                Message *m = [Message new];
                m.content = message.body;
                m.msgType = TEXT;
                m.from = from;
                m.type = OTHER;
                
                [self.dataSource addObject:m];
                [self reload];
            }else if(type == IMAGE){
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
            }else if(type == RECORD){
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

#pragma mark - ChatInputViewDelegate
-(void)send:(NSString *)msg{
    if (![msg isEqualToString:@""]) {
        [[XmppTools sharedManager] sendTextMsg:msg withId:self.toUser];
        Message *m = [Message new];
        m.content = msg;
        m.msgType = TEXT;
        m.type = ME;
        m.to = self.toUser;
        m.from = [XmppTools sharedManager].userName;
        [self.dataSource addObject:m];
        [self reload];
    }
}

-(void)recordFinish:(NSURL *)url withTime:(float)time{
    self.url = url;
    NSData *data = [[NSData alloc]initWithContentsOfURL:self.url];
    [self sendRecordMessageWithData:data bodyName:@"[语音]" withTime:time];
}

//选择图片
- (void)selectImg{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImageJPEGRepresentation(image,0.3);
    [self sendMessageWithData:data bodyName:@"[图片]"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 发送图片 */
- (void)sendMessageWithData:(NSData *)data bodyName:(NSString *)name
{
    
    XMPPJID *jid = [[XmppTools sharedManager] getJIDWithUserId:self.toUser];
    XMPPMessage *message = [XMPPMessage messageWithType:CHATTYPE to:jid];
    
    [message addBody:name];
    
    // 转换成base64的编码
    NSString *base64str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // 设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64str];
    
    // 包含子节点
    [message addChild:attachment];
    
    XMPPElement *typeElement = [XMPPElement elementWithName:@"MSGTYPE" stringValue:[NSString stringWithFormat:@"%d",IMAGE]];
    [message addChild:typeElement];
    
    // 发送消息
    [[XmppTools sharedManager].xmppStream sendElement:message];
    
    
    
    Message *m = [Message new];
    m.content = base64str;
    m.msgType = IMAGE;
    m.from =  [XmppTools sharedManager].userName;
    m.type = ME;
    m.to = self.toUser;
    [self.dataSource addObject:m];
    [self reload];
    
}

/** 发送录音 */
- (void)sendRecordMessageWithData:(NSData *)data bodyName:(NSString *)name withTime:(float)time
{
    
    XMPPJID *jid = [[XmppTools sharedManager] getJIDWithUserId:self.toUser];
    XMPPMessage *message = [XMPPMessage messageWithType:CHATTYPE to:jid];
    
    [message addBody:name];
    
    // 转换成base64的编码
    NSString *base64str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // 设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64str];
    
    // 包含子节点
    [message addChild:attachment];
    
    // 设置节点内容
    XMPPElement *timeElement = [XMPPElement elementWithName:@"time" stringValue:[NSString stringWithFormat:@"%f",time]];
    [message addChild:timeElement];
    
    XMPPElement *typeElement = [XMPPElement elementWithName:@"MSGTYPE" stringValue:[NSString stringWithFormat:@"%d",RECORD]];
    [message addChild:typeElement];
    // 发送消息
    [[XmppTools sharedManager].xmppStream sendElement:message];
    
    
    
    Message *m = [Message new];
    m.content = base64str;
    m.msgType = RECORD;
    m.voiceTime = [NSString stringWithFormat:@"%.2f",time];
    m.from =  [XmppTools sharedManager].userName;
    m.type = ME;
    m.to = self.toUser;
    [self.dataSource addObject:m];
    [self reload];
    
}

#pragma mark - 监听事件
- (void) keyboardWillChangeFrame:(NSNotification *)note{
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat transformY = keyboardFrame.origin.y - self.view.height;
    [UIView animateWithDuration:duration animations:^{
        self.inputText.transform = CGAffineTransformMakeTranslation(0, transformY-64);
        CGRect f = self.table.frame;
        NSLog(@"-------%f",transformY);
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
        _inputText.delegate = self;
    }
    return _inputText;
}

@end
