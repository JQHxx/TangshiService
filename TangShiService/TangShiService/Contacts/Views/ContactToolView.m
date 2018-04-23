//
//  ContactToolView.m
//  TangShiService
//
//  Created by vision on 17/7/11.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ContactToolView.h"
#import "TCToolButton.h"

@interface ContactToolView (){
    
    
    
}

@end

@implementation ContactToolView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        CGFloat btnW=frame.size.width/3.0;
        NSArray *sugarArr=@[@{@"title":@"偏高患者",@"image":@"fz_ic_m_high"},@{@"title":@"偏低患者",@"image":@"fz_ic_m_low"},@{@"title":@"分组管理",@"image":@"fz_ic_m_fz"}];
        for (NSInteger i=0; i<sugarArr.count; i++) {
            NSDictionary *dict=sugarArr[i];
            TCToolButton *btn=[[TCToolButton alloc] initWithFrame:CGRectMake(btnW*i, 5, btnW, frame.size.height-10) dict:dict bgColor:[UIColor clearColor]];
            btn.tag=i;
            [btn addTarget:self action:@selector(clickActionForToolBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

-(void)clickActionForToolBtn:(UIButton *)sender{
    if ([_toolDelegate respondsToSelector:@selector(contactToolViewDidSelectIndex:)]) {
        [_toolDelegate contactToolViewDidSelectIndex:sender.tag];
    }
}

@end
