//
//  CQCityCollectionViewCell.m
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/1.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "CQCityCollectionViewCell.h"

@interface CQCityCollectionViewCell ()

@end

@implementation CQCityCollectionViewCell

// 重写初始化方法(必须重写这种特有的初始化方法, 重写 init 不行)
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        [self drawView];
    }
    
    return self;
}

#pragma mark - drawView

- (void)drawView {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.textLabel];
}


#pragma mark - 懒加载

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.backgroundColor = [UIColor whiteColor];
        
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [UIColor colorWithRed:61 / 255.0 green:61 / 255.0 blue:61 / 255.0 alpha:1];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.masksToBounds = YES;
    }
    
    return _textLabel;
}

@end
