//
//  MultilevelMenu.m
//  MultilevelMenu
//
//  Created by Kingson on 2021/4/25.
//

#import "MultilevelMenu.h"
#import "MultilevelTableViewCell.h"
#import "ProductCateFilteHeaderView.h"
#import "CollectviewChooseCell.h"
#import "NSString+hAdd.h"
#import <Masonry/Masonry.h>

#define kCellRightLineTag 100
#define ItemHeight 70

#define kMultilevelCollectionHeader   @"CollectionHeader"//CollectionHeader
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define MAX3(a,b,c) (a>b?(a>c?a:c):(b>c?b:c))

static NSString *HeaderId = @"HeaderId";
static NSString *CellId = @"CellId";

@interface MultilevelMenu()

@property(strong,nonatomic ) UITableView * leftTablew;
//@property(strong,nonatomic ) UICollectionView * rightCollection;

@property(assign,nonatomic) BOOL isReturnLastOffset;

//可变数组记录头视图的按钮
@property(nonatomic,strong) NSMutableArray *headerBtnArr;

@end

@implementation MultilevelMenu{
    UICollectionReusableView *headReusableview;
}

- (NSMutableArray *)headerBtnArr{
    
    if (!_headerBtnArr) {
        _headerBtnArr = [NSMutableArray array];
    }
    
    return _headerBtnArr;
    
}


-(instancetype)initWithFrame:(CGRect)frame WithData:(NSArray *)data withSelectIndex:(void (^)(NSInteger, NSInteger, id))selectIndex
{
    self=[super initWithFrame:frame];
    if (self) {
        if (data.count==0) {
            return nil;
        }
        
        _block=selectIndex;
        self.leftSelectColor=[UIColor blackColor];
        self.leftSelectBgColor=[UIColor whiteColor];
        self.leftBgColor=UIColorFromRGB(0xF3F4F6);
        self.leftSeparatorColor=UIColorFromRGB(0xE5E5E5);
        self.leftUnSelectBgColor=UIColorFromRGB(0xF3F4F6);
        self.leftUnSelectColor=[UIColor blackColor];
        
        _selectIndex=0;
        _allData=data;
        
        _choosedArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        /**
         左边的视图
        */
        self.leftTablew=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftWidth, frame.size.height)];
        self.leftTablew.dataSource=self;
        self.leftTablew.delegate=self;
        
        self.leftTablew.tableFooterView=[[UIView alloc] init];
        [self addSubview:self.leftTablew];
        self.leftTablew.backgroundColor=self.leftBgColor;
        if ([self.leftTablew respondsToSelector:@selector(setLayoutMargins:)]) {
            self.leftTablew.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.leftTablew respondsToSelector:@selector(setSeparatorInset:)]) {
            self.leftTablew.separatorInset=UIEdgeInsetsZero;
        }
        self.leftTablew.separatorColor=self.leftSeparatorColor;
        
        self.leftTablew.estimatedRowHeight = 70;
        self.leftTablew.rowHeight = UITableViewAutomaticDimension;
        
        
        /**
         右边的视图
         */
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        
        self.rightCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(kLeftWidth,0,kScreenWidth-kLeftWidth,frame.size.height) collectionViewLayout:flowLayout];
        
        self.rightCollection.delegate=self;
        self.rightCollection.dataSource=self;
        
        UINib *header=[UINib nibWithNibName:kMultilevelCollectionHeader bundle:nil];
        [self.rightCollection registerNib:header forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMultilevelCollectionHeader];
        
        [self.rightCollection registerClass:[ProductCateFilteHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:HeaderId];
        
        [self.rightCollection registerClass:[CollectviewChooseCell class] forCellWithReuseIdentifier:CellId];
        
        self.rightCollection.showsVerticalScrollIndicator = NO;
        
        [self addSubview:self.rightCollection];
        
      
        self.isReturnLastOffset=YES;
        
        self.rightCollection.backgroundColor=self.leftSelectBgColor;
        
        
        self.backgroundColor=self.leftSelectBgColor;
        
    }
    return self;
}

