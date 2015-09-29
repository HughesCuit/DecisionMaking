//
//  LocalDecisionViewController.m
//  DecisionMaking
//
//  Created by rimi on 15/9/28.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "LocalDecisionViewController.h"
#import "DOPNavbarMenu.h"


@interface LocalDecisionViewController ()<UITextViewDelegate,DOPNavbarMenuDelegate>

@property (nonatomic,assign) NSInteger numberOfItemsInRow;
@property (nonatomic,strong) DOPNavbarMenu *menu;

- (void) initializeDataSource;/**< 初始化数据源 */


- (void)initializeUserInterface;/**< 初始化用户界面 */
@end

@implementation LocalDecisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

- (void)initializeUserInterface{
    self.numberOfItemsInRow = 3;
    self.view.backgroundColor = kTintColor;
    self.navigationController.navigationBar.tintColor = kTintColor;
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-exitup-32x32"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-list-32x32"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToMenuItem)];
    self.navigationItem.leftBarButtonItem = menuItem;
}

- (void)respondsToMenuItem{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if (self.menu.isOpen) {
        [self.menu dismissWithAnimation:YES];
    } else {
        [self.menu showInNavigationController:self.navigationController];
    }
}

#pragma mark - DOPNavbarMenuDelegate methods
- (void)didShowMenu:(DOPNavbarMenu *)menu {
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)didDismissMenu:(DOPNavbarMenu *)menu {
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
    
}



#pragma mark - Getter methods
- (DOPNavbarMenu *)menu {
    if (_menu == nil) {
        DOPNavbarMenuItem *coinItem = [DOPNavbarMenuItem ItemWithTitle:@"抛硬币" icon:[UIImage imageNamed:@"iconfont-coinyen"]];
        DOPNavbarMenuItem *diceItem = [DOPNavbarMenuItem ItemWithTitle:@"掷骰子" icon:[UIImage imageNamed:@"iconfont-dice"]];
        _menu = [[DOPNavbarMenu alloc] initWithItems:@[coinItem,diceItem] width:self.view.dop_width maximumNumberInRow:_numberOfItemsInRow];
        _menu.backgroundColor = kBlueColorless;
        _menu.separatarColor = kTintColor;
        _menu.delegate = self;
    }
    return _menu;
}
@end
