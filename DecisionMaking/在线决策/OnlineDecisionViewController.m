//
//  OnlineDecisionViewController.m
//  DecisionMaking
//
//  Created by rimi on 15/9/28.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "OnlineDecisionViewController.h"
#import "MXPullDownMenu.h"
#import "LHYLockView.h"
#import <MBProgressHUD.h>

@interface OnlineDecisionViewController ()<MXPullDownMenuDelegate>{
    NSArray *_testArray;
}

- (void) initializeDataSource;/**< 初始化数据源 */


- (void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation OnlineDecisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}


#pragma mark - init methods
- (void)initializeDataSource{
    
    _testArray = @[
                  @[
                      @"全部Tag",
                      @"教育学习",
                      @"科学研究",
                      @"情感生活",
                      @"物品选购",
                      @"其它Tag"
                      ],
                   @[
                      @"今天",
                      @"三天内",
                      @"一周内",
                      @"一个月内",
                      @"更久",
                      @"全部"
                      ],
                  @[@"来自我",
                    @"来自我的好友",
                    @"来自所有人"
                    ]
                  ];
    
}

- (void)initializeUserInterface{
    MXPullDownMenu *menu = [[MXPullDownMenu alloc]initWithArray:_testArray selectedColor:kBlueColor];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 0, menu.frame.size.width, menu.frame.size.height);
    [self.view addSubview:menu];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(respondsToAddItem)];
    self.navigationItem.rightBarButtonItem = addItem;
//    LHYLockView *lockView = [[LHYLockView alloc]init];
//    [self.view addSubview:lockView];
}

#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSLog(@"%ld -- %ld", column, row);
}

#pragma mark - Responds event
- (void)respondsToAddItem{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"发布求助" message:@"请发布您的求助" preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"您的求助信息";
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入一个tag";
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Yes选项";
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"No选项";
    }];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确认发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //提交后台
        BmobObject *question = [BmobObject objectWithClassName:@"question"];
        [question setObject:[[BmobUser getCurrentUser] objectForKey:@"username"] forKey:@"asker"];
        NSArray<NSString *> *keys = @[@"title",@"tag",@"yesContent",@"noContent"];
        for (int i = 0; i < 4; i++) {
            [question setObject:ac.textFields[i].text forKey:keys[i]];
        }
        [question saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"发布成功！";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:1.5];
            }
        }];
    }]];
    [self presentViewController:ac animated:YES completion:^{
        
    }];
}

@end