-(void)setNeedToScorllerIndex:(NSInteger)needToScorllerIndex{
    
        /**
         *  滑动到 指定行数
         */
        [self.leftTablew selectRowAtIndexPath:[NSIndexPath indexPathForRow:needToScorllerIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

        _selectIndex=needToScorllerIndex;
        
        [self.rightCollection reloadData];

    _needToScorllerIndex=needToScorllerIndex;
}
-(void)setLeftBgColor:(UIColor *)leftBgColor{
    _leftBgColor=leftBgColor;
    self.leftTablew.backgroundColor=leftBgColor;
   
}
-(void)setLeftSelectBgColor:(UIColor *)leftSelectBgColor{
    
    _leftSelectBgColor=leftSelectBgColor;
    self.rightCollection.backgroundColor=leftSelectBgColor;
    
    self.backgroundColor=leftSelectBgColor;
}
-(void)setLeftSeparatorColor:(UIColor *)leftSeparatorColor{
    _leftSeparatorColor=leftSeparatorColor;
    self.leftTablew.separatorColor=leftSeparatorColor;
}
-(void)reloadData{
    
    [self.leftTablew reloadData];
    [self.rightCollection reloadData];
    
}
-(void)setLeftTablewCellSelected:(BOOL)selected withCell:(MultilevelTableViewCell*)cell
{
    UILabel * line=(UILabel*)[cell viewWithTag:kCellRightLineTag];
    if (selected) {
        
        line.backgroundColor=cell.backgroundColor;
        cell.titile.textColor=self.leftSelectColor;
        cell.backgroundColor=self.leftSelectBgColor;
    }
    else{
        cell.titile.textColor=self.leftUnSelectColor;
        cell.backgroundColor=self.leftUnSelectBgColor;
        line.backgroundColor=_leftTablew.separatorColor;
    }
   

}

#pragma mark---左边的tablew 代理
#pragma mark--deleagte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allData.count;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * Identifier=@"MultilevelTableViewCell";
    MultilevelTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"MultilevelTableViewCell" owner:self options:nil][0];
        
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(kLeftWidth-0.5, 0, 0.5, 44)];
        label.backgroundColor = tableView.separatorColor;
        [cell addSubview:label];
        label.numberOfLines = 0;
        label.tag = kCellRightLineTag;
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    rightMeun * title=self.allData[indexPath.row];
    
    cell.titile.text = title.meunName;
    
    cell.titile.font = [UIFont systemFontOfSize:13];
    
    if (indexPath.row==self.selectIndex) {
        
        [self setLeftTablewCellSelected:YES withCell:cell];
        
    }else{
        
        [self setLeftTablewCellSelected:NO withCell:cell];


    }
    

    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins=UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset=UIEdgeInsetsZero;
    }
    
    
    return cell;
    
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MultilevelTableViewCell * cell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    _selectIndex = indexPath.row;
    
    [self setLeftTablewCellSelected:YES withCell:cell];

    rightMeun *title=self.allData[indexPath.row];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.isReturnLastOffset=NO;
    
    
    [self.rightCollection reloadData];
    
    if (self.isRecordLastScroll) {
        [self.rightCollection scrollRectToVisible:CGRectMake(0, title.offsetScorller, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:self.isRecordLastScrollAnimated];
    }
    else{
        
         [self.rightCollection scrollRectToVisible:CGRectMake(0, 0, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:self.isRecordLastScrollAnimated];
    }
    
    
    

}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MultilevelTableViewCell * cell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    [self setLeftTablewCellSelected:NO withCell:cell];

    cell.backgroundColor = self.leftUnSelectBgColor;
}

