//
//  CMSCoinView.m
//  FlipViewTest
//
//  Created by Rebekah Claypool on 10/1/13.
//  Copyright (c) 2013 Coffee Bean Studios. All rights reserved.
//

#import "CMSCoinView.h"


@interface CMSCoinView (){
    bool displayingPrimary;
}
@end

@implementation CMSCoinView

@synthesize primaryView=_primaryView, secondaryView=_secondaryView, spinTime;

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        displayingPrimary = YES;
        spinTime = 1.0;
    }
    return self;
}

- (id) initWithPrimaryView: (UIView *) primaryView andSecondaryView: (UIView *) secondaryView inFrame: (CGRect) frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.primaryView = primaryView;
        self.secondaryView = secondaryView;
        
        displayingPrimary = YES;
        spinTime = 1.0;
    }
    return self;
}

- (void) setPrimaryView:(UIView *)primaryView{
    _primaryView = primaryView;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.primaryView setFrame: frame];
    [self roundView: self.primaryView];
    self.primaryView.userInteractionEnabled = YES;
    [self addSubview: self.primaryView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipTouched:)];
    gesture.numberOfTapsRequired = 1;
    [self.primaryView addGestureRecognizer:gesture];
    [self roundView:self];
}

- (void) setSecondaryView:(UIView *)secondaryView{
    _secondaryView = secondaryView;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.secondaryView setFrame: frame];
    [self roundView: self.secondaryView];
    self.secondaryView.userInteractionEnabled = YES;
    [self addSubview: self.secondaryView];
    [self sendSubviewToBack:self.secondaryView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipTouched:)];
    gesture.numberOfTapsRequired = 1;
    [self.secondaryView addGestureRecognizer:gesture];
    [self roundView:self];
}

- (void) roundView: (UIView *) view{
    [view.layer setCornerRadius: (self.frame.size.height/2)];
    [view.layer setMasksToBounds:YES];
}

-(IBAction) flipTouched:(id)sender{
    static NSInteger counter = 0;
    // 1.开始配置动画
    [UIView beginAnimations:@"end" context:nil];
    // 2.配置动画
    
    // 2.1配置动画持续时间
    [UIView setAnimationDuration:spinTime];
    // 2.2配置线性规律
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    // 2.3配置回调方法
    [UIView setAnimationDelegate:self];
    
    
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    // 2.4动画类型：描述要执行的动画，该设置必须在配置其他动画要素之后。
    // 将动画视图回归原始状态
//    _animationView.center = CGPointMake(60, 85);
//    _animationView.backgroundColor = [UIColor blackColor];
//    _animationView.transform = CGAffineTransformIdentity;
    // 设置转场动画
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_animationView cache:NO];
    
    [UIView transitionFromView:(displayingPrimary ? self.primaryView : self.secondaryView)
                        toView:(displayingPrimary ? self.secondaryView : self.primaryView)
                      duration: spinTime
                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut+UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished) {
                        if (finished) {
                            //UIView *view = (displayingPrimary ? view1 : view2);
                            
                            displayingPrimary = !displayingPrimary;
                            if (++counter < 10) {
                                [self flipTouched:nil];
                            }else{
                                BOOL ifOnceMore = arc4random()%2;
                                if (ifOnceMore) {
                                    [UIView transitionFromView:(displayingPrimary ? self.primaryView : self.secondaryView)
                                                        toView:(displayingPrimary ? self.secondaryView : self.primaryView)
                                                      duration: spinTime
                                                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut+UIViewAnimationOptionTransitionCrossDissolve
                                                    completion:^(BOOL finished) {
                                                        if (finished) {
                                                            //UIView *view = (displayingPrimary ? view1 : view2);
                                                            
                                                            displayingPrimary = !displayingPrimary;
                                                        }
                                                    }];
                                }
                                counter = 0;
                            }
                            
                        }
                    }
     ];
    
    // 3.提交动画
    [UIView commitAnimations];
    
}

@end
