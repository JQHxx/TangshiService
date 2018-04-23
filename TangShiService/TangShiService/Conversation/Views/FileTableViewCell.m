//
//  FileTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "FileTableViewCell.h"

@interface FileTableViewCell (){
    UILabel  *titleLbl;
    UILabel  *detailTextLbl;
    UILabel  *contentLabel;
}

@end


@implementation FileTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:titleLbl];
        
        detailTextLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        detailTextLbl.font=[UIFont systemFontOfSize:16];
        detailTextLbl.textColor=[UIColor lightGrayColor];
        detailTextLbl.numberOfLines=0;
        detailTextLbl.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:detailTextLbl];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.font=[UIFont systemFontOfSize:16];
        contentLabel.textColor=[UIColor lightGrayColor];
        contentLabel.numberOfLines=0;
        contentLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:contentLabel];
    }
    return self;
}

-(void)fileCellDisplayWithTitle:(NSString *)title detailText:(NSString *)detailStr indexPath:(NSInteger)pathRow{
    titleLbl.text=title;
    CGFloat titleW=[title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) withTextFont:titleLbl.font].width;
    titleLbl.frame=CGRectMake(10, 7, titleW+10, 30);
    if (pathRow==6) {
        contentLabel.text=detailStr;
        if (detailStr.length>0) {
            CGSize detailSize=[detailStr boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) withTextFont:contentLabel.font];
            contentLabel.frame=CGRectMake(10, titleLbl.bottom, detailSize.width, detailSize.height+10);
        }
    } else {
        detailTextLbl.text=detailStr;
        if (detailStr.length>0) {
            CGSize detailSize=[detailStr boundingRectWithSize:CGSizeMake(kScreenWidth-titleW-20, CGFLOAT_MAX) withTextFont:detailTextLbl.font];
            detailTextLbl.frame=CGRectMake(kScreenWidth-detailSize.width-10, 7, detailSize.width, 30);
        }
    }
}


+(CGFloat)getFileCellHeightWithTitle:(NSString *)title detailText:(NSString *)detailStr{
    CGFloat strH=[detailStr boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) withTextFont:[UIFont systemFontOfSize:16]].height;
    return strH+56;
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
