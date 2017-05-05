//
//  ViewController.m
//  CQCitySelector
//
//  Created by 韦存情 on 2017/5/5.
//  Copyright © 2017年 qing. All rights reserved.
//

#import "ViewController.h"
#import "CQButton.h"
#import "CQCitySelectViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CQButton *citySelectButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
    
    
    [self createVC];
}


#pragma mark - createVC

- (void)createVC {
    
    // 导航栏
    self.navigationItem.title = @"城市选择器";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.citySelectButton];
}


#pragma mark - action

- (void)citySelectButtonAction:(UIButton *)button {
    
    CQCitySelectViewController *citySelecteVC = [[CQCitySelectViewController alloc] init];
    
    citySelecteVC.tintColor = [UIColor orangeColor];// 分区索引及搜索关键字的颜色
    
    // 选择城市之后的回调, cityName 为选择的城市
    citySelecteVC.block = ^(NSString *cityName) {
        
        // 根据自己的需求实现效果即可
        [self.citySelectButton setTitle:cityName forState:(UIControlStateNormal)];
    };
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:citySelecteVC] animated:YES completion:nil];
}


#pragma mark - 懒加载

- (CQButton *)citySelectButton {
    
    if (!_citySelectButton) {
        
        _citySelectButton = [[CQButton alloc] initWithButtonFrame:CGRectMake(0, 0, 63, 21) ImgViewSize:CGSizeMake(21, 21) TitleLabelSize:CGSizeMake(42, 21) LayoutStyle:ImgViewRightTitleLabell LayoutSpace:0];
        _citySelectButton.backgroundColor = [UIColor clearColor];
        
        [_citySelectButton setTitle:@"请选择" forState:(UIControlStateNormal)];
        _citySelectButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_citySelectButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        [_citySelectButton setImage:[UIImage imageNamed:@"城市选择器-返回"] forState:(UIControlStateNormal)];
        
        [_citySelectButton addTarget:self action:@selector(citySelectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _citySelectButton;
}



@end
