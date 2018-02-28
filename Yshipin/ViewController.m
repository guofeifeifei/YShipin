//
//  ViewController.m
//  Yshipin
//
//  Created by ZZCN77 on 2017/10/12.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "ViewController.h"
#import <WilddogCore/WilddogCore.h>
#import <WilddogAuth/WilddogAuth.h>
#import <WilddogVideoCall/WilddogVideoCall.h>
#import "HMScannerController.h"
#import "SignView.h"
@interface ViewController ()<WDGVideoCallDelegate, WDGConversationDelegate>
@property (nonatomic, strong) WDGLocalStream *localStream;
@property (nonatomic, strong) WDGConversation *conversation;
@property (nonatomic, strong) WDGAuth *auth;
@property (nonatomic, strong) WDGVideoView *localView;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UILabel *idLable;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *erweimaBtn;
@property (nonatomic, strong) UIButton *changeCameraBtn;
@property (nonatomic, assign)  CGFloat brightnessDefaut;
@end

@implementation ViewController
-(long int)getRandomNumber:(long int)from to:(long int)to
{
    return (long int)(from + (arc4random() % (to - from + 1)));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.brightnessDefaut =  [UIScreen mainScreen].brightness;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", self.brightnessDefaut] forKey:@"brightnessDefaut"];
    NSLog(@"%ld", self.brightnessDefaut);
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"bg"].CGImage);

    //初始化 Auth SDK
    //wd2594166845uulehn
    [self.view addSubview:self.localView];
    NSString *appUrlID = @"wd2594166845uulehn";
    WDGOptions *options = [[WDGOptions alloc] initWithSyncURL:[NSString stringWithFormat:@"https://%@.wilddogio.com", appUrlID]];
    [WDGApp configureWithOptions:options];
    
    self.auth = [WDGAuth auth];
    WDGLocalStreamOptions *localStreamOptions = [[WDGLocalStreamOptions alloc] init];
    localStreamOptions.shouldCaptureVideo = YES;
    localStreamOptions.shouldCaptureAudio = YES;
    localStreamOptions.dimension = WDGVideoDimensions480p;
    localStreamOptions.maxFPS = 20;

    self.localStream = [WDGLocalStream localStreamWithOptions:localStreamOptions];
    self.localStream.audioEnabled = YES;
    //注册
    NSString *appID = @"";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"username"] == nil) {
        appID = [NSString stringWithFormat:@"%ld@qq.com",  [self getRandomNumber:10000 to:100000]];
       //去注册
        [self registered:appID];
    }else{
        appID = [userDefaults objectForKey:@"username"];
        [self login:appID];
    }
    self.idLable = [[UILabel alloc] initWithFrame:CGRectMake(KMainScreenWidth - 170 * widthScale, 160 * widthScale, 300 * widthScale, 20 * widthScale)];
    self.idLable.font = [UIFont systemFontOfSize:16 * widthScale];
    self.idLable.textColor = [UIColor colorWithRed:222/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1.0];
    self.idLable.backgroundColor = [UIColor clearColor];
    self.idLable.transform = CGAffineTransformRotate(self.idLable.transform, M_PI/2);
    self.idLable.text =[NSString stringWithFormat:@"ID:%@",  [userDefaults objectForKey:@"meID"]];
    self.idLable.textAlignment = 0;
    [self.view addSubview:self.idLable];
    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(KMainScreenWidth - 70 * widthScale,KMainScreenHeight - 120 * widthScale, 90 * widthScale, 20 * widthScale)];
    titleLable.font = [UIFont systemFontOfSize:16 * widthScale];
    titleLable.textColor = [UIColor colorWithRed:222/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1.0];
    titleLable.text = @"采集端";
    titleLable.backgroundColor =[UIColor clearColor];
    titleLable.transform = CGAffineTransformRotate(titleLable.transform, M_PI/2);
    titleLable.textAlignment = 0;
    titleLable.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:titleLable];
    self.bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    self.bgView.hidden = YES;
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.changeBtn];
    [self.view addSubview:self.erweimaBtn];
    [self.view addSubview:self.changeCameraBtn];

}
- (void)registered:(NSString *)appID{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //创建一个基于密码的帐户，创建成功后会自动登录
    [self.auth createUserWithEmail:appID password:appID completion:^(WDGUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"注册成功");
            [self login:appID];
            [userDefaults setValue:user.uid forKey:@"meID"];
            self.idLable.text =[NSString stringWithFormat:@"ID:%@",  [userDefaults objectForKey:@"meID"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"注册成功" afterDelay:2];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [GFProgressHUD showMessagewithoutView:@"重试注册请稍等" afterDelay:2];
            });
                 [self registered:appID];
        }
    }];
}
- (void)login:(NSString *)appID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [[WDGAuth auth] signInWithEmail:appID
                           password:appID
                         completion:^(WDGUser *user, NSError *error) {
                             NSLog(@"%@", user);
                             if (!error) {
                                 NSLog(@"登陆成功");
                                 [userDefaults setValue:appID forKey:@"username"];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [GFProgressHUD showMessagewithoutView:@"登录成功" afterDelay:2];
                                     UIAlertView *alertVC = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"当前登录账户ID:%@", user.uid ] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                     [alertVC show];
                                     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                     pasteboard.string = user.uid;
                                     //初始化视频
                                     [self signInAnonymously];
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self.localStream attach:self.localView];
                                     });
                                 });
                             }else{
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [GFProgressHUD showMessagewithoutView:@"重试登录请稍后" afterDelay:2];
                                     
                                 });
                                 NSLog(@"登录失败%@",error.description);
                                      [self login:appID];
                             }
                             
                             
                         }];
}
- (void)signInAnonymously{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    [[WDGAuth auth] signOut:nil];
    [[WDGAuth auth] signInAnonymouslyWithCompletion:^(WDGUser *user, NSError *error) {
        if (!error) {
            // 获取 token
            [user getTokenWithCompletion:^(NSString * _Nullable idToken, NSError * _Nullable error) {
                // 配置 Video Initializer
                NSLog(@"%@", error.description);
                [[WDGVideoInitializer sharedInstance] configureWithVideoAppId:@"wd2594166845uulehn" token:idToken];
                [WDGVideoCall sharedInstance].delegate = self;
            }];
        }
    }];
}
/**
 * `WDGVideo` 通过调用该方法通知当前用户收到新的视频通话邀请。
 * @param video 调用该方法的 `WDGVideo` 实例。
 * @param conversation 代表收到的视频通话的 `WDGConversation` 实例。
 * @param data 随通话邀请传递的 `NSString` 类型的数据。
 */

