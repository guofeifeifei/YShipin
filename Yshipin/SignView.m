//
//  SignView.m
//  LDNS
//
//  Created by ZZCN77 on 2017/9/30.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "SignView.h"
#import <Photos/Photos.h>
@implementation SignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatView];
        
    }
    return self;
}
- (void)creatView{
    self.backgroundColor = [UIColor clearColor];
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    
    [self addSubview:self.blackView];
    [self addSubview:self.bgView];
    self.bgView.alpha = 0.0;
  
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.frame.size.width, self.bgView.frame.size.width/1.62)];
    imgView.image = [UIImage imageNamed:@"Sign"];
    [self.bgView addSubview:imgView];
//    [self addSubview:self.contentLable];
    

    [self addSubview:self.saveBtn];
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizerTap setNumberOfTapsRequired:1];
    recognizerTap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:recognizerTap];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.5;
        self.bgView.alpha = 1.0;
        
    }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0 animations:^{
                             self.blackView.alpha = 0.5;
                         }];
                     }];
    
}
- (UIImageView *)bgView{
    if (_bgView == nil) {
        self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake( KMainScreenWidth/2-100 * widthScale, KMainScreenHeight / 2 - 200 * widthScale,200* widthScale , 200 * widthScale)];
        
    }
    return _bgView;
}
- (void)loadImageFinished{
    if (self.bgView.image != nil) {
 
    UIImageWriteToSavedPhotosAlbum(self.bgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (!error) {
        [GFProgressHUD showMessagewithoutView:@"保存成功" afterDelay:2];
    }
}


- (UIButton *)saveBtn{
    if (_saveBtn == nil) {
        self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saveBtn.frame = CGRectMake( KMainScreenWidth/2 - 50 * widthScale, KMainScreenHeight / 2 + 50 * widthScale,100* widthScale , 40 * widthScale);
        [self.saveBtn setTitle:@"保存到本地" forState:0];
        [self.saveBtn addTarget:self action:@selector(loadImageFinished) forControlEvents:UIControlEventTouchUpInside];
        [self.saveBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:0];
        self.saveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.saveBtn.layer.borderWidth = 1;
        self.saveBtn.layer.cornerRadius = 20 * widthScale;
    }
    return _saveBtn;
}
- (UILabel *)contentLable{
    if (_contentLable == nil) {
        self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bgView.frame.size.width/1.62 + 10 * widthScale,self.bgView.frame.size.width, 20 * widthScale)];
        self.contentLable.textAlignment = 1;
        self.contentLable.font = [UIFont systemFontOfSize:16 * widthScale];
        self.contentLable.text = @"当前积分:680";
        
    }
    return _contentLable;
}
- (void)handleTapBehind:(UITapGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateEnded){
    
        CGPoint location = [sender locationInView:nil];
        
        if (![self.saveBtn pointInside:[self.saveBtn convertPoint:location fromView:self] withEvent:nil]){
            
            [self cancleViewAction];
        }
        
    }
    
}
#pragma mark ------- 上传图片出来的弹框
- (void)cancleViewAction{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.0;
        self.bgView.alpha = 0.0;
        
    }
                     completion:^(BOOL finished) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             
                             [self.blackView removeFromSuperview];
                             [self removeFromSuperview];
                         });
                         
                     }];
    
    
    
    
}



@end
