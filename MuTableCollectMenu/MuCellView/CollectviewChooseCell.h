//
//  CollectviewChooseCell.h
//  MuTableCollectMenu
//
//  Created by Kingson on 2021/4/25.
//

#import <UIKit/UIKit.h>

@interface CollectviewChooseCell : UICollectionViewCell
@property(nonatomic,retain)UILabel *titleLab;
@property(nonatomic,retain)UIButton *SelectIconBtn;
@property (nonatomic,assign)BOOL isSelected;
-(void)UpdateCellWithState:(BOOL)select;

@end
