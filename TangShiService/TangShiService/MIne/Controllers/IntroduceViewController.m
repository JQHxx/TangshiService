//
//  IntroduceViewController.m
//  Product
//
//  Created by vision on 16/12/29.
//  Copyright © 2016年 TianJi. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController (){
    UIScrollView     *rootScrollView;
}

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle=@"公司简介";
    self.view.backgroundColor=[UIColor whiteColor];

    NSString *content=@"创立于2016年\n深圳天际云科技有限公司是由广东天际电器股份有限公司（股票代码：002759）全资控股的子公司。\n主营业务\n专注于互联网／物联网领域的技术开发及技术服务，为慢性病人群和关注健康的人群，提供一体化健康解决方案。是一家智能厨房、健康食疗、健康体疗为一体的整体方案提供商。\n产品特点\n天际云平台基于用户身体健康数据采集，通过专业的分析，为用户提供针对性的营养健康改善方案，同时便捷的提供给用户食材、食材包、烹饪器具选择，个性化烹饪定制、后期效果评定和改善方案，并为您构建系统性闭环生态链，保障用户身体、身心健康。\n发展优势\n依托于总公司天际电器在小家电领域的品牌知名度和制造业优势，结合天际云以健康为核心，以平台为依托，以产品为支撑，以服务为引导，创建和整合以健康为核心的产业集群，致力打造专业的健康食疗和健康体疗服务系统提供商平台品牌。";
    
    rootScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight)];
    [self.view addSubview:rootScrollView];

    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-250)/2, 20, 250, 140)];
    imgView.image=[UIImage imageNamed:@"公司logo"];
    [rootScrollView addSubview:imgView];
    
    UILabel *contentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.font=[UIFont systemFontOfSize:14];
    contentLabel.numberOfLines=0;
    
    NSMutableParagraphStyle *paraStyle=[[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment=NSTextAlignmentLeft;
    paraStyle.headIndent=0.0f;
    CGFloat emptylen=contentLabel.font.pointSize*2;
    paraStyle.firstLineHeadIndent=emptylen; //首行缩进
    paraStyle.lineSpacing=2.0f;//行间距
    
    NSAttributedString *attrText=[[NSAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName:paraStyle}];
    contentLabel.attributedText=attrText;
    
    CGFloat contentHeight=[contentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentLabel.font,NSFontAttributeName,nil] context:nil].size.height;
    
    contentLabel.frame=CGRectMake(20, imgView.bottom, kScreenWidth-40, contentHeight+100);
    [rootScrollView addSubview:contentLabel];
    
    rootScrollView.contentSize=CGSizeMake(kScreenWidth, contentLabel.bottom+20);
    
}





@end
