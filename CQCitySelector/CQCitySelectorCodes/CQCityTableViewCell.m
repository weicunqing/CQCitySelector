//
//  CQCityTableViewCell.m
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/2.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "CQCityTableViewCell.h"

#import "CQCityCollectionViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CQCityTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation CQCityTableViewCell

- (void)setCityArray:(NSArray *)cityArray {
    
    _cityArray = cityArray;
    
    [self.collectionView reloadData];
}

// 重写初始化方法(必须重写这种特有的初始化方法, 重写 init 不行)
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 写在 init 方法里无法获取到 cell 的高度
    [self drawView];
}


#pragma mark - drawView

- (void)drawView {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.collectionView];
}


#pragma mark - collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.cityArray.count;
}

static NSString * const cellReuseID = @"cellReuseID";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CQCityCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    cell.textLabel.text = self.cityArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.cityArray[indexPath.item] isEqualToString:@"暂无"] && ![self.cityArray[indexPath.item] isEqualToString:@"定位中..."] && ![self.cityArray[indexPath.item] isEqualToString:@"请选择"]) {
        
        if (self.block) {
            
            self.block(self.cityArray[indexPath.item]);
        }
    }
}


#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 55) / 3.0, 34);// 每个 item 的大小
        flowLayout.minimumLineSpacing = 10;// 最小行间距(是最小行间距, 系统会自动调整为合适的间距, 不一定是我们给定的值, 但是不会小于我们给定的值)
        flowLayout.minimumInteritemSpacing = 10;// 同一列中 cell 之间的最小间距(是最小行间距, 系统会自动调整为合适的间距, 不一定是我们给定的值, 但是不会小于我们给定的值)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 9, 10, 24);// 某个 section 中 cell 的边界范围
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;// 滑动方向
                
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[CQCityCollectionViewCell class] forCellWithReuseIdentifier:cellReuseID];
    }
    
    return _collectionView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
