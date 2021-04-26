//
//  MultilevelMenu.h
//  MultilevelMenu
//
//  Created by Kingson on 2021/4/25.
//

#import <UIKit/UIKit.h>

#define kLeftWidth 100

typedef void(^ChooseBlock) (NSString *chooseContent,NSMutableArray *chooseArr);

@interface MultilevelMenu : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic,readonly) NSArray * allData;


@property(copy,nonatomic,readonly) id block;

/**
 *  是否 记录滑动位置
 */
@property(assign,nonatomic) BOOL isRecordLastScroll;
/**
 *   记录滑动位置 是否需要 动画
 */
@property(assign,nonatomic) BOOL isRecordLastScrollAnimated;
/**
 *   记录已选中的数据索引
 */
@property(assign,nonatomic,readonly) NSInteger selectIndex;

/**
 *  为了 不修改原来的，因此增加了一个属性，选中指定 行数
 */
@property(assign,nonatomic) NSInteger needToScorllerIndex;
/**
 *  颜色属性配置
 */

/**
 *  左边背景颜色
 */
@property(strong,nonatomic) UIColor * leftBgColor;
/**
 *  左边点中文字颜色
 */
@property(strong,nonatomic) UIColor * leftSelectColor;
/**
 *  左边点中背景颜色
 */
@property(strong,nonatomic) UIColor * leftSelectBgColor;

/**
 *  左边未点中文字颜色
 */

@property(strong,nonatomic) UIColor * leftUnSelectColor;
/**
 *  左边未点中背景颜色
 */
@property(strong,nonatomic) UIColor * leftUnSelectBgColor;
/**
 *  tablew 的分割线
 */
@property(strong,nonatomic) UIColor * leftSeparatorColor;

@property(nonatomic,strong)NSMutableArray * dataArr;

@property(nonatomic,strong)NSMutableArray * choosedArr;

@property(nonatomic,strong)NSMutableDictionary * choosedDic;

@property(nonatomic,copy)ChooseBlock chooseBlock;

@property (nonatomic,assign)BOOL ifAllSelected;

@property (nonatomic,assign)BOOL ifAllSelecteSwitch;

@property(strong,nonatomic ) UICollectionView * rightCollection;


-(instancetype)initWithFrame:(CGRect)frame WithData:(NSArray*)data withSelectIndex:(void(^)(NSInteger left,NSInteger right,id info))selectIndex;

@end


@interface rightMeun : NSObject

/**
 *  菜单图片名
 */
@property(copy,nonatomic) NSString * urlName;
/**
 *  菜单名
 */
@property(copy,nonatomic) NSString * meunName;
/**
 *  菜单ID
 */
@property(copy,nonatomic) NSString * ID;

/**
 *  父级ID
 */
@property(assign,nonatomic) NSInteger parentID;



/**
 *  下一级菜单
 */
@property(strong,nonatomic) NSArray * nextArray;

/**
 *  菜单层数
 */
@property(assign,nonatomic) NSInteger meunNumber;

@property(assign,nonatomic) float offsetScorller;

/**
 *  模型数组
 */
@property(nonatomic,strong) NSMutableArray *allModelArr;


/// 根据ID和MenuName判断RightMenu是否相同
/// @param rightMenu 需要比较的对象
-(BOOL)isEualToRightMeun:(rightMeun *)rightMenu;


@end

