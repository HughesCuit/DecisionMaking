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
}

- (void)viewWillAppear:(BOOL)animated{
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - init methods
- (void)initializeDataSource{
    if (loggedIn) {
        _dataSource = [@[
                         @[[[BmobUser getCurrentUser] objectForKey:@"nickName"]?[[BmobUser getCurrentUser] objectForKey:@"nickName"]:[[BmobUser getCurrentUser] objectForKey:@"username"]],
                         
                         @[@"退出登录"]
                         ] mutableCopy];
    }else{
        _dataSource = [@[@[@"未登录"]] mutableCopy];
    }
}

- (void)initializeUserInterface{
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (loggedIn) {
        if (indexPath.section == 2&&indexPath.row == 0) {
            setLogout;
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:^{
                [BmobUser logout];
            }];
        }
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
    }
}

#pragma mark - Getter methods
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.allowsMultipleSelection = NO;
        _tableView.dataSource = self;
        _tableView.delegate   = self;
    }
    return _tableView;
}


@end