#pragma mark---imageCollectionView--------------------------

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    if (self.allData.count==0) {
        return 0;
    }
    
    rightMeun * title=self.allData[self.selectIndex];
    return title.nextArray.count;
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView  numberOfItemsInSection:(NSInteger)section{
    rightMeun * title=self.allData[self.selectIndex];
    if (title.nextArray.count>0) {
        
        rightMeun *sub=title.nextArray[section];
        
        if (sub.nextArray.count==0)//没有下一级
        {
            return 1;
        }
        else
            return sub.nextArray.count;
        
    }else{
        return title.nextArray.count;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectviewChooseCell * cell = (CollectviewChooseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    rightMeun *title = self.allData[self.selectIndex];
    
    //获取到当前选择的item
    rightMeun *menu;
    
    menu = title.nextArray[indexPath.section];
    
    NSArray *menuArr = [NSArray array];
    
    if (title.nextArray.count > 0) {
        
        rightMeun * meun2;
        
        meun2 = title.nextArray[indexPath.section];
        
        menuArr = [meun2.nextArray copy];
        
    }
    
    if (menu.nextArray.count > 0) {
        menu = menu.nextArray[indexPath.row];
    }
    
    //更新当前选择的行，设计点击背景图片
    [cell UpdateCellWithState:!cell.isSelected];
    
    //选择后添加到字典
    if (cell.isSelected) {
        [_choosedArr addObject:menu];
    }else{
        
        for (int i = 0; i < _choosedArr.count; i++) {
            
            rightMeun *ocl = [_choosedArr objectAtIndex:i];
            
            if ([ocl.meunName isEqualToString:menu.meunName]) {
                [_choosedArr removeObject:ocl];
            }
            
        }
        
    }
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
    
    //刷新当前的数据列表，使用该方法是判断是否点击了全选
    [UIView animateWithDuration:0 animations:^{
        [UIView performWithoutAnimation:^{
            [_rightCollection reloadSections:indexSet];
        }];
    }];
    
    _chooseBlock(cell.titleLab.text,_choosedArr);
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    rightMeun * title = self.allData[self.selectIndex];
    NSArray *list;
    
    rightMeun * meun;

    meun=title.nextArray[indexPath.section];

    if (meun.nextArray.count > 0) {
        meun = title.nextArray[indexPath.section];
        list = meun.nextArray;
        meun = list[indexPath.row];
    }
    
    NSString *reuseIdetify = CellId;
    CollectviewChooseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLab.text = meun.meunName;
    cell.titleLab.numberOfLines = 0;

    //判断数组内是否全选
    BOOL isContain = NO;
    
    if (_choosedArr.count > 0) {
        for (rightMeun *ocl in _choosedArr) {
            if ([ocl.meunName isEqualToString:meun.meunName]) {
                isContain = YES;
                break;
            }
        }
    }

    if (isContain) {
        
        [cell UpdateCellWithState:YES];
        
    }else{
        
        [cell UpdateCellWithState:NO];
        
    }
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        reuseIdentifier = @"footer";
    }else{
        reuseIdentifier = kMultilevelCollectionHeader;
    }
    
    rightMeun *title = self.allData[self.selectIndex];

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        ProductCateFilteHeaderView *headReusableview = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderId forIndexPath:indexPath];
        
        headReusableview.backgroundColor = [UIColor whiteColor];
        
        //取消复用
        for (UIView *view in headReusableview.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *HeaderTitleLab = [[UILabel alloc] init];
        
        [HeaderTitleLab setFont:[UIFont systemFontOfSize:15.0f]];
        
        HeaderTitleLab.numberOfLines = 0;
        
        NSArray *menuArr = [NSArray array];
        
//        HeaderTitleLab.text = @"全选";
        if (title.nextArray.count > 0) {
            
            rightMeun * meun;
            meun=title.nextArray[indexPath.section];
            
            HeaderTitleLab.text = meun.meunName;
            
            menuArr = [meun.nextArray copy];
            
        }else{
            
            HeaderTitleLab.text = @"暂无";

        }
    
        [headReusableview addSubview:HeaderTitleLab];
        [HeaderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(headReusableview.mas_left).offset(15);
            
            make.top.equalTo(headReusableview.mas_top).offset(0);
            make.height.mas_equalTo(headReusableview.mas_height);
        }];
        
        UIButton *chooseIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //判断当前的全选状态
        [chooseIcon setImage:[UIImage imageNamed:@"table_UnSelect"] forState:UIControlStateNormal];
        [chooseIcon setImage:[UIImage imageNamed:@"table_Selected"] forState:UIControlStateSelected];
        chooseIcon.tag = indexPath.section;
        [chooseIcon addTarget:self action:@selector(ChooseAllClick:) forControlEvents:UIControlEventTouchUpInside];
        [headReusableview addSubview:chooseIcon];
        [chooseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(HeaderTitleLab.mas_right).offset(10);
            make.right.equalTo(headReusableview.mas_right).offset(-15);
            make.top.equalTo(headReusableview.mas_top);
            make.height.mas_equalTo(headReusableview.mas_height);
            make.width.mas_equalTo(50);
        }];
        
        BOOL isContain2 = true;
