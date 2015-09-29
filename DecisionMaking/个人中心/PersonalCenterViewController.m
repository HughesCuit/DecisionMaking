//
//  PersonalCenterViewController.m
//  DecisionMaking
//
//  Created by rimi on 15/9/28.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "PersonalCenterViewController.h"


static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";
@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray<NSArray *> *_dataSource;
}

@property (nonatomic,strong) UITableView *tableView;/**< 表格视图 */

- (void) initializeDataSource;/**< 初始化数据源 */


- (void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - init methods
- (void)initializeDataSource{
    _dataSource = [@[
                     @[@"黄河"],
                     @[
                         @"我的好友",
                         @"邀请好友"
                       ],
                     @[@"退出登录"]
                     ] mutableCopy];
}

- (void)initializeUserInterface{
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - Getter methods
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
    }
    return _tableView;
}


@end
