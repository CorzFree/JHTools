//
//  LoginView.m
//  TSAlertActionDemo
//
//  Created by Dylan Chen on 2017/8/15.
//  Copyright © 2017年 Dylan Chen. All rights reserved.
//

#import "LoginView.h"
#import "SPHTTPManager.h"
#import "SPConst.h"
#import <MBProgressHUD.h>
#import <Foundation/Foundation.h>

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface LoginView()

@property (strong,nonatomic)UIButton * headerBtn;//头部视图
@property (strong,nonatomic)UITextField * inputFieldUserName;//输入框用户名
@property (strong,nonatomic)UITextField * inputFieldPwd;//输入框密码
@property (strong,nonatomic)UITextField * inputFieldCode;//输入框验证码

@property (strong,nonatomic)UITextField * inputFieldPwd1;//输入框密码1
@property (strong,nonatomic)UITextField * inputFieldPwd2;//输入框密码2

@property (strong,nonatomic)UIButton * registerBtn;//注册按钮
@property (strong,nonatomic)UIButton * forgotPwdBtn;//忘记密码按钮

@property (strong,nonatomic)UIButton * loginBtn;//登录按钮

@property (strong,nonatomic)UIButton * pwdCancelBtn;//确定按钮
@property (strong,nonatomic)UIButton * pwdOKBtn;//设置密码按钮

@property (strong,nonatomic)UIButton * sureBtn;//确定按钮
@property (strong,nonatomic)UIButton * cancelBtn;//取消按钮
@property (strong,nonatomic)UIButton * getCodeBtn;//获取验证码按钮

@property (nonatomic,strong)MBProgressHUD *hud;
@property NSInteger flg;

@end
@implementation LoginView

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
    CGFloat hight = 280;
    CGFloat spideLeft = (ScreenWidth - TSACTIONVIEW_CONTAINER_WIDTH)/2;
    CGFloat spideTop = (ScreenHeight - hight) * 0.4;
    self.containerView.frame = CGRectMake(spideLeft, spideTop,TSACTIONVIEW_CONTAINER_WIDTH, hight);
}

- (void)setupContainerViewAttributes{
    //设置containerview的属性,比如切边啥的
    //add propertys for  self.containerView
    
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 15;
    self.containerView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.containerView addGestureRecognizer:singleTap];
}

- (void)setupContainerSubViews{
    //给containerview添加子视图
    //add subviews for self.containerView
    [self.containerView addSubview:self.headerBtn];
    
    [self.containerView addSubview:self.inputFieldUserName];
    [self.containerView addSubview:self.inputFieldPwd];
    [self.containerView addSubview:self.inputFieldCode];
    
    [self.containerView addSubview:self.inputFieldPwd1];
    [self.containerView addSubview:self.inputFieldPwd2];
    
    [self.containerView addSubview:self.registerBtn];
    [self.containerView addSubview:self.forgotPwdBtn];
    
    [self.containerView addSubview:self.loginBtn];
    [self.containerView addSubview:self.pwdOKBtn];
    [self.containerView addSubview:self.pwdCancelBtn];
    
    [self.containerView addSubview:self.sureBtn];
    [self.containerView addSubview:self.cancelBtn];
    [self.containerView addSubview:self.getCodeBtn];
}

