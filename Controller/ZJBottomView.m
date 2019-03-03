//
//  ZJBottomView.m
//  Filter
//
//  Created by zhoujian on 2018/11/17.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJBottomView.h"

@interface ZJCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *contentImgView;
@end

@implementation ZJCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.contentImgView];
    }
    return self;
}
- (UIImageView *)contentImgView {
    if(_contentImgView == nil) {
        _contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    }
    return _contentImgView;
}
@end

@interface ZJBottomView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger lastSelectedIndex;
@end

@implementation ZJBottomView


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.lastSelectedIndex = 0;
        [self setUIWithFrame:frame];
    }
    return self;
}
- (void)setUIWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(frame.size.height, frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 20;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor lightGrayColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[ZJCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZJCollectionViewCell class])];
    [self addSubview:collectionView];
    self.collectionView = collectionView;;
}
- (void)setImageNamedArray:(NSArray *)imageNamedArray {
    _imageNamedArray = imageNamedArray;
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageNamedArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZJCollectionViewCell class]) forIndexPath:indexPath];
    cell.contentImgView.image = [UIImage imageNamed:self.imageNamedArray[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.lastSelectedIndex) {
        return;
    }
    NSString *imageName = self.imageNamedArray[indexPath.row];
    self.selectedImage([UIImage imageNamed:imageName]);
    self.lastSelectedIndex = indexPath.row;
}
@end
