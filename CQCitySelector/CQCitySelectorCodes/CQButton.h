//
//  CQButton.h
//  CQButtonDemoi
//
//  Created by 意一yiyi on 2017/2/20.
//  Copyright © 2017年 yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LayoutStyle) {

    ImgViewOnTitleLabel, // img在上, label在下
    ImgViewLeftTitleLabel, // img在左, label在右
    ImgViewUnderTitleLabel, // img在下, label在上
    ImgViewRightTitleLabell // img在右, label在左
};

@interface CQButton : UIButton


#pragma mark - 这三个属性常用于 cell 上面的 button 需要绑定其所在 cell 的情况

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) int section;
@property (assign, nonatomic) int row;


#pragma mark - 常用于需要图片和文字组合的情况

- (instancetype)initWithButtonFrame:(CGRect)buttonFrame
                        ImgViewSize:(CGSize)imgViewSize
                     TitleLabelSize:(CGSize)titleLabelSize
                        LayoutStyle:(LayoutStyle)style
                        LayoutSpace:(CGFloat)space;

@end
