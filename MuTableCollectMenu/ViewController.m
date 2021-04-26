//
//  ViewController.m
//  MuTableCollectMenu
//
//  Created by Kingson on 2021/4/25.
//

#define hScreenWidth [UIScreen mainScreen].bounds.size.width
#define hScreenHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "MultilevelMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSelectView];
    
    // Do any additional setup after loading the view.
}


-(void)configSelectView{
    
    //获取三级分类数组
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    
   
    /**
     *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
     */
    NSInteger countMax=6;
    for (int i=0; i<countMax; i++) {
        
        rightMeun * meun=[[rightMeun alloc] init];
        meun.ID = [NSString stringWithFormat:@"%d",i];
        meun.meunName=[NSString stringWithFormat:@"%d",i];
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        for ( int j=0; j <countMax+1; j++) {
            
            rightMeun * meun1=[[rightMeun alloc] init];
            
            meun1.meunName=[NSString stringWithFormat:@"%d一级菜单%d",i,j];
            meun1.ID = [NSString stringWithFormat:@"%d",j];
            meun1.parentID = i;
            [sub addObject:meun1];
            
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            
            for ( int z=0; z <countMax+2; z++) {
                
                rightMeun * meun2=[[rightMeun alloc] init];
                meun2.ID = [NSString stringWithFormat:@"%d",z];
                meun2.parentID = j;
                meun2.meunName=[NSString stringWithFormat:@"%d二级菜单%d-%d",j,z,i];
                
                [zList addObject:meun2];
                
            }
            
            
            meun1.nextArray=zList;
        }
        
       
        meun.nextArray=sub;
        [lis addObject:meun];
    }

    MultilevelMenu * mView = [[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 64, hScreenWidth, hScreenHeight - 64) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        
    }];
    
    
    mView.needToScorllerIndex = 0;

    mView.isRecordLastScroll = YES;
    
    mView.leftSelectColor = [UIColor purpleColor];
    
    mView.chooseBlock = ^(NSString *chooseContent, NSMutableArray *chooseArr) {
        
        
    };
    
    [self.view addSubview:mView];
    
    
}

@end
