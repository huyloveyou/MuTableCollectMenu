//
//  HeaderView.m
//  MulChooseDemo
//
//  Created by L2H on 16/7/13.
//  Copyright © 2016年 ailk. All rights reserved.
//

#import "ProductCateFilteHeaderView.h"
#import <Masonry/Masonry.h>

@implementation ProductCateFilteHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initView];
    }
    return self;
}



-(void)initView{
    
    self.HeaderTitleLab = [[UILabel alloc] init];
    
    [self addSubview:self.HeaderTitleLab];
    
    [self.HeaderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    self.chooseIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.chooseIcon setImage:[UIImage imageNamed:@"table_UnSelect"] forState:UIControlStateNormal];
    [self.chooseIcon setImage:[UIImage imageNamed:@"table_Selected"] forState:UIControlStateSelected];
    
    [self.chooseIcon addTarget:self action:@selector(ChooseAllClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.chooseIcon];
    
    [self.chooseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HeaderTitleLab.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(self.mas_height);
        make.width.mas_equalTo(50);
    }];
    
    
}



-(void)ChooseAllClick:(UIButton *)button{
    
    
    if (self.headClickBlock) {
        self.headClickBlock(button);
    }
    
}

- (void)setIsAllSelected:(BOOL)isAllSelected{
    
    _isAllSelected = isAllSelected;
    
    if (_isAllSelected) {
        [self.chooseIcon setImage:[UIImage imageNamed:@"table_Selected"] forState:UIControlStateNormal];
    }else{
        [self.chooseIcon setImage:[UIImage imageNamed:@"table_UnSelect"] forState:UIControlStateNormal];
    }
    
}




@end
