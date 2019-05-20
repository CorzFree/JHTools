//
//  SPClientConstEnum.h
//  SwiftFintechSDK
//
//  Created by wongfish on 15/6/11.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    
    //二维码生成失败
    SPClientConstEnumFintechQRMakeErro = 1000,
    
    //生成二维码生成，等待扫描中
    SPClientConstEnumFintechQRWaitScan = 1001,
    
    //传入的支付类型无效
    SPClientConstEnumFintechPositiveScansTypeInvalid = 1002,
    
    //二维码等待扫码超时
    SPClientConstEnumFintechQRWaitScanTimerOut = 1003,
    
    //二维码在等待扫描的时候，用户退出了支付
    SPClientConstEnumFintechUserOut = 1004,
    
    //用户在选择支付类型的时候，选择了取消选择支付
    SPClientConstEnumCancelSelect = 1005,
    
    //传入的参数错误
    SPClientConstEnumParameterError = 1100,

    //TokenID失效
     SPClientConstEnumFintechTokenIDInvalid = 400,
    
    //TokenID未知
    SPClientConstEnumFintechTokenIDUnknown = 401,
    
    //二维码未支付
    SPClientConstEnumFintechQRUnUse = 204,
    
    //二维码被扫码，但是支付失败
    SPClientConstEnumFintechQRFintechErro = 202,
    
    //app支付，支付失败
    SPClientConstEnumAppFintechErro = 601,
    
    //wap支付，支付失败
    SPClientConstEnumWapFintechErro = 701,
    
    //wap支付，用户取消了支付
    SPClientConstEnumWapFintechOut = 702,
    
    //wap支付，用户未支付
    SPClientConstEnumWapFintechUnfintech = 703,
    
    //支付成功
    SPClientConstEnumFintechSuccess = 201,
    
    //反扫冲正成功
    SPClientConstEnumReverseScanFintechReverseSuccess = 2001,
    
    //反扫冲正失败
    SPClientConstEnumReverseScanFintechReverseErro = 2002,
    
    //反扫支付失败
    SPClientConstEnumReverseScanFintechErro = 2003,
    
    //用户在扫码界面直接退出的交易，交易失败
    SPClientConstEnumReverseScanCancelSelect = 2004,
    
    //设备设备没有摄像头
    SPClientConstEnumNotCamera = 3001,
    
    //设备摄像头权限访问受限
    SPClientConstEnumCameraNotOpen= 3002,
    
    //手Q没有安装
    SPClientConstEnumType3NotOpen= 3003,
    
    //微信没有安装（微信Wap支付时候用到）
    SPClientConstEnumType1NotOpen= 3004,
    
    //支付宝没有安装（支付宝Wap支付时候用到）
    SPClientConstEnumType2NotOpen = 3005
    
} SPClientConstEnumFintechState;
//SP支付状态值


typedef enum {
    
    //普通商户模式（默认）
    SPClientConstEnumMacChannelNormal = 0,
    
    //代理商户模式
    SPClientConstEnumMacChannelAgent = 1,
    
    
} SPClientConstEnumMacChannel;
//商户渠道模式




