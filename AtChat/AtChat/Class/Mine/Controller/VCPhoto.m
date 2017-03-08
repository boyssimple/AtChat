//
//  VCPhoto.m
//  AtChat
//
//  Created by zhouMR on 2017/3/7.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "VCPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface VCPhoto ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XMPPvCardTempModuleDelegate>
@property (nonatomic, strong) UIImageView *ivImg;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation VCPhoto

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ShareImg"] style:UIBarButtonItemStylePlain target:self action:@selector(operationAction)];
    _ivImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, (DEVICEHEIGHT-DEVICEWIDTH)/2.0-NAV_STATUS_HEIGHT, DEVICEWIDTH, DEVICEWIDTH)];
    [self.view addSubview:_ivImg];
    
    [self loadData];
}

- (void)loadData{
    NSData *photoData = [[XmppTools sharedManager] getImageData:[XmppTools sharedManager].userJid.user];
    
    UIImage *headImg;
    if (photoData) {
        headImg = [UIImage imageWithData:photoData];
        
        self.ivImg.image = headImg;
    }
}

- (void)operationAction{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                destructiveButtonTitle:@"拍照"
                                                     otherButtonTitles:@"从手机相册选择",@"保存图片",nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        self.operation = OPERATIONIMAGEMAKEPHOTO;
        [self takePicture];
    }else if(buttonIndex == 1){
        self.operation = OPERATIONIMAGESELECT;
        [self selectImg];
    }else if(buttonIndex == 2){
        [self saveImg];
    }
}

//选择图片
- (void)selectImg{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    if (self.operation == OPERATIONIMAGEMAKEPHOTO) {
        // 如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing) {
            // 获取编辑后的照片
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else{
            // 获取原始照片
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }else{
        
        image = info[UIImagePickerControllerOriginalImage];
    }
    if (image) {
        [self upload:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 * 上传头像
 */
- (void) upload:(UIImage*)image {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"上传中...";
    XMPPvCardTempModule *xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance]];
    [xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    dispatch_queue_t  global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(global_queue, ^{
        
        NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard"];
        [vCardXML addAttributeWithName:@"xmlns" stringValue:@"vcard-temp"];
        NSXMLElement *photoXML = [NSXMLElement elementWithName:@"PHOTO"];
        NSXMLElement *typeXML = [NSXMLElement elementWithName:@"TYPE" stringValue:@"image/jpeg"];
        
        NSData *dataFromImage = UIImageJPEGRepresentation(image, 0.3f);//图片放缩
        
        NSXMLElement *binvalXML = [NSXMLElement elementWithName:@"BINVAL" stringValue:[dataFromImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        [photoXML addChild:typeXML];
        [photoXML addChild:binvalXML];
        [vCardXML addChild:photoXML];
        
        XMPPvCardTemp * myvCardTemp = (XMPPvCardTemp*)[xmppvCardTempModule myvCardTemp];
        if (myvCardTemp) {
            myvCardTemp.photo = dataFromImage;
            [xmppvCardTempModule activate: [XmppTools sharedManager].xmppStream];
            [xmppvCardTempModule updateMyvCardTemp:myvCardTemp];
        }else {
            XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
            [xmppvCardTempModule activate: [XmppTools sharedManager].xmppStream];
            [xmppvCardTempModule updateMyvCardTemp:newvCardTemp];
        }
    });
}

- (void)saveImg{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        [Toast show:self.view withMsg:@"请开启相册权限"];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"保存中...";
        UIImageWriteToSavedPhotosAlbum(self.ivImg.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

/**
 * 上传头像回调方法
 */
-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid
{
    NSLog(@"%s__%d|",__func__,__LINE__);
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    NSLog(@"%s__%d|",__func__,__LINE__);
    [self loadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Toast show:self.view withMsg:@"上传成功"];
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error{
    NSLog(@"%s__%d|%@",__func__,__LINE__,[error description]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Toast show:self.view withMsg:@"上传失败"];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (!error) {
        [Toast show:self.view withMsg:@"成功保存到相册"];
    }else
    {
        [Toast show:self.view withMsg:@"保存失败"];
    }
}


/**
 *  拍照的回调方法
 */
- (void)takePicture {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


/**
 *  点击相册取消按钮的回调方法
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        // 判断现在可以获得多媒体的方式
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            // 设置image picker的来源，这里设置为摄像头
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 设置使用哪个摄像头，这里设置为后置摄像头
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        else {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        // 允许编辑
        _imagePicker.allowsEditing=YES;
        // 设置代理，检测操作
        _imagePicker.delegate=self;
    }
    return _imagePicker;
}
@end
