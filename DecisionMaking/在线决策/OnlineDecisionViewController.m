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
#import "DetailViewController.h"
#import "LoginViewController.h"

static NSString *const kUITableViewCellIdentifier = @"cellIdentifier";
@interface OnlineDecisionViewController ()<MXPullDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_selectedTitles;
    NSArray *_headerListArray;
    MXPullDownMenu *_menu;
    NSMutableArray *_dataSource;
    UITableView *_tableView;
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
    __block NSMutableArray<NSString*> *tagArray =  [defaults objectForKey:@"tags"]? [defaults objectForKey:@"tags"]:[@[@"全部Tag"] mutableCopy];
    
    BmobQuery *tQuery = [BmobQuery queryWithClassName:@"tag"];
    tQuery.limit = 15;
    [tQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            tagArray = [@[@"全部Tag"] mutableCopy];
            for (BmobObject *obj in array) {
                [tagArray addObject:[obj objectForKey:@"tagName"]];
            }
            [defaults setObject:tagArray forKey:@"tags"];
//            NSLog(@"%@",tagArray);
            _headerListArray = @[
                                 tagArray,
                                 @[
                                     @"今天",
                                     @"三天内",
                                     @"一周内",
                                     @"一个月内",
                                     @"全部"
                                     ],
                                 @[@"来自所有人",
                                   @"来自我",
                                   @"来自我的好友"
                                   ]
                                 ];
            [self refreshPullDownList];
        }else{
            NSLog(@"%@",error.localizedDescription);
        }
        
    }];
    
    _headerListArray = @[
                         tagArray,
                         @[
                             @"今天",
                             @"三天内",
                             @"一周内",
                             @"一个月内",
                             @"全部"
                             ],
                         @[
                             @"来自所有人",
                             @"来自我",
                             @"来自我的好友"
                           ]
                         ];
    _selectedTitles = [@[_headerListArray[0][0],_headerListArray[1][0],_headerListArray[2][0]] mutableCopy];
    
//    BmobQuery *qQuery = [BmobQuery queryWithClassName:@"question"];
//    [qQuery orderByDescending:@"createdAt"];
//    qQuery.limit = 20;
//    [qQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        _dataSource = [array mutableCopy];
//        if (_tableView) {
//            [_tableView reloadData];
//        }
//    }];
    [self queryQuestions];
    
}


- (void)refreshPullDownList{
    [_menu removeFromSuperview];
    _menu = [[MXPullDownMenu alloc]initWithArray:_headerListArray selectedColor:kBlueColor];
    _menu.delegate = self;
    _menu.frame = CGRectMake(0, 0, _menu.frame.size.width, _menu.frame.size.height);
    [self.view addSubview:_menu];

}

- (void)initializeUserInterface{
    _menu = [[MXPullDownMenu alloc]initWithArray:_headerListArray selectedColor:kBlueColor];
    _menu.delegate = self;
    _menu.frame = CGRectMake(0, 0, _menu.frame.size.width, _menu.frame.size.height);
    [self.view addSubview:_menu];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(respondsToAddItem)];
    self.navigationItem.rightBarButtonItem = addItem;
//    LHYLockView *lockView = [[LHYLockView alloc]init];
//    [self.view addSubview:lockView];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _menu.frame.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height-_menu.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setTableFooterView:[UIView new]];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUITableViewCellIdentifier];
    }
    BmobObject *obj = _dataSource[indexPath.row];
    cell.textLabel.text = [obj objectForKey:@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobObject *obj = _dataSource[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.questionId = obj.objectId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - MXPullDownMenuDelegate

- (void)queryQuestions
{
    BmobQuery *qQuery = [BmobQuery queryWithClassName:@"question"];
    if (![_selectedTitles[0] isEqualToString:@"全部Tag"]) {
        [qQuery whereKey:@"tag" equalTo:_selectedTitles[0]];
    }
    NSDate *date = nil;
    
    switch ([_headerListArray[1] indexOfObject:_selectedTitles[1]]) {
        case 0:
            date = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)+[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]];
            break;
        case 1:
            date = [NSDate dateWithTimeIntervalSinceNow:-(3*24*60*60)+[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]];
            break;
        case 2:
            date = [NSDate dateWithTimeIntervalSinceNow:-(7*24*60*60)+[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]];
            break;
        case 3:
            date = [NSDate dateWithTimeIntervalSinceNow:-(30*24*60*60)+[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]];
            break;
        case 4:
            date = [NSDate dateWithTimeIntervalSince1970:0+[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]];
            break;
        default:
            date = [NSDate dateWithTimeIntervalSince1970:0+[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]];
            break;
    }
    [qQuery whereKey:@"createdAt" greaterThanOrEqualTo:date];
    switch ([_headerListArray[2] indexOfObject:_selectedTitles[2]]){
        case 0:
            break;
        case 1:
            [qQuery whereKey:@"asker" equalTo:[BmobUser getCurrentUser].objectId];
            break;
        default:
            break;
    }
    [qQuery orderByDescending:@"createdAt"];
    qQuery.limit = 20;
    [qQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        _dataSource = [array mutableCopy];
        if (_tableView) {
            [_tableView reloadData];
        }
    }];
}

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    _selectedTitles[column] = _headerListArray[column][row];
    [self queryQuestions];
}

#pragma mark - Responds event
- (void)respondsToAddItem{
    if (![BmobUser getCurrentUser]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录后才能发布求助！" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [ac addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    }else{
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
            BmobQuery *tagQuery = [BmobQuery queryWithClassName:@"tag"];
            [tagQuery whereKey:@"tagName" equalTo:ac.textFields[1].text];
            [tagQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                if (number <= 0) {
                    BmobObject *tag = [BmobObject objectWithClassName:@"tag"];
                    [tag setObject:ac.textFields[1].text forKey:@"tagName"];
                    [tag saveInBackground];
                }
            }];
            
            //提交后台
            BmobObject *question = [BmobObject objectWithClassName:@"question"];
            [question setObject:[BmobUser getCurrentUser].objectId forKey:@"asker"];
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
                    [self initializeDataSource];
                }
            }];
        }]];
        [self presentViewController:ac animated:YES completion:^{
            
        }];

    }
}

@end
