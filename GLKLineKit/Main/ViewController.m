//
//  ViewController.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "ViewController.h"
#import "PortraitTestController.h"
#import "LandscapeController.h"
#import "BothController.h"

@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

/**
 列表
 */
@property (strong, nonatomic) UITableView *listView;

/**
 示例项目的数组
 */
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

/**
 cell的标识符
 */
static NSString *const klineKitDemoCell_id_1 = @"klineKitDemoCell_id_1";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initialize];
    
    [self p_setUpUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate Method --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:klineKitDemoCell_id_1 forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellTitle = self.dataArray[indexPath.row];
    
    if ([cellTitle isEqualToString:@"竖屏"]) {
        PortraitTestController *portraitVC = [[PortraitTestController alloc] init];
        
        [self.navigationController pushViewController:portraitVC animated:YES];
    }else if([cellTitle isEqualToString:@"横屏"]) {
        
        LandscapeController *landScapeVC = [[LandscapeController alloc] init];
        
        [self.navigationController pushViewController:landScapeVC animated:YES];
        
    }else if([cellTitle isEqualToString:@"横竖屏切换"]) {
        
        BothController *bothVC = [[BothController alloc] init];
        
        [self.navigationController pushViewController:bothVC animated:YES];
    }
    
}

#pragma  mark - 私有方法 ---

- (void)p_initialize {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"GLKLineKit";
    
    if (@available(iOS 11.0, *)) {
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)p_setUpUI {
    
    [self.view addSubview:self.listView];
    
}

#pragma mark - 懒加载 ---

- (UITableView *)listView {
    
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0)];
        _listView.dataSource = self;
        _listView.delegate = self;
        [_listView registerClass:[UITableViewCell class] forCellReuseIdentifier:klineKitDemoCell_id_1];
    }
    return _listView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"竖屏"];
        [_dataArray addObject:@"横屏"];
        [_dataArray addObject:@"横竖屏切换"];
    }
    return _dataArray;
}
@end
