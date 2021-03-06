//
//  CollectviewChooseCell.m
//  MuTableCollectMenu
//
//  Created by Kingson on 2021/4/25.
//


#import "CollectviewChooseCell.h"
#import <Masonry/Masonry.h>
#define SelectNum_ItemHeight 51
#define SelectNum_ItemWidth 77
#define ItemFont1 17
#define ItemFont2 16

@implementation CollectviewChooseCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return  self;
}


-(void)initView{
    _SelectIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SelectIconBtn.userInteractionEnabled = NO;
    [_SelectIconBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_SelectIconBtn setBackgroundImage:[UIImage imageNamed:@"collectview_Unselect"] forState:UIControlStateNormal];
    [_SelectIconBtn setBackgroundImage:[UIImage imageNamed:@"collectview_Selected"] forState:UIControlStateSelected];
    _SelectIconBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_SelectIconBtn];
    [_SelectIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(0);
//        make.right.equalTo(self.contentView.mas_right).offset(0);
//        make.top.equalTo(self.contentView.mas_top).offset(0);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        
    }];

    _titleLab = [[UILabel alloc]init];
    _titleLab.textColor = [UIColor darkTextColor];
    _titleLab.font = [UIFont systemFontOfSize:12];
//    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLab.numberOfLines = 0;
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}



-(void)UpdateCellWithState:(BOOL)select{
    self.SelectIconBtn.selected = select;
    _isSelected = select;
}


@end
