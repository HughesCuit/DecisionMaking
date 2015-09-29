//
//  OnlineDecisionViewController.m
//  DecisionMaking
//
//  Created by rimi on 15/9/28.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "OnlineDecisionViewController.h"
#import "MXPullDownMenu.h"


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
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(respondsToAddItem:)];
    self.navigationItem.rightBarButtonItem = addItem;
}

#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSLog(@"%ld -- %ld", column, row);
}


@end
