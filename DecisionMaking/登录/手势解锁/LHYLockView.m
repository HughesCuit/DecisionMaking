//
//  LHYLockView.m
//  LHYLockViewTest
//
//  Created by LiHongyao on 15/9/27.
//  Copyright © 2015年 李鸿耀. All rights reserved.
//

#import "LHYLockView.h"

// const 定义只读的变量名，在其他的类中不能声明同样的变量名

CGFloat const btnCount = 9;         /**< 按钮个数 */
CGFloat const btnW     = 74;        /**< 按钮宽度 */
CGFloat const btnH     = 74;        /**< 按钮高度 */

static int const columnCount  = 3;  /**< 行数 */
static int enterTimes = 3;          /**< 输入次数 */

static NSString *const kLHYLockCodeName                = @"LHYLockCode";
static NSString *const kLHYLockMessageForEnterPsw      = @"请滑动手势解锁";
static NSString *const kLHYLockMessageForEnterSuccess  = @"解锁成功";
static NSString *const kLHYLockMessageForSetPsw        = @"请设置手势密码";
static NSString *const kLHYLockMessageForSetPswAgain   = @"请再次设置手势密码";
static NSString *const kLHYLockMessageForSetPswSuccess = @"手势密码设置成功";
static NSString *const kLHYLockMessageForSetPswFailure = @"与上次不符，设置失败！";


#define kTextColor    [UIColor lightGrayColor]
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@interface LHYLockView () {
    CGFloat _centerX;
    NSString *_errorMessage;
}

@property (nonatomic, assign, getter = isReSetRrror) BOOL resetError;

@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) NSString *firstEnterPsw;
@property (nonatomic, strong) NSMutableArray *selectedBtns;

/**
 *  判断是否是第一次使用手势解锁，如果是，则提示设置密码
 *
 *  @return 状态
 */
- (BOOL)isfirstUseLockView;

/**
 *  清空按钮和线条
 */
- (void)clearBtnsAndPath;

/**
 *  获取触摸的点
 *
 *  @param touches 触摸手势集合
 *
 *  @return 触摸点
 */
- (CGPoint)pointWithTouch:(NSSet *)touches;

/**
 *  获取触摸按钮
 *
 *  @param point 触摸点
 *
 *  @return 按钮
 */
- (UIButton *)buttonWithPoint:(CGPoint)point;

/**
 *  处理错误
 *
 *  @param message 错误信息
 */
- (void)errorAnimationWithMessage:(NSString *)message;


@end


@implementation LHYLockView

- (void)dealloc {
    
}

#pragma mark - Init methods

+ (instancetype)lockView {
    
    LHYLockView *lockView = [[LHYLockView alloc] init];
    
    return lockView;
}

// 通过代码创建会调用这个方法
- (instancetype)init {
    self = [super init];
    if (self) {
        
        //*******************************************************************************
        // 属性配置
        self.backgroundColor = [UIColor colorWithRed:28/255.0 green:30/255.0 blue:42/255.0 alpha:1];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        //*******************************************************************************
        // 视图加载
        [self addSubview:self.stateLabel];
        [self addButtons];
        
        //*******************************************************************************
        // 变量赋值
        _centerX = CGRectGetMidX(self.stateLabel.frame);
        
        //*******************************************************************************
        // 根据手势密码是否存在设置状态显示
        self.stateLabel.text = [self isfirstUseLockView] ? kLHYLockMessageForSetPsw : kLHYLockMessageForEnterPsw;
    }
    return self;
}


#pragma mark - 添加按钮
- (void)addButtons {
    
    for (int i = 0; i < btnCount; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        // 关闭用户交互
        btn.userInteractionEnabled = NO;
        // 设置tag值
        btn.tag = i + 1;
        
        // 设置默认的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        // 设置选中的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        
        // 第几行
        int row = i / columnCount;
        // 第几列
        int column = i % columnCount;
        
        // 边距
        CGFloat margin = (kScreenWidth - columnCount *btnW) / (columnCount + 1);
        // x轴
        CGFloat btnX = margin + column  * (btnW + margin);
        // y轴
        CGFloat btnY = CGRectGetMaxY(self.stateLabel.frame) + 100 + row * (btnW + margin);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [self addSubview:btn];
    }
    
}

#pragma mark - Responds userdefaults
- (void)resetGesturePassword {
    // 清空密码
    [USER_DEFAULTS removeObjectForKey:kLHYLockCodeName];
    
    self.stateLabel.text = kLHYLockMessageForSetPsw;
}

#pragma mark - Private methods

- (CGPoint)pointWithTouch:(NSSet *)touches {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    return point;
}

- (UIButton *)buttonWithPoint:(CGPoint)point {
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

- (BOOL)isfirstUseLockView {
    
    if ([USER_DEFAULTS objectForKey:kLHYLockCodeName]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)clearBtnsAndPath {
    // 延迟调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 清空按钮选中状态
        for (UIButton *btn in self.selectedBtns) {
            btn.selected = NO;
        }
        // 清空按钮集合
        [self.selectedBtns removeAllObjects];
        // 重绘
        [self setNeedsDisplay];
    });
}

- (void)errorAnimationWithMessage:(NSString *)message {
    // 更新状态信息
    self.stateLabel.text      = message;
    self.stateLabel.textColor = [UIColor redColor];
    // 位移动画
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAnimation.duration     = 0.05f;
    positionAnimation.repeatCount  = 2.0f;
    positionAnimation.autoreverses = YES;
    positionAnimation.fromValue    = @(_centerX - 10);
    positionAnimation.toValue      = @(_centerX + 10);
    positionAnimation.delegate     = self;
    // 添加动画
    [self.stateLabel.layer addAnimation:positionAnimation forKey:nil];
}