- (void)wilddogVideoCall:(WDGVideoCall *)videoCall didReceiveCallWithConversation:(WDGConversation *)conversation data:(NSString *)data{
    NSLog(@"接收%@", data);
    self.conversation = conversation;
    self.idLable.text = [NSString stringWithFormat:@"ID:%@",conversation.remoteUid ];
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.localStream attach:self.localView];
        self.localStream.audioEnabled = NO;
        [self.conversation acceptWithLocalStream:self.localStream];
        
    });
}
//播放媒体流
- (void)conversation:(WDGConversation *)conversation didReceiveStream:(WDGRemoteStream *)remoteStream {
    dispatch_async(dispatch_get_main_queue(), ^{
        [GFProgressHUD showMessagewithoutView:@"开始接收视频" afterDelay:2];
            remoteStream.audioEnabled = NO;
        
    });
}
- (void)conversation:(WDGConversation *)conversation didReceiveResponse:(WDGCallStatus)callStatus {
    switch (callStatus) {
        case WDGCallStatusAccepted:
            NSLog(@"通话被接受");
            [GFProgressHUD showMessagewithoutView:@"通话被接受" afterDelay:2];

            break;
        case WDGCallStatusRejected:
            NSLog(@"通话被拒绝");
            [GFProgressHUD showMessagewithoutView:@"通话被拒绝" afterDelay:2];

            break;
        case WDGCallStatusBusy:
            NSLog(@"正忙");
            [GFProgressHUD showMessagewithoutView:@"正忙" afterDelay:2];

            break;
        case WDGCallStatusTimeout:
            NSLog(@"超时");
            [GFProgressHUD showMessagewithoutView:@"超时" afterDelay:2];

            break;
        default:
            NSLog(@"状态未识别");
            [GFProgressHUD showMessagewithoutView:@"状态未识别" afterDelay:2];

            break;
    }
}


