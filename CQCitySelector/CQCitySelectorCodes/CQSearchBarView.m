//
//  CQSearchBarView.m
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/1.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "CQSearchBarView.h"

#import "CQButton.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@interface CQSearchBarView ()<UISearchBarDelegate>

@property (strong, nonatomic) UIButton *tempButton;

@end

@implementation CQSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        [self createVC];
    }
    
    return self;
}


#pragma mark - createVC

- (void)createVC {
    
    [self addSubview:self.topView];
}


#pragma mark - action

// 自定义取消搜索
- (void)cancelSearch {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.searchBar.showsCancelButton = NO;
        [self layoutIfNeeded];
    }];
    
    self.tempButton.hidden = YES;
    
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    
    if (self.didCancelSearch) {
        
        self.didCancelSearch();
    }
}


#pragma mark - searchBarDelegate

// 开始搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.searchBar.showsCancelButton = YES;
        [self.viewForLastBaselineLayout layoutIfNeeded];
    }];
    
    self.tempButton.hidden = NO;
    
    if (self.didBeginSearch) {
        
        self.didBeginSearch();
    }
}

// 搜索内容发生改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (self.textDidChange) {
        
        self.textDidChange(searchBar.text);
    }
}

// 取消搜索
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self cancelSearch];
}

// 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
}


#pragma mark - 懒加载

- (UIView *)topView {
    
    if (!_topView) {
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20 - 15, 44)];
        self.searchBar.backgroundColor = [UIColor clearColor];
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.searchBar.placeholder = @"请输入城市名或拼音";
        self.searchBar.delegate = self;
        [_topView addSubview:self.searchBar];
        
        if (kDevice_Is_iPhone4 || kDevice_Is_iPhone5) {
            
            self.tempButton = [[UIButton alloc] initWithFrame:CGRectMake(235, 6, 60, 30)];
        }else if (kDevice_Is_iPhone6) {
            
            self.tempButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 6, 60, 30)];
        }else if (kDevice_Is_iPhone6Plus) {
            
            self.tempButton = [[UIButton alloc] initWithFrame:CGRectMake(330, 6, 60, 30)];
        }
        self.tempButton.backgroundColor = [UIColor clearColor];
        self.tempButton.hidden = YES;
        [self.tempButton addTarget:self action:@selector(cancelSearch) forControlEvents:(UIControlEventTouchUpInside)];
        [self.searchBar addSubview:self.tempButton];
    }
    
    return _topView;
}

@end
