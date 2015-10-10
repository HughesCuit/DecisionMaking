//
//  LocalDecisionViewController.m
//  DecisionMaking
//
//  Created by rimi on 15/9/28.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "LocalDecisionViewController.h"
#import "DOPNavbarMenu.h"
#import "CMSCoinView.h"



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
    self.numberOfItemsInRow = 2;
    self.view.backgroundColor = kTintColor;
    self.navigationController.navigationBar.tintColor = kTintColor;
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-exitup-32x32"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToShareItem)];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-list-32x32"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToMenuItem)];
    self.navigationItem.leftBarButtonItem = menuItem;
    [self loadImageViews];
}


#pragma mark - Responds methods
-(void)respondsToShareItem{
    UIAlertController *shareController = [UIAlertController alertControllerWithTitle:@"分享" message:@"分享到" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *weChatAction        = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *weiboAction         = [UIAlertAction actionWithTitle:@"微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *qqAction            = [UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction        = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [shareController addAction:weChatAction];
    [shareController addAction:weiboAction];
    [shareController addAction:qqAction];
    [shareController addAction:cancelAction];
    [self presentViewController:shareController animated:YES completion:nil];
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
    switch (index) {
        case 0:
            [self loadCoins];
            break;
        case 1:
            [self loadDice];
            break;
        default:
            break;
    }
}

- (void)loadCoins {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *pView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    pView.image = [UIImage imageNamed:@"1dollar_01"];
    UIImageView *sView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    sView.image = [UIImage imageNamed:@"1dollar_02"];
    CMSCoinView *coinView = [[CMSCoinView alloc] initWithPrimaryView:pView andSecondaryView:sView inFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-80, CGRectGetWidth(self.view.bounds)-80)];
    [coinView setSpinTime:0.1];
    coinView.center = self.view.center;
    [self.view addSubview:coinView];
}


- (void)loadDice{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,150 , 150)];
    NSArray *images = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"]];
    imgV.animationImages = images;
    imgV.userInteractionEnabled = YES;
    imgV.tag = 100;
    imgV.image = imgV.animationImages[arc4random()%6];
    imgV.contentMode = UIViewContentModeScaleToFill;
    imgV.center = self.view.center;
    [self.view addSubview:imgV];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIImageView *imgv = ((UIImageView*)[self.view viewWithTag:100]);
    imgv.animationDuration = 0.5;
    [imgv startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgv stopAnimating];
        imgv.image = imgv.animationImages[arc4random()%6];
    });
}

- (void)loadImageViews{
    [self loadCoins];
}


#pragma mark - Getter methods
- (DOPNavbarMenu *)menu {
    if (_menu == nil) {
        DOPNavbarMenuItem *coinItem = [DOPNavbarMenuItem ItemWithTitle:@"抛硬币" icon:[UIImage imageNamed:@"iconfont-coinyen"]];
        DOPNavbarMenuItem *diceItem = [DOPNavbarMenuItem ItemWithTitle:@"掷骰子" icon:[UIImage imageNamed:@"iconfont-dice"]];
        DOPNavbarMenuItem *drawingItem = [DOPNavbarMenuItem ItemWithTitle:@"抓阄" icon:[UIImage imageNamed:@"iconfont-drawer"]];
        _menu = [[DOPNavbarMenu alloc] initWithItems:@[coinItem,diceItem/*,drawingItem*/] width:self.view.dop_width maximumNumberInRow:_numberOfItemsInRow];
        _menu.backgroundColor = kBlueColorless;
        _menu.separatarColor = kTintColor;
        _menu.delegate = self;
    }
    return _menu;
}
@end