- (WDGVideoView *)localView{
    if (_localView == nil) {
//self.localView = [[WDGVideoView alloc] initWithFrame:CGRectMake(20 * widthScale, 20 * widthScale, self.view.frame.size.width - 70 * widthScale, self.view.frame.size.height - 70 * widthScale)];
        self.localView = [[WDGVideoView alloc] initWithFrame:CGRectMake(20 * widthScale, 20 * widthScale, self.view.frame.size.width - 60 * widthScale, self.view.frame.size.height - 80 * widthScale)];
        self.localView.backgroundColor = [UIColor blackColor];
        self.localView.contentMode = UIViewContentModeScaleAspectFill;
        self.localView.mirror = YES;
    }
    return _localView;
}

- (UIButton *)changeBtn{
    if (_changeBtn == nil) {
        self.changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeBtn.frame = CGRectMake(0, KMainScreenHeight - 100 * widthScale, KMainScreenWidth,100 * widthScale);
//        [self.changeBtn setTitle:@"切换" forState:0];
        [self.changeBtn setBackgroundColor:[UIColor clearColor]];
        [self.changeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.changeBtn.selected = NO;
    }
    return _changeBtn;
}
- (UIButton *)changeCameraBtn{
    if (_changeCameraBtn == nil) {
        self.changeCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeCameraBtn.frame = CGRectMake(0,100 * widthScale, 44 * widthScale,KMainScreenHeight- 200 * widthScale);
        //        [self.changeBtn setTitle:@"切换" forState:0];
        [self.changeCameraBtn setBackgroundColor:[UIColor clearColor]];
        [self.changeCameraBtn addTarget:self action:@selector(changeCameraAction:) forControlEvents:UIControlEventTouchUpInside];
        self.changeCameraBtn.selected = NO;
    }
    return _changeCameraBtn;
}
- (void)changeAction:(UIButton *)btn{
    if (btn.selected == YES) {
        //显示
        self.bgView.hidden = YES;
        btn.selected = NO;
        //屏幕亮度调整
        [UIScreen mainScreen].brightness = self.brightnessDefaut;
    }else{
        //隐藏
        self.bgView.hidden = NO;
        btn.selected = YES;
        [UIScreen mainScreen].brightness = 0.0;
    }
}
- (void)changeCameraAction:(UIButton *)btn{
           [self.localStream switchCamera];
    
}
- (UIButton *)erweimaBtn{
    if (_erweimaBtn == nil) {
        self.erweimaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.erweimaBtn.frame = CGRectMake(0,  0 * widthScale, KMainScreenWidth,100 * widthScale);
        [self.erweimaBtn setBackgroundColor:[UIColor clearColor]];
        [self.erweimaBtn addTarget:self action:@selector(erweimaAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _erweimaBtn;
}

- (void)erweimaAction:(UIButton *)btn{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cardName =  [userDefaults objectForKey:@"meID"];
    UIImage *avatar = [UIImage imageNamed:@"avatar"];
    
    [HMScannerController cardImageWithCardName:cardName avatar:avatar scale:0.2 completion:^(UIImage *image) {
        UIWindow *window =[UIApplication sharedApplication].keyWindow;
        SignView *signView = [[SignView alloc] initWithFrame:self.view.bounds];
        signView.bgView.image =image;
        [window addSubview:signView];
    }];
}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    NSError *error = nil;
//    [[WDGAuth auth] signOut:&error];
//    if (!error) {
//        // 退出登录成功
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
