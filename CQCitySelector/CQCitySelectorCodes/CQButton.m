//
//  CQButton.m
//  CQButtonDemoi
//
//  Created by 意一yiyi on 2017/2/20.
//  Copyright © 2017年 yiyi. All rights reserved.
//

#import "CQButton.h"

@interface CQButton ()

@property (assign, nonatomic) CGSize imgViewSize;
@property (assign, nonatomic) CGSize titleLabelSize;
@property (assign, nonatomic) LayoutStyle style;
@property (assign, nonatomic) CGFloat space;

@end

@implementation CQButton

// 自定义初始化方法
- (instancetype)initWithButtonFrame:(CGRect)buttonFrame
                        ImgViewSize:(CGSize)imgViewSize
                     TitleLabelSize:(CGSize)titleLabelSize
                        LayoutStyle:(LayoutStyle)style
                        LayoutSpace:(CGFloat)space {

    self = [super init];
    if (self) {
        
        self.frame = buttonFrame;
        
        // 获取布局需要的基本数据
        self.imgViewSize = imgViewSize;
        self.titleLabelSize = titleLabelSize;
        self.style = style;
        self.space = space;
        
        // 文本居中显示
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 图片非拉伸居中显示
        self.imageView.contentMode = UIViewContentModeCenter;
        
        // 取消 button 的点击效果
        self.adjustsImageWhenHighlighted = NO;
    }
    
    return self;
}

// 布局
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.backgroundColor = [UIColor clearColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    // 1. 得到 button, imgView, titleLabel 的宽和高
    CGFloat buttonWidth = self.frame.size.width;
    CGFloat buttonHeight = self.frame.size.height;
    
    CGFloat imgWidth = self.imgViewSize.width;
    CGFloat imgHeight = self.imgViewSize.height;
    
    CGFloat titleLabelWidth = self.titleLabelSize.width;
    CGFloat titleLabelHeight = self.titleLabelSize.height;
    
    // 2. 根据 style 和 space 布局
    switch (self.style) {
        case ImgViewOnTitleLabel:
        {
            self.imageView.frame = CGRectMake((buttonWidth - imgWidth) / 2.0, (buttonHeight - imgHeight - titleLabelHeight  - self.space) / 2.0, self.imgViewSize.width, self.imgViewSize.height);
            self.titleLabel.frame = CGRectMake((buttonWidth - titleLabelWidth) / 2.0, (buttonHeight - imgHeight - titleLabelHeight - self.space) / 2.0 + imgHeight + self.space, self.titleLabelSize.width, self.titleLabelSize.height);
        }
            break;
        case ImgViewLeftTitleLabel:
        {
            self.imageView.frame = CGRectMake((buttonWidth - imgWidth - titleLabelWidth - self.space) / 2.0, (buttonHeight - imgHeight) / 2.0, self.imgViewSize.width, self.imgViewSize.height);
            self.titleLabel.frame = CGRectMake((buttonWidth - imgWidth - titleLabelWidth - self.space) / 2.0 + imgWidth + self.space, (buttonHeight - titleLabelHeight) / 2.0, self.titleLabelSize.width, self.titleLabelSize.height);
        }
            break;
        case ImgViewUnderTitleLabel:
        {
            self.imageView.frame = CGRectMake((buttonWidth - imgWidth) / 2.0, (buttonHeight - imgHeight - titleLabelHeight - self.space) / 2.0 + titleLabelHeight + self.space, self.imgViewSize.width, self.imgViewSize.height);
            self.titleLabel.frame = CGRectMake((buttonWidth - titleLabelWidth) / 2.0, (buttonHeight - imgHeight - titleLabelHeight - self.space) / 2.0, self.titleLabelSize.width, self.titleLabelSize.height);
        }
            break;
        case ImgViewRightTitleLabell:
        {
            self.imageView.frame = CGRectMake((buttonWidth - imgWidth - titleLabelWidth - self.space) / 2.0 + titleLabelWidth + self.space, (buttonHeight - imgHeight) / 2.0, self.imgViewSize.width, self.imgViewSize.height);
            self.titleLabel.frame = CGRectMake((buttonWidth - imgWidth - titleLabelWidth - self.space) / 2.0, (buttonHeight - titleLabelHeight) / 2.0, self.titleLabelSize.width, self.titleLabelSize.height);
        }
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
