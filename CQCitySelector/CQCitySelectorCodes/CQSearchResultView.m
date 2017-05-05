//
//  CQSearchResultView.m
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/1.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "CQSearchResultView.h"

#import "NSString+CQAttributeStringTools.h"

@interface CQSearchResultView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CQSearchResultView

#pragma mark - 数据

- (void)setSearchResultArray:(NSMutableArray *)searchResultArray {
    
    _searchResultArray = searchResultArray;
    
    // 只需要在赋值搜索结果的时候再显示 tableView
    if (_searchResultArray.count == 0) {
        
        [self.searchResultArray addObject:@"抱歉，未找到相关位置，可修改后重试"];
    }
    
    [self addSubview:self.searchResultTableView];
    [self.searchResultTableView reloadData];
}


#pragma mark - tableView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.scroll) {
        
        self.scroll();
    }
}

static NSString * const cellReuseID = @"cellReuseID";
- (UITableView *)searchResultTableView {
    
    if (!_searchResultTableView) {
        
        _searchResultTableView = [[UITableView alloc] initWithFrame:self.bounds style:(UITableViewStylePlain)];
        _searchResultTableView.backgroundColor = [UIColor whiteColor];
        
        [_searchResultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseID];
        
        _searchResultTableView.dataSource = self;
        _searchResultTableView.delegate = self;
    }
    
    return _searchResultTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.searchResultTableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
//    if ([self.searchResultArray[indexPath.row] length] != 0) {
    
        cell.textLabel.attributedText =  [self.searchResultArray[indexPath.row] changeToAttributeStringWithSubstringArray:@[self.keywords] Color:self.keywordsColor FontSize:17];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.searchResultArray[indexPath.row] isEqualToString:@"抱歉，未找到相关位置，可修改后重试"]) {
        
        if (self.selectCityBlock) {
            
            self.selectCityBlock(self.searchResultArray[indexPath.row]);
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.tapView) {
        
        self.tapView();
    }
}

@end
