//
//  LHYLockView.h
//  LHYLockViewTest
//
//  Created by LiHongyao on 15/9/27.
//  Copyright © 2015年 李鸿耀. All rights reserved.
//

#import <UIKit/UIKit.h>

// 友情提示：
// 1、请使用遍历构造初始化方法或者直接使用 “alloc + init” 初始化方法初始化实例对象；
// 2、如果没有设置代理，实现<LHYLockViewDelegate>协议，手势解锁成功或失败会直接采取默认处理逻辑，如果设置代理并实现<LHYLockViewDelegate>协议，则根据协议方法逻辑执行；

@class LHYLockView;
@protocol LHYLockViewDelegate <NSObject>

@optional
/**
 *  解锁成功
 */
- (void)lockViewUnlockSuccess;

/**
 *  解锁失败
 */
- (void)lockViewUnlockFailure;

@end



@interface LHYLockView : UIView

@property (nullable, nonatomic, assign) id <LHYLockViewDelegate> delegate; /**< 代理 */

/**
 *  便利构造器
 *
 *  @return 实例化对象
 */
+ (nullable instancetype)lockView;

/**
 *  重置手势密码
 */
- (void)resetGesturePassword;





@end
