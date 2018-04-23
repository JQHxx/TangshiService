//
//  TCCheckListViewController.m
//  TangShiService
//
//  Created by vision on 17/7/21.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "TCCheckListViewController.h"
#import "ImageViewController.h"

#define kBtnWidth  (kScreenWidth-50)/4

@interface TCCheckListViewController (){
    NSArray           *imageArr;
//    UIScrollView      *backGround;
}

@end

@implementation TCCheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"检查单记录";
    
    
    imageArr=self.checkListModel.image;
    
    [self initCheckListRecordView];
}



#pragma mark -- Event Response
#pragma mark 打开图片
-(void)getBigChecklistPicAction:(UITapGestureRecognizer *)sender{
    ImageViewController *imageVc = [[ImageViewController alloc] init];
    imageVc.imageArray = imageArr;
    imageVc.index = sender.view.tag;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self presentViewController:imageVc animated:NO completion:^{
        
    }];

}

#pragma mark -- Private methods
#pragma mark 初始化界面
-(void)initCheckListRecordView{
    self.view.backgroundColor=[UIColor bgColor_Gray];
    
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(10,kNavHeight+20, 150, 30)];
    titleLab.text=@"检查报告";
    titleLab.textColor=[UIColor lightGrayColor];
    titleLab.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:titleLab];
    
    for (NSInteger i=0; i<imageArr.count; i++) {
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10+(kBtnWidth+10)*i, titleLab.bottom+10, kBtnWidth, kBtnWidth)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@""]];
        imgView.userInteractionEnabled=YES;
        imgView.tag=i;
        [self.view addSubview:imgView];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getBigChecklistPicAction:)];
        [imgView addGestureRecognizer:tapGesture];
    }
    
    if (!kIsEmptyObject(self.checkListModel.remark)) {
        CGFloat labH=[self.checkListModel.remark boundingRectWithSize:CGSizeMake(kScreenWidth-40, kRootViewHeight) withTextFont:[UIFont systemFontOfSize:14]].height;
        
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, titleLab.bottom+kBtnWidth+30, kScreenWidth, labH+30)];
        bgView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UILabel *remarkLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        remarkLbl.numberOfLines=0;
        remarkLbl.textColor=[UIColor blackColor];
        remarkLbl.font=[UIFont systemFontOfSize:14];
        remarkLbl.frame=CGRectMake(20, 10, kScreenWidth-40, labH+10);
        remarkLbl.text=self.checkListModel.remark;
        [bgView addSubview:remarkLbl];
      
    }
}




@end