//        //找出相同的数组
        if (_choosedArr.count > 0) {
            NSMutableArray *testArr1 = [NSMutableArray array];

            for (rightMeun *ocl in _choosedArr) {
                for (rightMeun *ocl2 in menuArr) {
                    if ([ocl.meunName isEqualToString:ocl2.meunName]) {
                        [testArr1 addObject:ocl];
                    }
                }
            }
            
            [testArr1 sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                rightMeun *key1 = obj1;
                rightMeun *key2 = obj2;
                
                NSInteger key1Integer = [key1.ID integerValue];
                
                NSInteger key2Integer = [key2.ID integerValue];
                
                if (key1Integer < key2Integer) {
                    return NSOrderedAscending;
                }
                if (key1Integer > key2Integer) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;;
                
            }];
            
            if (testArr1.count == 0 && menuArr.count == 0) {
                isContain2 = false;
            }else{
                isContain2 = [[testArr1 copy] isEqual:menuArr];
            }
            
        }else{
            isContain2 = false;
        }

        if (isContain2) {
            [chooseIcon setSelected:YES];

        }else{

            [chooseIcon setSelected:NO];

        }
        
        
        return headReusableview;
        
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier  forIndexPath:indexPath];
        
        UILabel *label = (UILabel *)[view viewWithTag:1];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColorFromRGB(0x686868);
        
        view.backgroundColor = [UIColor lightGrayColor];
        label.text = [NSString stringWithFormat:@"这是footer:%ld",(long)indexPath.section];
        return view;
    }else{
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier  forIndexPath:indexPath];
        return view;
        
    }
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    return CGSizeMake(60, 90);
    //根据文本计算出item的高度
    rightMeun * title = self.allData[self.selectIndex];
    NSArray *list;
    
    rightMeun * meun;

    meun=title.nextArray[indexPath.section];

    if (meun.nextArray.count > 0) {
        meun = title.nextArray[indexPath.section];
        list = meun.nextArray;
        meun = list[indexPath.row];
    }
    
    NSInteger rowC = indexPath.row;
    
    CGFloat labelWidth = (kScreenWidth - kLeftWidth - 4 * 10) / 3;
    CGFloat itemHeight = 0;
    
    //计算一行中最大的高度
    if (list.count > 0) {
        CGFloat textHeight = [meun.meunName heightForFont:[UIFont systemFontOfSize:12.0f] width:labelWidth];
        CGFloat textHeight1 = 0;
        CGFloat textHeight2 = 0;
        
        if (rowC % 3 == 0) {
            
            if (rowC + 1 < list.count) {
                rightMeun * meun1 = list[rowC + 1];
                textHeight1 = [meun1.meunName heightForFont:[UIFont systemFontOfSize:12.0f] width:labelWidth];
            }
            
            if (rowC + 2 < list.count) {
                rightMeun * meun2 = list[rowC + 2];
                textHeight2 = [meun2.meunName heightForFont:[UIFont systemFontOfSize:12.0f] width:labelWidth];
            }
            
            itemHeight = MAX3(textHeight, textHeight1, textHeight2);
            
            
        }else if (rowC % 3 == 1){
            rightMeun * meun1 = list[rowC - 1];
            textHeight1 = [meun1.meunName heightForFont:[UIFont systemFontOfSize:12.0f] width:labelWidth];
            
            if (rowC + 1 < list.count) {
                rightMeun * meun2 = list[rowC + 1];
                textHeight2 = [meun2.meunName heightForFont:[UIFont systemFontOfSize:12.0f] width:labelWidth];
            }
            
            itemHeight = MAX3(textHeight, textHeight1, textHeight2);
            
            
        }else if (rowC % 3 == 2){
            
            rightMeun * meun1 = list[rowC - 2];
            textHeight1 = [meun1.meunName heightForFont:[UIFont systemFontOfSize:12.0f] width:labelWidth];
            
            rightMeun * meun2 = list[rowC - 1];
            textHeight2 = [meun2.meunName heightForFont:[UIFont systemFontOfSize:12.0f] width:labelWidth];
            
            itemHeight = MAX3(textHeight, textHeight1, textHeight2);
            
        }
        
    }
    
    
    return CGSizeMake((kScreenWidth - kLeftWidth - 4 * 10) / 3,itemHeight + 20);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {kScreenWidth,44};
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    //行间距
    return 10;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}


