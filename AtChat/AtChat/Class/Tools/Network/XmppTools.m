//
//  XmppTools.m
//  ChatMPP
//
//  Created by zhouMR on 16/10/14.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "XmppTools.h"

@implementation XmppTools

+ (instancetype)sharedManager{
    static XmppTools *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XmppTools alloc]init];
    });
    return manager;
}

- (id)init{
    if (self = [super init]) {
        [self setupStream];
    }
    return self;
}

- (void)setupStream{
    _xmppStream = [[XMPPStream alloc] init];
    _xmppStream.enableBackgroundingOnSocket = YES;
    // 在多线程中运行，为了不阻塞UI线程，
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _xmppAutoPing = [[XMPPAutoPing alloc] init];
    
    [_xmppAutoPing setPingInterval:1];
    [_xmppAutoPing setRespondsToQueries:YES];
    [_xmppAutoPing activate:_xmppStream];
    [_xmppAutoPing addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    
    // 2.autoReconnect 自动重连
    _xmppReconnect = [[XMPPReconnect alloc] init];
    [_xmppReconnect activate:self.xmppStream];
    [_xmppReconnect setAutoReconnect:YES];
    [_xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    // 3.好友模块 支持我们管理、同步、申请、删除好友
    _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage];
    [_xmppRoster activate:self.xmppStream];
    
    //同时给_xmppRosterMemoryStorage 和 _xmppRoster都添加了代理
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //设置好友同步策略,XMPP一旦连接成功，同步好友到本地
    [_xmppRoster setAutoFetchRoster:YES]; //自动同步，从服务器取出好友
    //关掉自动接收好友请求，默认开启自动同意
    [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:NO];
}

/**
 *  登录方法
 *  @prarm userName 用户名
 *  @prarm userPwd  密码
 */
- (void)loginWithUser:(NSString*)userName withPwd:(NSString*)userPwd withSuccess:(SuccessBlock)sblock withFail:(FailureBlock)fblock{
    self.connectToServerPurpose = ConnectToServerPurposeLogin;
    self.successBlack = sblock;
    self.failureBlack = fblock;
    self.userPassword = userPwd;
    self.userName = userName;
    [self connection:userName];
}

/**
 * 注册方法
 *  @prarm userName 用户名
 *  @prarm userPwd  密码
 */
- (void)registerWithUser:(NSString *)userName password:(NSString *)password withSuccess:(SuccessBlock)sblock withFail:(FailureBlock)fblock
{
    self.connectToServerPurpose = ConnectToServerPurposeRegister;
    self.successBlack = sblock;
    self.failureBlack = fblock;
    self.userPassword = password;
    [self connection:userName];
}

//连接服务器
- (void)connection:(NSString*)userName{
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:XMPP_HOST resource:XMPP_PLATFORM];
    [self.xmppStream setMyJID:jid];
    // 发送请求
    if ([self.xmppStream isConnected] || [self.xmppStream isConnecting]) {
        // 先发送下线状态
        XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
        [self.xmppStream sendElement:presence];
        
        // 断开连接
        [self.xmppStream disconnect];
    }
    NSError *error;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    NSLog(@"socket正在连接...");
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    NSLog(@"socket连接成功...");
    // 连接成功之后，由客户端xmpp发送一个stream包给服务器，服务器监听来自客户端的stream包，并返回stream feature包
}


- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"️xmpp连接失败...%@",error);
}

/**
 *  xmpp连接成功之后走这里
 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"xmpp正在授权......");
    NSError *error;
    switch (self.connectToServerPurpose) {
        case ConnectToServerPurposeLogin:
            [self.xmppStream authenticateWithPassword:self.userPassword error:&error];
            break;
        case ConnectToServerPurposeRegister:
            [self.xmppStream registerWithPassword:self.userPassword error:&error];
            
        default:
            break;
    }
}

/**
 *  密码验证成功（即登录成功）
 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    //NSLog(@"xmpp授权成功。");
    //设置当前用户上线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
    self.successBlack();
}

/**
 *  密码验证失败
 */
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    //NSLog(@"️xmpp授权失败:%@", error.description);
    self.failureBlack(error.description);
}

/**
 *  注册成功
 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    self.successBlack();
}

/**
 *  注册失败
 */
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    self.failureBlack(error.description);
}

-(void)goOffLine{
    //生成网络状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    //改变通道状态
    [self.xmppStream sendElement:presence];
    //断开链接
    [self.xmppStream disconnect];
}


//接收消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"%@-----%@----%@-----%@",message.from.user,message.body,message.type,message.to.user);
    
}

#pragma mark - XMPPReconnectDelegate
//重新失败时走该方法
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags{
    NSLog(@"执行重连didDetectAccidentalDisconnect----%d",connectionFlags);
}

//接受自动重连
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags{
    NSLog(@"执行重连shouldAttemptAutoReconnect");
    return TRUE;
}



#pragma mark ===== 好友模块 委托=======
/** 收到出席订阅请求（代表对方想添加自己为好友) */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //添加好友一定会订阅对方，但是接受订阅不一定要添加对方为好友
    self.receivePresence = presence;
    
    NSString *message = [NSString stringWithFormat:@"【%@】想加你为好友",presence.from.bare];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.xmppRoster rejectPresenceSubscriptionRequestFrom:_receivePresence.from];
    } else {
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:_receivePresence.from andAddToRoster:YES];
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //收到对方取消定阅我得消息
    if ([presence.type isEqualToString:@"unsubscribe"]) {
        //从我的本地通讯录中将他移除
        [self.xmppRoster removeUser:presence.from];
    }
}


#pragma  mark --------------------自定义方法
- (XMPPJID*)getJIDWithUserId:(NSString *)userId{
    XMPPJID *chatJID = [XMPPJID jidWithString:[self idAndHost:userId]];
    return chatJID;
}

//用户名+HOST
- (NSString *)idAndHost:(NSString*)userId{
    NSString *baseStr = [NSString stringWithFormat:@"%@@%@/%@",userId,XMPP_HOST,XMPP_PLATFORM];
    NSLog(@"%@",baseStr);
    return baseStr;
}

@end
