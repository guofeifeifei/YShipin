//
//  SignView.h
//  LDNS
//
//  Created by ZZCN77 on 2017/9/30.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignView : UIView
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *saveBtn;

- (void)cancleViewAction;
@end
