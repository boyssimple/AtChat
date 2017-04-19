//
//  XmppClient.m
//  AtChat
//
//  Created by zhouMR on 2017/4/19.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "XmppClient.h"

@implementation XmppClient

static XmppClient *_instance;

/**
 *  API调用单例
 *
 *  @return 返回一个单例对象
 */
+ (instancetype)shareClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [XmppClient new];
    });
    
    return _instance;
}

#pragma mark - override method
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

#pragma mark - 接口API
/**
 *  登录接口
 *
 *  @param username     用户名，目前用jid
 *  @param password     密码
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 */
- (void)login:(NSString *)username
     password:(NSString *)password
      success:(SuccessBlocks)successBlock
      failure:(FailureBlocks)failureBlock
{
    XMPPJID *JID = [[XmppTools sharedManager]getJIDWithUserId:username];
    [[XmppTools sharedManager] loginWithUser:JID withPwd:password withSuccess:successBlock withFail:failureBlock];
}

/**
 *  注销登录
 */
- (void)logout
{
    [[XmppTools sharedManager] goOffLine];
}

/**
 *  注册接口
 *
 *  @param JID      账号jid
 *  @param password 密码
 */
- (void)registerUser:(NSString *)username
            password:(NSString *)password
             success:(SuccessBlocks)successBlock
            failture:(FailureBlocks)failureBlock
{
    XMPPJID *JID = [[XmppTools sharedManager]getJIDWithUserId:username];
    [[XmppTools sharedManager] registerWithUser:JID password:password withSuccess:successBlock withFail:failureBlock];
}

#pragma mark - Roster
/**
 *  发送加好友申请
 *
 *  @param username    对方的username
 *  @param reason 发送
 */
- (void)addUser:(NSString *)username reason:(NSString *)reason
{
    XMPPJID *JID = [[XmppTools sharedManager]getJIDWithUserId:username];
    [[XmppTools sharedManager] .xmppRoster addUser:JID withNickname:nil];
}

/**
 *  获取好友列表
 *
 *  @return 好友数组
 */
- (NSArray *)getUsers
{
    return [XmppTools sharedManager] .xmppRosterMemoryStorage.sortedUsersByAvailabilityName;
}

/**
 *  接受对方的好友请求
 *
 *  @param username  对方的username
 *  @param flag 是否同时请求加对方为好友，YES:请求加对方，NO:不请求加对方
 */
- (void)acceptAddRequestFrom:(NSString *)username andAddRoster:(BOOL)flag
{
    XMPPJID *JID = [[XmppTools sharedManager]getJIDWithUserId:username];
    [[XmppTools sharedManager] .xmppRoster acceptPresenceSubscriptionRequestFrom:JID andAddToRoster:flag];
}

/**
 *  拒绝对方的好友请求
 *
 *  @param username 对方的username
 */
- (void)rejectAddRequestFrom:(NSString*)username
{
    XMPPJID *JID = [[XmppTools sharedManager]getJIDWithUserId:username];
    [[XmppTools sharedManager] .xmppRoster rejectPresenceSubscriptionRequestFrom:JID];
}

/**
 *  删除某个好友
 *
 *  @param username 要删除好友的username
 */
- (void)removeUser:(NSString*)username
{
    XMPPJID *JID = [[XmppTools sharedManager]getJIDWithUserId:username];
    [[XmppTools sharedManager] .xmppRoster removeUser:JID];
}

/**
 *  为好友设置备注
 *
 *  @param nickname 备注
 *  @param username      好友的username
 */
- (void)setNickname:(NSString *)nickname forUser:(NSString *)username
{
    XMPPJID *JID = [[XmppTools sharedManager]getJIDWithUserId:username];
    [[XmppTools sharedManager] .xmppRoster setNickname:nickname forUser:JID];
}

#pragma mark - 单聊
/**
 *  发送文字消息
 *
 *  @param text  文本
 *  @param username 对方的username
 */
- (void)sendMessage:(NSString *)text toUser:(NSString *)username
{
    XMPPJID *JID = [[XmppTools sharedManager]getJIDWithUserId:username];
    XMPPMessage *message = [XMPPMessage messageWithType:CHATTYPE to:JID];
    [message addBody:text];
    [[XmppTools sharedManager] .xmppStream sendElement:message];
    
}

- (void)sendSignalingMessage:(NSString *)message toUser:(NSString *)jidStr
{
    XMPPJID *JID = [XMPPJID jidWithString:jidStr];
    
    XMPPMessage *xmppMessage = [XMPPMessage messageWithType:CHATTYPE to:JID];
    [xmppMessage addBody:message];
    
    [[XmppTools sharedManager] .xmppStream sendElement:xmppMessage];
}


@end
