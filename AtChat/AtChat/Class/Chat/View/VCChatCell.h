//
//  VCChatCell.h
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@protocol VCChatCellDelegate;

@interface VCChatCell : UITableViewCell
@property (nonatomic, weak) id<VCChatCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *index;
-(void)loadData:(XMPPMessageArchiving_Message_CoreDataObject *)msg;
+ (CGFloat)calHeight:(XMPPMessageArchiving_Message_CoreDataObject *)msg;
@end

@protocol VCChatCellDelegate <NSObject>

- (void)chat:(VCChatCell*)cell didSelectWithType:(NSInteger)type withUrl:(NSURL*)url withIndex:(NSIndexPath*)index;

@end
