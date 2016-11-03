//
//  XmppTools.h
//  ChatMPP
//
//  Created by zhouMR on 16/10/14.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(void);
typedef void(^FailureBlock)(NSString *error);

// 枚举
typedef NS_ENUM(NSInteger, ConnectToServerPurpose)
{
    ConnectToServerPurposeLogin,
    ConnectToServerPurposeRegister
};

@interface XmppTools : NSObject<XMPPStreamDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate,XMPPReconnectDelegate,UIAlertViewDelegate,XMPPRoomDelegate>
@property (nonatomic, assign) ConnectToServerPurpose connectToServerPurpose;
@property (nonatomic, strong) XMPPStream *xmppStream;

@property (nonatomic,strong)XMPPPresence *receivePresence;
@property (nonatomic,strong)XMPPRoster *xmppRoster;
@property (nonatomic,strong)XMPPRosterMemoryStorage *xmppRosterMemoryStorage;

//群
@property (nonatomic, strong) XMPPRoomCoreDataStorage *roomStorage;
@property (nonatomic, strong) XMPPRoom *xmppRoom;
//自动重连
@property (nonatomic,strong)XMPPReconnect *xmppReconnect;

/** 定时发送心跳包 */
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *userName;


//头像
@property (nonatomic,strong)XMPPvCardAvatarModule *xmppAvatarModule;     //头像模块
@property (nonatomic,strong)XMPPvCardTempModule *xmppvCardModule;        //电子身份模块

//好友
@property(nonatomic,strong)NSMutableArray *contacts;

@property (nonatomic, copy)   SuccessBlock successBlack;
@property (nonatomic, copy)   FailureBlock failureBlack;

+ (instancetype)sharedManager;

//登录方法
- (void)loginWithUser:(NSString*)userName withPwd:(NSString*)userPwd withSuccess:(SuccessBlock)sblock withFail:(FailureBlock)fblock;
//注册方法
- (void)registerWithUser:(NSString *)userName password:(NSString *)password withSuccess:(SuccessBlock)sblock withFail:(FailureBlock)fblock;

//根据userid返回   xmppjid
- (XMPPJID*)getJIDWithUserId:(NSString *)userId;

//用户名+HOST
- (NSString *)idAndHost:(NSString*)userId;

- (XMPPvCardAvatarModule *)avatarModule;    //头像模块;
- (XMPPvCardTempModule *)vCardModule;       //电子名片模块
- (NSData*)getImageData:(NSString *)userId;

- (void)addFriendById:(NSString*)name;

- (void)removeFriend:(NSString *)name;
@end
