//
//  TCFriendGroupNavView.m
//  TonzeCloud
//
//  Created by zhuqinlu on 2017/8/11.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCFriendGroupNavView.h"

@implementation TCFriendGroupNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kSystemColor;
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 29, 30, 30)];
        _headImg.userInteractionEnabled = YES;
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 15;
        [self addSubview:_headImg];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-150)/2, 20, 150, 44)];
        titleLab.text = @"糖友圈";
        titleLab.textColor = [UIColor whiteColor];
        titleLab.font = [UIFont boldSystemFontOfSize:18];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLab];
        
        UITapGestureRecognizer *headImgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(haadTapAction)];
        [_headImg addGestureRecognizer:headImgTap];
        
        UIButton *rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45, 22, 40, 40)];
        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setImage:[UIImage drawImageWithName:@"ic_top_publish" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        rightBtn.tag = 1001;
        [self addSubview:rightBtn];
    }
    return self;
}
- (void)buttonAction:(UIButton *)sender{
    if (self.navBtnClickBlock) {
        self.navBtnClickBlock(sender.tag);
    }
}
- (void)haadTapAction{
    if (self.navBtnClickBlock) {
        self.navBtnClickBlock(1000);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