#pragma mark---记录滑动的坐标
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.rightCollection]) {

        
        self.isReturnLastOffset=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.rightCollection]) {
        
        rightMeun * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;
        self.isReturnLastOffset=NO;
        
    }

 }

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.rightCollection]) {
        
        rightMeun * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;
        self.isReturnLastOffset=NO;
        
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.rightCollection] && self.isReturnLastOffset) {
        rightMeun * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;

        
    }
}

-(void)ChooseAllClick:(UIButton *)button{
    
    NSInteger sectionIndex = button.tag;
    
    BOOL selectType = button.isSelected;
    
    rightMeun *title = self.allData[self.selectIndex];
    
    //获取到当前选择的item
    rightMeun *menu;
    
    menu = title.nextArray[sectionIndex];
    
    NSArray *selectArr = menu.nextArray;
    
    if (selectArr.count > 0) {
        
        //判断当前是全选还是取消全选状态
        
        if (_choosedArr.count == 0) {
            //全选
            if (!selectType) {
                //选中
                [_choosedArr addObjectsFromArray:selectArr];
            }
            
            
        }else{
            
            if (selectType) {
                //移除数组内数据
                [_choosedArr removeObjectsInArray:selectArr];
                
            }else{
                //添加到数组内
                [_choosedArr removeObjectsInArray:selectArr];
                
                [_choosedArr addObjectsFromArray:selectArr];
                
            }
            
        }
        
        
    }
    
    
    
    //记录选择的数据 并更新视图
    _ifAllSelecteSwitch = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:button.tag];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
    
    [_rightCollection reloadSections:indexSet];
    
    
    
//    [_rightCollection reloadData];
    _chooseBlock(@"All",_choosedArr);
    
}


#pragma mark--Tools
-(void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end



@implementation rightMeun


- (BOOL)isEqual:(rightMeun *)object{
    
    return [self isEualToRightMeun:object];
    
}


-(BOOL)isEualToRightMeun:(rightMeun *)rightMenu{
    
    if (![rightMenu isKindOfClass:self.class]) {
        return NO;
    }
    
    BOOL result = ([self.meunName isEqualToString:rightMenu.meunName]);
    
    if (result == NO) {
        return NO;
    }else{
        return YES;
    }
    
}


@end
