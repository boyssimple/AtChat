//
//  VCMain.m
//  LifeChat
//
//  Created by simple on 16/4/23.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "VCMain.h"
#import "VCNavBase.h"
#import "VCMessages.h"
#import "VCFriends.h"
#import "VCTimeline.h"
#import "VCMine.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
@interface VCMain ()<UITabBarControllerDelegate>

@end

@implementation VCMain

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"VCMessages",
                                   kTitleKey  : @"消息",
                                   kImgKey    : @"TabMessageIcon",
                                   kSelImgKey : @"TabMessageIcon"},
                                 
                                 @{kClassKey  : @"VCFriends",
                                   kTitleKey  : @"好友",
                                   kImgKey    : @"TabFriendIcon",
                                   kSelImgKey : @"TabFriendIcon"},
                                 
                                 @{kClassKey  : @"VCTimeline",
                                   kTitleKey  : @"朋友圈",
                                   kImgKey    : @"TabDiscoverIcon",
                                   kSelImgKey : @"TabDiscoverIcon"},
                                 
                                 @{kClassKey  : @"VCMine",
                                   kTitleKey  : @"我的",
                                   kImgKey    : @"TabMeIcon",
                                   kSelImgKey : @"TabMeIcon"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        VCNavBase *nav = [[VCNavBase alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [UIImage imageNamed:dict[kSelImgKey]];
//        [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    NSInteger index = tabBarController.selectedIndex;
//    if (index == 0) {
//        tabBarController.navigationItem.title = @"消息";
//    }else if (index == 1){
//        tabBarController.navigationItem.title = @"好友";
//    }else if (index == 2){
//        tabBarController.navigationItem.title = @"我";
//    }
//}

@end
