//
//  QuestionnarieDetailTableViewCell.m
//  TangShiService
//
//  Created by 肖栋 on 17/12/15.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "QuestionnarieDetailTableViewCell.h"

@interface QuestionnarieDetailTableViewCell (){

    UILabel *titleLabel;
    UILabel *contentLabel;
    UIView  *bgView;
}
@end

@implementation QuestionnarieDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textColor = [UIColor colorWithHexString:@"0x626262"];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 48)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        [self.contentView addSubview:bgView];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+10, 14, kScreenWidth/2, 20)];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.textColor = [UIColor colorWithHexString:@"0x626262"];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
    }
    return self;
}
- (void)questionnarieDetailData:(NSDictionary *)dict indexPath:(NSInteger)row section:(NSInteger)section{
    NSInteger type =[[dict objectForKey:@"type"] integerValue];
    if (type==1||type==2) {
        titleLabel.hidden = NO;
        contentLabel.hidden = YES;
        bgView.hidden = YES;
        
        NSArray *dataArr = [dict objectForKey:@"option"];
        NSMutableArray *dictArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in dataArr) {
            NSInteger val = [[dict objectForKey:@"val"] integerValue];
            if (val==1) {
                [dictArr addObject:dict];
            }
        }
        NSDictionary *dataDict =dictArr[row];
        titleLabel.text = [dataDict objectForKey:@"key"];
        CGSize size = [titleLabel.text sizeWithLabelWidth:kScreenWidth-60 font:[UIFont systemFontOfSize:16]];
        titleLabel.frame =CGRectMake(20, 14, size.width, size.height);
        

    } else if(type==3){
        titleLabel.hidden = YES;
        contentLabel.hidden =NO;
        bgView.hidden = NO;

        NSString *contentStr =[[dict objectForKey:@"option"][0] objectForKey:@"val"];
        contentLabel.text = contentStr.length>0?contentStr:@"未填";
        CGSize size = [contentLabel.text sizeWithLabelWidth:kScreenWidth-50 font:[UIFont systemFontOfSize:15]];
        contentLabel.frame =CGRectMake(20+10, 14, size.width, size.height);
        bgView.frame = CGRectMake(20, 0, kScreenWidth-40, size.height+28);

    }else if(type==4){
        if (row%2==0) {
            titleLabel.hidden = NO;
            contentLabel.hidden =YES;
            bgView.hidden = YES;

            NSArray *dataArr = [dict objectForKey:@"option"];
            NSDictionary *dataDict =dataArr[row/2];
            titleLabel.text = [dataDict objectForKey:@"key"];
            titleLabel.frame = CGRectMake(20, 14, kScreenWidth-40, 20);
        } else {
            titleLabel.hidden = YES;
            contentLabel.hidden =NO;
            bgView.hidden = NO;

            NSArray *dataArr = [dict objectForKey:@"option"];
            NSDictionary *dataDict =dataArr[row/2];
            NSString *contentStr = [dataDict objectForKey:@"val"];
            contentLabel.text = contentStr.length>0?contentStr:@"未填";
            CGSize size = [contentLabel.text sizeWithLabelWidth:kScreenWidth-50 font:[UIFont systemFontOfSize:15]];
            contentLabel.frame =CGRectMake(20+10, 14, size.width, size.height);
            bgView.frame = CGRectMake(20, 0, kScreenWidth-40, size.height+28);
        }
    }else if(type==5){
        titleLabel.hidden = YES;
        contentLabel.hidden =NO;
        bgView.hidden = NO;

        NSString *contentStr =[[dict objectForKey:@"option"][0] objectForKey:@"val"];
        contentLabel.text =contentStr.length>0?contentStr:@"未填";
        CGSize size = [contentLabel.text sizeWithLabelWidth:kScreenWidth-50 font:[UIFont systemFontOfSize:15]];
        contentLabel.frame =CGRectMake(20+10, 14, size.width, size.height);
        bgView.frame = CGRectMake(20, 0, kScreenWidth-40, size.height+28);
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
