//
//  FaceView.h
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate;
@interface FaceView : UIView
@property (nonatomic, weak) id<FaceViewDelegate> delegate;
@end

@protocol FaceViewDelegate <NSObject>

- (void)selectFaceVoiw:(NSString*)face;
- (void)sendActionWithBtn;

@end
