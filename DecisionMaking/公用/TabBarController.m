//
//  TabBarController.m
//  DecisionMaking
//
//  Created by rimi on 15/9/28.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "TabBarController.h"
#import "LocalDecisionViewController.h"
#import "OnlineDecisionViewController.h"
#import "PersonalCenterViewController.h"

@interface TabBarController ()

- (void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

- (void)initializeUserInterface{
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *tabImages =@[[UIImage imageNamed:@"iconfont-dice-32x32"],[UIImage imageNamed:@"iconfont-users-32x32"],[UIImage imageNamed:@"iconfont-user-32x32"]];
    NSMutableArray *navs = [NSMutableArray array];
    NSArray<UIViewController *> *vcs = @[[[LocalDecisionViewController alloc]init],[[OnlineDecisionViewController alloc] init],[[PersonalCenterViewController alloc]init]];
    NSArray<NSString *> *titles = @[@"上帝保佑",@"求助朋友",@"我"];
    for (int i = 0; i < 3 ; i++) {
        vcs[i].title = titles[i];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcs[i]];
        nav.tabBarItem.image = tabImages[i];
        nav.navigationBar.barTintColor = kBlueColor;
        nav.navigationBar.tintColor = kTintColor;
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        nav.navigationBar.translucent = NO;
        [navs addObject:nav];
    }
    self.viewControllers = navs;
    self.tabBar.tintColor = kBlueColor;
    self.tabBar.barTintColor = [UIColor colorWithWhite:0.965 alpha:1.000];
    self.tabBar.translucent = NO;
}

@end
