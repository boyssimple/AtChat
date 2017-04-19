//
//  XmppClient.h
//  AtChat
//
//  Created by zhouMR on 2017/4/19.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlocks)(void);
typedef void(^FailureBlocks)(NSString *error);

@interface XmppClient : NSObject
/**
 *  API调用单例
 *
 *  @return 返回一个单例对象
 */
+ (instancetype)shareClient;

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
      failure:(FailureBlocks)failureBlock;

/**
 *  注销登录
 */
- (void)logout;

/**
 *  注册接口
 *
 *  @param username      账号jid
 *  @param password 密码
 */
- (void)registerUser:(NSString *)username
            password:(NSString *)password
             success:(SuccessBlocks)successBlock
            failture:(FailureBlocks)failureBlock;

#pragma mark - Roster
/**
 *  发送好友申请
 *
 *  @param username    对方的username
 *  @param reason 附带内容
 */
- (void)addUser:(NSString *)username reason:(NSString *)reason;
/**
 *  获取好友列表
 *
 *  @return 好友数组
 */
- (NSArray *)getUsers;

/**
 *  接受对方的好友请求
 *
 *  @param username  对方的username
 *  @param flag 是否同时请求加对方为好友，YES:请求加对方，NO:不请求加对方
 */
- (void)acceptAddRequestFrom:(NSString *)username andAddRoster:(BOOL)flag;

/**
 *  拒绝对方的好友请求
 *
 *  @param username 对方的username
 */
- (void)rejectAddRequestFrom:(NSString*)username;

/**
 *  删除某个好友
 *
 *  @param username 要删除好友的username
 */
- (void)removeUser:(NSString*)username;

/**
 *  为好友设置备注
 *
 *  @param nickname 备注
 *  @param username      好友的username
 */
- (void)setNickname:(NSString *)nickname forUser:(NSString *)username;

#pragma mark - 单聊
/**
 *  发送文字消息
 *
 *  @param message  文本
 *  @param username 对方的username
 */
- (void)sendMessage:(NSString *)message toUser:(NSString *)username;

/**
 *  发送信令消息
 *
 *  @param message
 *  @param jidStr  对方jidStr
 */
- (void)sendSignalingMessage:(NSString *)message toUser:(NSString *)jidStr;

@end
