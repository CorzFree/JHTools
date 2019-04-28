//
//  PayTypeView.m
//  TSAlertActionDemo
//
//  Created by Dylan Chen on 2017/8/15.
//  Copyright © 2017年 Dylan Chen. All rights reserved.
//

#import "PayTypeView.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface PayTypeView()

@property (strong,nonatomic)UIButton * headerBtn;//头部视图

@property (strong,nonatomic)UIButton * wechatBtn;//确定按钮
@property (strong,nonatomic)UIButton * aliPayBtn;//确定按钮

@property (strong,nonatomic)UIButton * sureBtn;//确定按钮
@property (strong,nonatomic)UIButton * cancelBtn;//取消按钮

@property NSString * trade_type;
@end
@implementation PayTypeView

- (instancetype)init{
    if (self = [super init]) {
        //改变一些本身的属性简易在这里改
        //change some propertys for TSActionAlertView
        NSLog(@"aaaaaa");
    }
    return self;
}

- (void)layoutContainerView{
    //布局containerview的位置,就是那个看得到的视图
    //layout self.containerView   self.containerview is the alertView
    CGFloat hight = 248;
    CGFloat spideLeft = (ScreenWidth - TSACTIONVIEW_CONTAINER_WIDTH)/2;
    CGFloat spideTop = (ScreenHeight - hight) * 0.4;
    self.containerView.frame = CGRectMake(spideLeft, spideTop,TSACTIONVIEW_CONTAINER_WIDTH, hight);
}

- (void)setupContainerViewAttributes{
    //设置containerview的属性,比如切边啥的
    //add propertys for  self.containerView
    _trade_type = @"wechat";
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 15;
    
}

- (void)setupContainerSubViews{
    //给containerview添加子视图
    //add subviews for self.containerView
    [self.containerView addSubview:self.headerBtn];
    [self.containerView addSubview:self.sureBtn];
    [self.containerView addSubview:self.cancelBtn];
    
    [self.containerView addSubview:self.wechatBtn];
    [self.containerView addSubview:self.aliPayBtn];
}

- (void)layoutContainerViewSubViews{
    //设置子视图的frame
    self.headerBtn.frame = CGRectMake(0, 0, TSACTIONVIEW_CONTAINER_WIDTH, 50);
    self.cancelBtn.frame = CGRectMake(17, 190, (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 44);
    self.sureBtn.frame = CGRectMake(17*2 + (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 190, (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 44);
    
    self.wechatBtn.frame = CGRectMake((TSACTIONVIEW_CONTAINER_WIDTH-204)/3, 100, 102, 47);
    self.aliPayBtn.frame = CGRectMake((TSACTIONVIEW_CONTAINER_WIDTH-204)/3*2+102, 100, 102, 47);
}


#pragma mark - Action
- (void)sureAction{
    //确定操作
    if (self.stringHandler) {
        self.stringHandler(self,200,_trade_type);
    }
    [self dismissAnimated:YES];
}

- (void)wechatAction{
    //
    [_wechatBtn.layer setBorderWidth:1];
    [_aliPayBtn.layer setBorderWidth:0];
    _trade_type = @"wechat";
}

- (void)aliPayAction{
    //
    [_wechatBtn.layer setBorderWidth:0];
    [_aliPayBtn.layer setBorderWidth:1];
    _trade_type = @"aliPay";
}

- (void)cancaleAction{
    //取消操作
    [self dismissAnimated:YES];
}
#pragma mark - Lazy

//头部视图
- (UIButton *)headerBtn{
    if (_headerBtn == nil) {
        _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerBtn.backgroundColor = [UIColor redColor];
        [_headerBtn setTitle:@"选择支付渠道" forState:UIControlStateNormal];
        _headerBtn.userInteractionEnabled = NO;
    }
    return _headerBtn;
}

//确定
- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = [UIColor redColor];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

//取消
- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor =[UIColor lightGrayColor];
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancaleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

//wechat
- (UIButton *)wechatBtn{
    if (_wechatBtn == nil) {
        _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_wechatBtn setImage:[UIImage imageNamed:@"recharge_wechat"] forState:UIControlStateNormal];
        [_wechatBtn.layer setBorderColor:[UIColor redColor].CGColor];
        [_wechatBtn.layer setBorderWidth:1];
        [_wechatBtn.layer setMasksToBounds:YES];
        [_wechatBtn addTarget:self action:@selector(wechatAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatBtn;
}
//aliPay
- (UIButton *)aliPayBtn{
    if (_aliPayBtn == nil) {
        _aliPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_aliPayBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_aliPayBtn setImage:[UIImage imageNamed:@"recharge_ali"] forState:UIControlStateNormal];
        [_aliPayBtn.layer setBorderColor:[UIColor redColor].CGColor];
        [_aliPayBtn.layer setBorderWidth:0];
        [_aliPayBtn.layer setMasksToBounds:YES];
        [_aliPayBtn addTarget:self action:@selector(aliPayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aliPayBtn;
}

@end