- (void)layoutContainerViewSubViews{
    //设置子视图的frame
    self.headerBtn.frame = CGRectMake(0, 0, TSACTIONVIEW_CONTAINER_WIDTH, 50);
    
    self.inputFieldUserName.frame = CGRectMake(TSACTIONVIEW_CONTAINER_WIDTH *0.1 , 70, TSACTIONVIEW_CONTAINER_WIDTH* 0.8, 40);
    self.inputFieldPwd.frame = CGRectMake(TSACTIONVIEW_CONTAINER_WIDTH *0.1 , 130, TSACTIONVIEW_CONTAINER_WIDTH* 0.8, 40);
    
    self.inputFieldPwd1.frame = CGRectMake(TSACTIONVIEW_CONTAINER_WIDTH *0.1 , 70, TSACTIONVIEW_CONTAINER_WIDTH* 0.8, 40);
    self.inputFieldPwd1.hidden = YES;
    self.inputFieldPwd2.frame = CGRectMake(TSACTIONVIEW_CONTAINER_WIDTH *0.1 , 130, TSACTIONVIEW_CONTAINER_WIDTH* 0.8, 40);
    self.inputFieldPwd2.hidden = YES;
    
    self.inputFieldCode.frame = CGRectMake(TSACTIONVIEW_CONTAINER_WIDTH *0.1 , 130, TSACTIONVIEW_CONTAINER_WIDTH* 0.4, 40);
    self.inputFieldCode.hidden = YES;
    self.getCodeBtn.frame = CGRectMake(TSACTIONVIEW_CONTAINER_WIDTH *0.6, 130, TSACTIONVIEW_CONTAINER_WIDTH* 0.3, 40);
    self.getCodeBtn.hidden = YES;
    
    self.cancelBtn.frame = CGRectMake(17, 190, (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 44);
    self.cancelBtn.hidden = YES;
    //[self.cancelBtn setHidden:YES];
    self.sureBtn.frame = CGRectMake(17*2 + (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 190, (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 44);
    self.sureBtn.hidden = YES;
    
    self.loginBtn.frame = CGRectMake(17, 190, (TSACTIONVIEW_CONTAINER_WIDTH - 17*2), 44);
    
    self.pwdCancelBtn.frame = CGRectMake(17, 190, (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 44);
    self.pwdCancelBtn.hidden = YES;
    self.pwdOKBtn.frame = CGRectMake(17*2 + (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 190, (TSACTIONVIEW_CONTAINER_WIDTH - 17*3)/2, 44);
    self.pwdOKBtn.hidden = YES;
    
    self.registerBtn.frame = CGRectMake(30, 242, (TSACTIONVIEW_CONTAINER_WIDTH - 30*3)/2, 30);
    self.forgotPwdBtn.frame = CGRectMake(30*2 + (TSACTIONVIEW_CONTAINER_WIDTH - 30*3)/2, 242, (TSACTIONVIEW_CONTAINER_WIDTH - 30*3)/2, 30);
    
    //初始化
    NSUserDefaults *userDefaults11 = [NSUserDefaults standardUserDefaults];
    NSString *name1 = [userDefaults11 objectForKey:@"userName"];
    NSString *pwd1 = [userDefaults11 objectForKey:@"userPwd"];
    self.inputFieldUserName.text = name1;
    self.inputFieldPwd.text = pwd1;
}


#pragma mark - Action
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"33354545454");
    [self.containerView endEditing:YES];
}

- (void)sureAction{
    //确定操作
    if (self.inputFieldCode.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.containerView
                                    animated:YES];
    [self.hud show:YES];
    
    NSDictionary *postInfo = @{@"tel":self.inputFieldUserName.text,
                               @"password2":self.inputFieldCode.text};
    NSLog(@"333-->>\n%@",postInfo);
    __weak typeof(self) weakSelf = self;
    [[SPHTTPManager sharedInstance] post:kSPconstWebApiInterface_vCode
                                paramter:postInfo
                                 success:^(id operation, id responseObject) {
                                     [weakSelf.hud hide:YES];
                                     NSDictionary *info = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                     NSLog(@"验证验证码接口返回数据-->>\n%@",info);
                                     
                                     //判断解析是否成功
                                     if (info && [info isKindOfClass:[NSDictionary class]]) {
                                         NSInteger status = [[info objectForKey:@"httpCode"] integerValue];
                                         if (status == 200) {
                                             self.inputFieldUserName.hidden = YES;
                                             self.inputFieldCode.hidden = YES;
                                             self.getCodeBtn.hidden = YES;
                                             self.sureBtn.hidden = YES;
                                             self.cancelBtn.hidden = YES;
                                             
                                             self.inputFieldPwd1.hidden = NO;
                                             self.inputFieldPwd2.hidden = NO;
                                             self.pwdOKBtn.hidden = NO;
                                             self.pwdCancelBtn.hidden = NO;
                                             if([self.headerBtn.titleLabel.text isEqualToString:@"注册账号"]){
                                                 self.flg = 1;
                                             }else{
                                                 self.flg = 0;
                                             }
                                             [self.headerBtn setTitle:@"设置密码" forState:UIControlStateNormal];
                                             
                                         }else{
                                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[info objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                             [alert show];
                                         }
                                     }
                                 }failure:^(id operation, NSError *error) {
                                     [weakSelf.hud hide:YES];
                                     NSLog(@"调用验证验证码接口失败-->>\n%@",error);
                                 }];
}

- (void)pwdOKAction{
    //设置密码操作
    if (self.inputFieldPwd1.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(![self.inputFieldPwd1.text isEqualToString:self.inputFieldPwd2.text]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *actionT;
    if(_flg == 1){
        actionT = kSPconstWebApiInterface_register;
    }else{
        actionT = kSPconstWebApiInterface_updata;
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.containerView
                                    animated:YES];
    [self.hud show:YES];
    
    NSDictionary *postInfo = @{@"tel":self.inputFieldUserName.text,
                               @"password":self.inputFieldPwd1.text,
                               @"remark":@"ios001"
                               };
    NSLog(@"555-->>\n%@",postInfo);
    
    __weak typeof(self) weakSelf = self;
    [[SPHTTPManager sharedInstance] post:actionT
                                paramter:postInfo
                                 success:^(id operation, id responseObject) {
                                     [weakSelf.hud hide:YES];
                                     NSDictionary *info = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                     NSLog(@"设置密码接口返回数据-->>\n%@",info);
                                     
                                     //判断解析是否成功
                                     if (info && [info isKindOfClass:[NSDictionary class]]) {
                                         NSInteger status = [[info objectForKey:@"httpCode"] integerValue];
                                         if (status == 200) {
                                             [self.headerBtn setTitle:@"游戏登录" forState:UIControlStateNormal];
                                             self.inputFieldUserName.hidden = NO;
                                             self.inputFieldPwd.hidden = NO;
                                             self.loginBtn.hidden = NO;
                                             
                                             self.inputFieldPwd1.hidden = YES;
                                             self.inputFieldPwd2.hidden = YES;
                                             self.pwdOKBtn.hidden = YES;
                                             self.pwdCancelBtn.hidden = YES;
                                             [self setFrameSize:280];
                                         }else{
                                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[info objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                             [alert show];
                                         }
                                     }
                                 }failure:^(id operation, NSError *error) {
                                     [weakSelf.hud hide:YES];
                                     NSLog(@"调用设置密码接口失败-->>\n%@",error);
                                 }];
}

- (void)loginAction{
    //登录操作
    if (self.inputFieldUserName.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.inputFieldPwd.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.containerView
                                    animated:YES];
    [self.hud show:YES];
    
    NSDictionary *postInfo = @{@"tel":self.inputFieldUserName.text,
                               @"password":self.inputFieldPwd.text};
    NSLog(@"33333-->>\n%@",postInfo);
    
    __weak typeof(self) weakSelf = self;
    [[SPHTTPManager sharedInstance] post:kSPconstWebApiInterface_login
                                paramter:postInfo
                                 success:^(id operation, id responseObject) {
                                     [weakSelf.hud hide:YES];
                                     NSDictionary *info = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                     NSLog(@"登录接口返回数据-->>\n%@",info);
                                     
                                     //判断解析是否成功
                                     if (info && [info isKindOfClass:[NSDictionary class]]) {
                                         
                                         NSInteger status = [[info objectForKey:@"httpCode"] integerValue];
                                         
                                         if (status == 200) {
                                             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                             
                                             //添加登录数据
                                            [userDefaults setObject:self.inputFieldUserName.text forKey:@"userName"];
                                             [userDefaults setObject:self.inputFieldPwd.text forKey:@"userPwd"];
                                             
                                             //存储到本地磁盘
                                             [userDefaults synchronize];
                                             
                                             if (self.loginHandler) {
                                                 self.loginHandler(self, status, [info objectForKey:@"openid"]);
                                             }
                                             [self dismissAnimated:YES];
                                         }else{
                                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[info objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                             [alert show];
                                         }
                                     }
                
                                 }failure:^(id operation, NSError *error) {
                                     [weakSelf.hud hide:YES];
                                     NSLog(@"调用登录接口失败-->>\n%@",error);
                                 }];
}

- (void)cancaleAction{
    //取消操作
    NSLog(@"注册%d",10);
    [self.headerBtn setTitle:@"游戏登录" forState:UIControlStateNormal];
    self.inputFieldUserName.hidden = NO;
    self.inputFieldPwd.hidden = NO;
    self.loginBtn.hidden = NO;
    
    self.inputFieldCode.hidden = YES;
    self.getCodeBtn.hidden = YES;
    self.sureBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.pwdCancelBtn.hidden = YES;
    self.pwdOKBtn.hidden = YES;
    self.inputFieldPwd1.hidden = YES;
    self.inputFieldPwd2.hidden = YES;
    
    [self setFrameSize:280];
    //[self dismissAnimated:YES];
}

- (void)registerAction{
    NSLog(@"注册%d",10);
    [self.headerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    self.inputFieldPwd.hidden = YES;
    self.loginBtn.hidden = YES;
    
    self.inputFieldCode.hidden = NO;
    self.getCodeBtn.hidden = NO;
    self.sureBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
    
    [self setFrameSize:248];
}

- (void)forgotPwdAction{
    NSLog(@"找回密码%d",10);
    [self.headerBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    self.inputFieldPwd.hidden = YES;
    self.loginBtn.hidden = YES;
    
    self.inputFieldCode.hidden = NO;
    self.getCodeBtn.hidden = NO;
    self.sureBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
    
    [self setFrameSize:248];
}

- (void)getCodeAction{
    NSLog(@"获取验证码%d",10);
    if (self.inputFieldUserName.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.containerView
                                    animated:YES];
    [self.hud show:YES];
    
    NSDictionary *postInfo = @{@"tel":self.inputFieldUserName.text};
    NSLog(@"222-->>\n%@",postInfo);
    __weak typeof(self) weakSelf = self;
    [[SPHTTPManager sharedInstance] post:kSPconstWebApiInterface_getCode
                                paramter:postInfo
                                 success:^(id operation, id responseObject) {
                                     [weakSelf.hud hide:YES];
                                     NSDictionary *info = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                     NSLog(@"获取验证码接口返回数据-->>\n%@",info);
                                     
                                     //判断解析是否成功
                                     if (info && [info isKindOfClass:[NSDictionary class]]) {
                                         NSInteger status = [[info objectForKey:@"httpCode"] integerValue];
                                         
                                         if (status == 200) {
                                             self.getCodeBtn.backgroundColor =[UIColor lightGrayColor];
                                             [self.getCodeBtn setUserInteractionEnabled:NO];
                                             [self setTheCountdownButton:self.getCodeBtn];
                                         }else{
                                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[info objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                             [alert show];
                                         }
                                     }
                                     
                                 }failure:^(id operation, NSError *error) {
                                     [weakSelf.hud hide:YES];
                                     NSLog(@"调用获取验证码接口失败-->>\n%@",error);
                                 }];
}

- (void)setFrameSize:(CGFloat)hight{
    CGFloat spideLeft = (ScreenWidth - TSACTIONVIEW_CONTAINER_WIDTH)/2;
    CGFloat spideTop = (ScreenHeight - hight) * 0.4;
    self.containerView.frame = CGRectMake(spideLeft, spideTop,TSACTIONVIEW_CONTAINER_WIDTH, hight);
}
#pragma mark - button倒计时
- (void)setTheCountdownButton:(UIButton *)button {
    //倒计时时间
    __block NSInteger timeOut = 60;
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0), 1.0 * NSEC_PER_SEC,0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut == 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = [UIColor redColor];
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled =YES;
            });
        } else {
            int seconds = timeOut % 61;
            NSString *timeStr = [NSString stringWithFormat:@"%0.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"%@%@",timeStr,@"秒"]forState:UIControlStateNormal];
                
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - Lazy

//头部视图
- (UIButton *)headerBtn{
    if (_headerBtn == nil) {
        _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerBtn.backgroundColor = [UIColor redColor];
        [_headerBtn setTitle:@"游戏登录" forState:UIControlStateNormal];
        _headerBtn.userInteractionEnabled = NO;
    }
    return _headerBtn;
}

//用户名
- (UITextField *)inputFieldUserName{
    if (_inputFieldUserName == nil){
        _inputFieldUserName = [UITextField new];
        _inputFieldUserName.textAlignment = NSTextAlignmentLeft;
        _inputFieldUserName.placeholder = @"请输入账号/手机号";
        _inputFieldUserName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputFieldUserName.layer.borderWidth = 1;
        _inputFieldUserName.layer.cornerRadius = 5;
        _inputFieldUserName.layer.masksToBounds = YES;
    }
    return _inputFieldUserName ;
}

//密码
- (UITextField *)inputFieldPwd{
    if (_inputFieldPwd == nil){
        _inputFieldPwd = [UITextField new];
        _inputFieldPwd.textAlignment = NSTextAlignmentLeft;
        _inputFieldPwd.placeholder = @"请输入密码";
        [_inputFieldPwd setSecureTextEntry:YES];
        _inputFieldPwd.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputFieldPwd.layer.borderWidth = 1;
        _inputFieldPwd.layer.cornerRadius = 5;
        _inputFieldPwd.layer.masksToBounds = YES;
    }
    return _inputFieldPwd;
}

//密码1
- (UITextField *)inputFieldPwd1{
    if (_inputFieldPwd1 == nil){
        _inputFieldPwd1 = [UITextField new];
        _inputFieldPwd1.textAlignment = NSTextAlignmentLeft;
        _inputFieldPwd1.placeholder = @"请输入密码";
        [_inputFieldPwd1 setSecureTextEntry:YES];
        _inputFieldPwd1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputFieldPwd1.layer.borderWidth = 1;
        _inputFieldPwd1.layer.cornerRadius = 5;
        _inputFieldPwd1.layer.masksToBounds = YES;
    }
    return _inputFieldPwd1;
}

//密码2
- (UITextField *)inputFieldPwd2{
    if (_inputFieldPwd2 == nil){
        _inputFieldPwd2 = [UITextField new];
        _inputFieldPwd2.textAlignment = NSTextAlignmentLeft;
        _inputFieldPwd2.placeholder = @"请确认密码";
        [_inputFieldPwd2 setSecureTextEntry:YES];
        _inputFieldPwd2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputFieldPwd2.layer.borderWidth = 1;
        _inputFieldPwd2.layer.cornerRadius = 5;
        _inputFieldPwd2.layer.masksToBounds = YES;
    }
    return _inputFieldPwd2;
}

//验证码
- (UITextField *)inputFieldCode{
    if (_inputFieldCode == nil){
        _inputFieldCode = [UITextField new];
        _inputFieldCode.textAlignment = NSTextAlignmentLeft;
        _inputFieldCode.placeholder = @"请输入验证码";
        _inputFieldCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputFieldCode.layer.borderWidth = 1;
        _inputFieldCode.layer.cornerRadius = 5;
        _inputFieldCode.layer.masksToBounds = YES;
    }
    return _inputFieldCode ;
}

//登录
- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = [UIColor redColor];
        [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

//修改密码
- (UIButton *)pwdOKBtn{
    if (_pwdOKBtn == nil) {
        _pwdOKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pwdOKBtn.backgroundColor = [UIColor redColor];
        [_pwdOKBtn setTitle:@"确定" forState:UIControlStateNormal];
        _pwdOKBtn.layer.cornerRadius = 5;
        _pwdOKBtn.layer.masksToBounds = YES;
        [_pwdOKBtn addTarget:self action:@selector(pwdOKAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwdOKBtn;
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
        _cancelBtn.backgroundColor =[UIColor darkGrayColor];
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancaleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

//取消
- (UIButton *)pwdCancelBtn{
    if (_pwdCancelBtn == nil) {
        _pwdCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pwdCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _pwdCancelBtn.backgroundColor =[UIColor darkGrayColor];
        _pwdCancelBtn.layer.cornerRadius = 5;
        _pwdCancelBtn.layer.masksToBounds = YES;
        [_pwdCancelBtn addTarget:self action:@selector(cancaleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwdCancelBtn;
}


//注册
- (UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_registerBtn.backgroundColor = [UIColor redColor];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _registerBtn.layer.cornerRadius = 5;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
//忘记密码
- (UIButton *)forgotPwdBtn{
    if (_forgotPwdBtn == nil) {
        _forgotPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_forgotPwdBtn.backgroundColor = [UIColor redColor];
        [_forgotPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgotPwdBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _forgotPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _forgotPwdBtn.layer.cornerRadius = 5;
        _forgotPwdBtn.layer.masksToBounds = YES;
        [_forgotPwdBtn addTarget:self action:@selector(forgotPwdAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPwdBtn;
}

//获取验证码按钮
- (UIButton *)getCodeBtn{
    if (_getCodeBtn == nil) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.backgroundColor =[UIColor redColor];
        _getCodeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        _getCodeBtn.layer.cornerRadius = 5;
        _getCodeBtn.layer.masksToBounds = YES;
        [_getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

@end
