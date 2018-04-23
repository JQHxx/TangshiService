//
//  ContactHeaderView.m
//  TangShiService
//
//  Created by vision on 17/7/11.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ContactHeaderView.h"


@interface ContactHeaderView ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation ContactHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brand_expand"]];
        self.arrowImageView.frame = CGRectMake(kScreenWidth-25, (44 - 8) / 2, 15,8);
        [self.contentView addSubview:self.arrowImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onExpand:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, kScreenWidth, 44);
        [self.contentView addSubview:button];
    }
    return self;
}

-(void)setSectionModel:(TCGroupModel *)sectionModel{
    _sectionModel=sectionModel;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@（%ld）",sectionModel.group_name,(long)sectionModel.count];
    if (sectionModel.isExpanded) {
        self.arrowImageView.transform = CGAffineTransformIdentity;
    } else {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
}


- (void)onExpand:(UIButton *)sender {
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.sectionModel.isExpanded) {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        } else {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
    }];
    
    if (self.sectionModel.count>0) {
        if (self.expandCallback) {
            self.expandCallback(self.sectionModel.isExpanded);
        }
    }
}

@end
