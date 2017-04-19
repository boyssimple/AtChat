//
//  WebRTCClient.h
//  ChatDemo
//
//  Created by Harvey on 16/5/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RTCView.h"

@interface WebRTCClient : NSObject

@property (strong, nonatomic)   RTCView            *rtcView;

@property (copy, nonatomic)     NSString            *myJID;  /**< 自己的JID */
@property (copy, nonatomic)     NSString            *remoteJID;    /**< 对方JID */

+ (instancetype)sharedInstance;

- (void)startEngine;

- (void)stopEngine;

- (void)showRTCViewByRemoteName:(NSString *)remoteName isVideo:(BOOL)isVideo isCaller:(BOOL)isCaller;

- (void)resizeViews;

@end
