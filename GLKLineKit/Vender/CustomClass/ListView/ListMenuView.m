//
//  ListMenuView.m
//  GLKLineKit
//
//  Created by walker on 2018/5/31.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "ListMenuView.h"

@interface ListMenuView ()<UITableViewDelegate,UITableViewDataSource>

/**
 列表
 */
@property (strong, nonatomic) UITableView *listView;

/**
 数据
 */
@property (strong, nonatomic) NSArray *dataSource;

/**
 视图的唯一标识符
 */
@property (readwrite, copy, nonatomic) NSString *identifier;

/**
 cell 高度
 */
@property (assign, nonatomic) CGFloat heightForRow;

/**
 选中的下标集合
 */
@property (strong, nonatomic) NSMutableSet *selectedIndexPaths;

/**
 分区间隔
 */
@property (assign, nonatomic) CGFloat sectionGap;
@end

static NSString *const listViewCell_id_1 = @"listViewCell_id_1";
@implementation ListMenuView

- (instancetype)initWithFrame:(CGRect)frame identifier:(NSString *)identifier {
    
    if (self = [super initWithFrame:frame]) {
        
        if (identifier) {
            self.identifier = identifier;
        }
        
        [self p_initialize];
        
        [self p_setUpUI];
    }
    
    return self;
}

#pragma mark - 布局方法  -------

- (void)p_setUpUI {
    
    [self addSubview:self.listView];
    
    [self p_layoutWithMasonry];
}


- (void)p_layoutWithMasonry {
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5.0f);
        make.right.equalTo(self.mas_right).offset(- 5.0f);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataSource.count <= 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(itemTitlesAtListMenuView:)]) {
            NSArray *tempData = [_delegate itemTitlesAtListMenuView:self];
            if (tempData && tempData.count > 0) {
                self.dataSource = [tempData copy];
            }
        }
    }
    
    if ([[self.dataSource firstObject] isKindOfClass:[NSArray class]]) {
        NSInteger allCount = 0;
        for (NSArray *tempArray in self.dataSource) {
            allCount += tempArray.count;
        }
        
        self.heightForRow = (self.frame.size.height - ((self.dataSource.count - 1) * self.sectionGap)) / allCount;
        self.heightForRow = self.heightForRow < 44.0f ? 44.0f : self.heightForRow;
        
        return self.dataSource.count;
    }else {
        self.heightForRow = self.frame.size.height / self.dataSource.count;
        self.heightForRow = self.heightForRow < 44.0f ? 44.0f : self.heightForRow;
        
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[self.dataSource firstObject] isKindOfClass:[NSArray class]]) {
        return [self.dataSource[section] count];
    }else {
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listViewCell_id_1 forIndexPath:indexPath];
    NSString *title = @"";
    if ([[self.dataSource firstObject] isKindOfClass:[NSArray class]]) {
        title = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    }else {
        title = [self.dataSource objectAtIndex:indexPath.row];
    }
    cell.titleLabel.text = title;
    cell.isShowSeparator = self.isShowSeparator;
    if(self.selectedIndexPaths.count >= 1) {
        NSString *indexString = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row];
        if ([self.selectedIndexPaths containsObject:indexString]) {
            cell.titleLabel.textColor = [UIColor yellowColor];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = @"";
    if ([[self.dataSource firstObject] isKindOfClass:[NSArray class]]) {
        title = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    }else {
        title = [self.dataSource objectAtIndex:indexPath.row];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(listMenuView:didSelectedAtIndexPath:itemTitle:)]) {
        [_delegate listMenuView:self didSelectedAtIndexPath:indexPath itemTitle:title];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.0f)];
        sectionView.backgroundColor = [UIColor whiteColor];
        return sectionView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 1.0f;
    }else {
        return 0.0f;
    }
}

#pragma mark - 赋值或set方法 ----

- (void)setIsShowSeparator:(BOOL)isShowSeparator {
    _isShowSeparator = isShowSeparator;
    [self.listView reloadData];
}

#pragma mark - 公共方法 -----
/**
 刷新源数据
 */
- (void)reloadListData {
    self.dataSource = @[];
    [self.selectedIndexPaths removeAllObjects];
    [self.listView reloadData];
}

/**
 设置选中样式
 
 @param isSelected 是否选中
 @param indexPath 设置的选项的位置
 @param clean   是否清除当前分区的其他选项选中状态
 */
- (void)setSelectedState:(BOOL)isSelected forIndexPath:(NSIndexPath *)indexPath cleanOtherItemCurrentSection:(BOOL)clean {
    
    ListMenuViewCell *cell = [self.listView cellForRowAtIndexPath:indexPath];
    if (cell) {
        // 坐标字符串
        NSString *string = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row];
        
        if(clean) {
            for (NSString *tempObject in [self.selectedIndexPaths copy]) {
                if ([tempObject hasPrefix:[@(indexPath.section) stringValue]]) {
                    [self.selectedIndexPaths removeObject:tempObject];
                }
            }
        }
        
        if (isSelected) {
            [self.selectedIndexPaths addObject:string];
        }else {
            [self.selectedIndexPaths removeObject:string];
        }
        
        [self.listView reloadData];
    }
}

/**
 更新标识符
 
 @param identifier 标识符
 */
- (void)updateIdentifier:(NSString *)identifier {
    
    if(identifier && identifier.length > 0) {
        self.identifier = identifier;
    }
}

#pragma mark - 其他私有方法 ----

/**
 初始化参数
 */
- (void)p_initialize {
    
    if (@available(iOS 11.0, *)) {
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.heightForRow = 44.0f;
    self.sectionGap = 1.0f;
}

#pragma mark - 懒加载 ---------

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = [UIColor clearColor];
        [_listView registerClass:[ListMenuViewCell class] forCellReuseIdentifier:listViewCell_id_1];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.bounces = NO;
    }
    return _listView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[];
    }
    return _dataSource;
}

- (NSMutableSet *)selectedIndexPaths {
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [[NSMutableSet alloc] init];
    }
    return _selectedIndexPaths;
}

@end

#pragma mark - 菜单标题cell  ---
@interface ListMenuViewCell ()

/**
 TitleLabel
 */
@property (readwrite, strong, nonatomic) UILabel *titleLabel;

/**
 分割线
 */
@property (strong, nonatomic) UIView *separatorView;
@end
@implementation ListMenuViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self p_initialize];
        
        [self p_setUpUI];
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)p_initialize {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)p_setUpUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.separatorView];
    
    [self p_layoutWithMasonry];
    
}

- (void)p_layoutWithMasonry {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
}

-(void)setIsShowSeparator:(BOOL)isShowSeparator {
    _isShowSeparator = isShowSeparator;
    self.separatorView.hidden = !_isShowSeparator;
}

#pragma mark - 懒加载 ---

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorView.backgroundColor = [UIColor lightGrayColor];
    }
    return _separatorView;
}

@end