#pragma mark - Rsponds gesture
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 1、拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    // 2、根据触摸的点拿到响应的按钮
    UIButton *btn = [self buttonWithPoint:point];
    // 3、设置状态
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        
        // 往数组或字典中添加对象的时候，要判断这个对象是否存在。
        [self.selectedBtns addObject:btn];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 1、拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    // 2、根据触摸的点拿到响应的按钮
    UIButton *btn = [self buttonWithPoint:point];
    // 3、设置状态
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        
        // 往数组或字典中添加对象的时候，要判断这个对象是否存在。
        [self.selectedBtns addObject:btn];
    }else {
        self.currentPoint = point;
    }
    // 绘制路线
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.selectedBtns.count == 0) {
        return;
    }
    
    // 获取手势密码
    NSMutableString *password = [NSMutableString string];
    for (UIButton *btn in self.selectedBtns) {
        // 获取按钮tag值
        [password appendFormat:@"%ld", btn.tag];
    }
    
    // 判断手势密码是否存在：如果存在，则判断是否解锁成功，如果不存在，则新建手势密码；
    if ([USER_DEFAULTS objectForKey:kLHYLockCodeName]) {
        // 存在，判断是否解锁成功
        if ([password isEqualToString:[USER_DEFAULTS objectForKey:kLHYLockCodeName]]) {
            // 更新状态信息
            self.stateLabel.textColor = kTextColor;
            self.stateLabel.text = kLHYLockMessageForEnterSuccess;
            // 判断代理是否存在并且是否实现了 lockViewUnlockSuccess 方法，如果返回YES，则执行代理方法，否则直接操作，移除解锁视图。
            if (self.delegate && [self.delegate respondsToSelector:@selector(lockViewUnlockSuccess)]) {
                [self clearBtnsAndPath];
                [self.delegate lockViewUnlockSuccess];
            }else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [self removeFromSuperview];
                });
            }
        }else {
            // 解锁失败
            
            // 判断是否次数为0；
            if (enterTimes == 0) {
                // 判断代理是否存在并且是否实现了 lockViewUnlockFailure 方法，如果返回YES，则执行代理方法，否则直接操作，退出应用程序。
                if (self.delegate && [self.delegate respondsToSelector:@selector(lockViewUnlockFailure)]) {
                    [self clearBtnsAndPath];
                    [self.delegate lockViewUnlockFailure];
                }else {
                    exit(0);
                }
            }else {
                // 赋值错误信息
                _errorMessage = [NSString stringWithFormat:@"解锁失败，您还有%d次机会！", --enterTimes];
                // 执行错误信息动画
                [self errorAnimationWithMessage:_errorMessage];
                // 清空
                [self clearBtnsAndPath];
            }
        }
    }else {
        // 设置密码
        
        // 判断 kLHYLockFirstPsw 是否存在
        if (self.firstEnterPsw) {
            // kLHYLockFirstPsw存在，判断两次输入是否匹配
            if ([password isEqualToString:self.firstEnterPsw]) {
                // 两次输入匹配，设置手势密码
                [USER_DEFAULTS setObject:password forKey:kLHYLockCodeName];
                // 更新状态信息
                self.stateLabel.text = kLHYLockMessageForSetPswSuccess;
                // 清空
                [self clearBtnsAndPath];
                // 延迟调用
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 更新状态信息
                    self.stateLabel.textColor = kTextColor;
                    self.stateLabel.text = kLHYLockMessageForEnterPsw;
                });
            }else {
                // 两次输入不匹配
                // 赋值firstEnterPsw、resetError
                self.firstEnterPsw = nil;
                self.resetError = YES;
                // 赋值错误信息
                _errorMessage = kLHYLockMessageForSetPswFailure;
                // 执行错误信息动画
                [self errorAnimationWithMessage:_errorMessage];
                // 清空
                [self clearBtnsAndPath];
                
            }
        }else {
            // kLHYLockFirstPsw不存在
            // 赋值firstEnterPsw
            self.firstEnterPsw = password;
            // 更新状态信息
            self.stateLabel.text = kLHYLockMessageForSetPswAgain;
            // 清空
            [self clearBtnsAndPath];
        }
        
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


#pragma mark - Draw
- (void)drawRect:(CGRect)rect {
    
    // 异常处理
    if (self.selectedBtns.count == 0) {
        return;
    }
    
    // 绘制路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 7;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    
    // 遍历按钮
    for (int i = 0; i < self.selectedBtns.count; i++) {
        UIButton *button = self.selectedBtns[i];
        if (i == 0) {
            // 设置起点
            [path moveToPoint:button.center];
        }else{
            // 连线
            [path addLineToPoint:button.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 移除动画
    [self.stateLabel.layer removeAllAnimations];
    // 复原中心点
    self.stateLabel.center = CGPointMake(_centerX, CGRectGetMidY(self.stateLabel.frame));
    // 判断是否是第二次设置密码错误，如果是，则更新状态信息，并将resetError重新置为NO
    if (self.isReSetRrror) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.stateLabel.textColor = kTextColor;
            self.stateLabel.text = kLHYLockMessageForSetPsw;
            self.resetError = NO;
        });
    }
}

#pragma mark - Getter methods
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.bounds = CGRectMake(0, 0, kScreenWidth, 50);
        _stateLabel.center = CGPointMake(CGRectGetMidX(self.bounds), 100 + CGRectGetMidY(_stateLabel.bounds));
        _stateLabel.textColor = kTextColor;
        _stateLabel.font = [UIFont boldSystemFontOfSize:25];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (NSMutableArray *)selectedBtns {
    if (!_selectedBtns) {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}

@end















