//
//  ChatInputView.h
//  MsgCell
//
//  Created by simple on 16/3/6.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FaceView.h"
//录音
#import <AVFoundation/AVFoundation.h>

@protocol ChatInputDelegate <NSObject>

@optional
-(void)send:(NSString *)msg;
-(void)recordFinish:(NSURL *)url withTime:(float)time;
-(void)selectImg;

//显示表情时应该处理高
- (void)handleHeight:(CGFloat)height;
@end

@interface ChatInputView : UIView<UITextViewDelegate,FaceViewDelegate>
{
    UITextView *inputText;
    FaceView *faceView;
    BOOL showFace;
    BOOL isKeyboard;
    NSArray* faceData;
}

-(void)hide;
@property (nonatomic, assign) BOOL isOpend;
@property(nonatomic,assign)id<ChatInputDelegate>delegate;
@property (nonatomic, strong) UIButton *recordImg;
@property (nonatomic, strong) UIButton *btnRecord;

//录音
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end
