//
//  FloatButton.h
//  傲风游戏 悬浮按钮
//
//  Created by zoujiasheng on 2019/5/3.
//  Copyright © 2019 aofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FloatButton : UIButton

+ (instancetype)sharedButton;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
