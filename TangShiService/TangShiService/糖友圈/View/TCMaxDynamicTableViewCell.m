//
//  TCMaxDynamicTableViewCell.m
//  TonzeCloud
//
//  Created by 肖栋 on 17/8/12.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCMaxDynamicTableViewCell.h"
#import "TCResponseView.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@interface TCMaxDynamicTableViewCell ()<TCRespondViewDelegate>{
    
    TCResponseView  *myRespondView;
    UILabel         *contentLabel;
    UIButton        *maxDynamicButton;
    NSInteger       indexPathRow;
    NSInteger       role_type;
    NSInteger       role_type_ed;

}
@end
@implementation TCMaxDynamicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        myRespondView = [[TCResponseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
        myRespondView.delegate = self;
        [self.contentView addSubview:myRespondView];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, myRespondView.bottom, kScreenWidth-60, 0)];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        
        maxDynamicButton = [[UIButton alloc] initWithFrame:CGRectMake(contentLabel.left, contentLabel.bottom+10, 80, 34)];
        [maxDynamicButton setTitleColor:kbgBtnColor forState:UIControlStateNormal];
        maxDynamicButton.titleLabel.font = kFontWithSize(15);
        [maxDynamicButton setTitle:@"查看原动态" forState:UIControlStateNormal];
        [maxDynamicButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [maxDynamicButton  layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        maxDynamicButton.tag = 101;
        [maxDynamicButton addTarget:self action:@selector(lookAtTheOriginal) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [maxDynamicButton.titleLabel.text sizeWithLabelWidth:kScreenWidth font:[UIFont systemFontOfSize:15]];
        maxDynamicButton.frame =CGRectMake(contentLabel.left, contentLabel.bottom+10, size.width+20, 30);
        [self.contentView addSubview:maxDynamicButton];

    }
    return self;
}

- (void)cellMaxDynamicDict:(NSDictionary *)dict{
    indexPathRow = [[dict objectForKey:@"comment_user_id"] integerValue];
    role_type =[[dict objectForKey:@"role_type"] integerValue];
    role_type_ed =[[dict objectForKey:@"role_type_ed"] integerValue];

    [myRespondView myMaxReplyDict:dict];
    contentLabel.text = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:[dict objectForKey:@"content"]];
    CGSize size = [contentLabel.text sizeWithLabelWidth:kScreenWidth-65 font:[UIFont systemFontOfSize:15]];
    contentLabel.frame =CGRectMake(55, myRespondView.bottom, kScreenWidth-65, size.height);
    maxDynamicButton.frame =CGRectMake(contentLabel.left, contentLabel.bottom, 100, 34);
}

#pragma mark -- 返回文本高度
+ (CGFloat)tableView:(UITableView *)tableView rowMaxDynamicForObject:(id)object{
    NSString *contentStr=[EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:object];
    CGSize size = [contentStr sizeWithLabelWidth:kScreenWidth-65 font:[UIFont systemFontOfSize:15]];
    return size.height+10;
}
#pragma mark --TCRespondViewDelegate
- (void)respondView{

    if ([_delegate respondsToSelector:@selector(LinkUserInfoReplyContent:role_type:role_type_ed:)]) {
        [_delegate LinkUserInfoReplyContent:indexPathRow role_type:role_type role_type_ed:role_type_ed];
    }
}
#pragma mark -- 查看原动态
- (void)lookAtTheOriginal{

    if ([_delegate respondsToSelector:@selector(lookAtTheOriginalDynamic)]) {
        [_delegate lookAtTheOriginalDynamic];
    }
}
@end
