//
//  ZJBottomView.h
//  Filter
//
//  Created by zhoujian on 2018/11/17.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJBottomView : UIView
@property (nonatomic, strong) NSArray *imageNamedArray;
@property (nonatomic, strong) void (^selectedImage)(UIImage *lookupImage);
@end

NS_ASSUME_NONNULL_END
