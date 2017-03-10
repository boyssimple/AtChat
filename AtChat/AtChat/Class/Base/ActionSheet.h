//
//  ActionSheet.h
//  AtChat
//
//  Created by zhouMR on 2017/3/10.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionSheetDelegate;
static UIWindow *actionWindow = nil;

@interface ActionSheet : UIWindow{
    UIView *blackBg;
    UIView *mainBg;
}
@property (nonatomic, strong)NSArray *array;//菜单数组;
@property(nonatomic,assign)id<ActionSheetDelegate>delegate;
@property(nonatomic,strong)NSDictionary *data;
- (void)show;
- (void)dismiss;
- (id)initWithActions:(NSArray*)actions;
@end


#pragma mark ----------- 协议
@protocol ActionSheetDelegate <NSObject>

@optional
- (void)actionSheetClickedButtonAtIndex:(NSInteger)buttonIndex;
@end
