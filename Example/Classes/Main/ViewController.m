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
    
    if ([cellTitle isEqualToString:KLocalizedString(@"kline_demo_portrait", @"竖屏")]) {
        PortraitTestController *portraitVC = [[PortraitTestController alloc] init];
        
        [self.navigationController pushViewController:portraitVC animated:YES];
    }else if([cellTitle isEqualToString:KLocalizedString(@"kline_demo_landscape", @"横屏")]) {
        
        LandscapeController *landScapeVC = [[LandscapeController alloc] init];
        
        [self.navigationController pushViewController:landScapeVC animated:YES];
    }
}

#pragma  mark - 私有方法 ---

- (void)p_initialize {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"GLKLineKit";
}

- (void)p_setUpUI {
    
    [self.view addSubview:self.listView];
    
    [self p_layoutWithMasonry];
}

- (void)p_layoutWithMasonry {
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(Nav_topH);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - 懒加载 ---

- (UITableView *)listView {
    
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero];
        if (@available(iOS 11.0, *)) {
            _listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.estimatedRowHeight = 0;
        _listView.estimatedSectionFooterHeight = 0;
        _listView.estimatedSectionHeaderHeight = 0;
        [_listView registerClass:[UITableViewCell class] forCellReuseIdentifier:klineKitDemoCell_id_1];
    }
    return _listView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:KLocalizedString(@"kline_demo_portrait", @"竖屏")];
//        [_dataArray addObject:KLocalizedString(@"kline_demo_landscape", @"横屏")];
    }
    return _dataArray;
}
@end
