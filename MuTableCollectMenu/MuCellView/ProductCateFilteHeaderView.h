//
//  HeaderView.h
//  MulChooseDemo
//
//  Created by L2H on 16/7/13.
//  Copyright © 2016年 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCateFilteHeaderView;
typedef void (^HeadClickBlock) (UIButton *);

@interface ProductCateFilteHeaderView : UICollectionReusableView

@property(nonatomic,strong)UILabel *HeaderTitleLab;
@property(nonatomic,strong)UIButton *chooseIcon;
@property (nonatomic,assign)BOOL isAllSelected;

@property(nonatomic, copy) HeadClickBlock headClickBlock;

@end
