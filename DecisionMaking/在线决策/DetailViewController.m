//
//  DetailViewController.m
//  DecisionMaking
//
//  Created by rimi on 15/10/9.
//  Copyright © 2015年 HugheX. All rights reserved.
//

#import "DetailViewController.h"
#import <GraphKit.h>

@interface DetailViewController ()<BmobEventDelegate,GKBarGraphDataSource>
@property (nonatomic, strong)  GKBarGraph *graphView;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic,strong) BmobObject *obj;/**< 求助对象 */
- (void) initializeDataSource;/**< 初始化数据源 */


- (void)initializeUserInterface;/**< 初始化用户界面 */
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeDataSource];
}

#pragma mark 
#pragma mark - init methods
- (void)initializeDataSource{
    if (self.questionId) {
        BmobQuery *qQuery = [BmobQuery queryWithClassName:@"question"];
        [qQuery getObjectInBackgroundWithId:self.questionId block:^(BmobObject *object, NSError *error) {
            self.data = @[[object objectForKey:@"yesCount"]?[object objectForKey:@"yesCount"]:@0,[object objectForKey:@"noCount"]?[object objectForKey:@"noCount"]:@0];
            self.labels = @[@"YES",@"NO"];
            self.obj = object;
            if (!self.graphView) {
                BmobEvent *bmobEvent = [BmobEvent defaultBmobEvent];
                bmobEvent.delegate = self;
                [bmobEvent start];
                [self initializeUserInterface];
            }else {
                [self.graphView draw];
            }
            
        }];
        
    }
}
- (void)initializeUserInterface{
    self.graphView = [[GKBarGraph alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 400)];
    self.graphView.barHeight = 350;
    self.graphView.barWidth = 80;
    self.graphView.dataSource = self;
    [self.view addSubview:self.graphView];
    [self.graphView draw];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    yesButton.frame = CGRectMake(0, 0, 100, 100);
    yesButton.titleLabel.numberOfLines = 0;
    yesButton.center = CGPointMake(self.view.center.x-70, CGRectGetMaxY(self.graphView.frame)+80);
    yesButton.backgroundColor = [UIColor colorWithRed:0.173 green:0.631 blue:0.855 alpha:1.000];
    [yesButton setTitle:[self.obj objectForKey:@"yesContent"] forState:UIControlStateNormal];
    yesButton.layer.cornerRadius = 15;
    yesButton.layer.masksToBounds= YES;
    yesButton.tag = 101;
    [yesButton addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    noButton.frame = CGRectMake(0, 0, 100, 100);
    noButton.titleLabel.numberOfLines = 0;
    noButton.center = CGPointMake(self.view.center.x+70, CGRectGetMaxY(self.graphView.frame)+80);
    noButton.backgroundColor = [UIColor colorWithRed:0.984 green:0.039 blue:0.553 alpha:1.000];
    [noButton setTitle:[self.obj objectForKey:@"noContent"] forState:UIControlStateNormal];
    noButton.layer.cornerRadius = 15;
    noButton.layer.masksToBounds= YES;
    noButton.tag = 102;
    [noButton addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:yesButton];
    [self.view addSubview:noButton];
    
}
- (CGSize)sizeWithString:(NSString *)string constriantWidth:(CGFloat) constraintWidth font:(UIFont *) font{
    return [string boundingRectWithSize:CGSizeMake(constraintWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark 
#pragma mark - Responds events
- (void)respondsToButton:(UIButton*)sender{
    NSString *key = sender.tag == 101?@"yesCount":@"noCount";
    NSNumber *currentCount = sender.tag == 101?self.data[0]:self.data[1];
    BmobObject *updateObj = [BmobObject objectWithoutDatatWithClassName:@"question" objectId:self.questionId];
    [updateObj setObject:@([currentCount integerValue]+1) forKey:key];
    [updateObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self initializeDataSource];
            NSLog(@"success");
        }
    }];
}

#pragma mark
#pragma mark - BmobEventDelegate
- (void)bmobEventCanStartListen:(BmobEvent *)event{
    [event listenRowChange:BmobActionTypeUpdateRow tableName:@"question" objectId:self.questionId];
}

//接收到得数据
-(void)bmobEvent:(BmobEvent *)event didReceiveMessage:(NSString *)message{
    [self initializeDataSource];
}

#pragma mark 
#pragma mark - GKBarGraphDataSource
- (NSInteger)numberOfBars {
    return [self.data count];
}

- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
    return @(([[self.data objectAtIndex:index] doubleValue] / ([self.data[0] doubleValue]+[self.data[1] doubleValue]))*100);
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    id colors = @[kBlueColor,
                  [UIColor magentaColor]
                  ];
    return [colors objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
    CGFloat percentage = [[self valueForBarAtIndex:index] doubleValue];
    percentage = (percentage / 100);
    return (self.graphView.animationDuration * percentage);
}

- (NSString *)titleForBarAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%@:%@",[self.labels objectAtIndex:index],[self.data objectAtIndex:index]];
}
@end
