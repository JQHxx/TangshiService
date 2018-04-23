//
//  ContactTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/5/27.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ContactTableViewCell.h"

@interface ContactTableViewCell (){
    UIImageView   *imgView;
    UILabel       *nameLbl;
    UIImageView   *sexImageView;
    UILabel       *ageLbl;
    UILabel       *linelbl;
    UILabel       *bloodLbl;
    
    UILabel       *numLab;
}

@end

@implementation ContactTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        imgView.layer.cornerRadius=30;
        imgView.clipsToBounds=YES;
        [self.contentView addSubview:imgView];
        
        nameLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        nameLbl.font=[UIFont systemFontOfSize:15];
        nameLbl.textColor=[UIColor blackColor];
        [self.contentView addSubview:nameLbl];
        
        sexImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:sexImageView];
        
        ageLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        ageLbl.font=[UIFont systemFontOfSize:14];
        ageLbl.text=@"100岁";
        ageLbl.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:ageLbl];
        
        linelbl=[[UILabel alloc] initWithFrame:CGRectZero];
        linelbl.backgroundColor=kLineColor;
        [self.contentView addSubview:linelbl];
        
        bloodLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        bloodLbl.font=[UIFont systemFontOfSize:14];
        bloodLbl.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:bloodLbl];
        
        numLab=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, 25, 70, 30)];
        numLab.font=[UIFont systemFontOfSize:14];
        numLab.textAlignment=NSTextAlignmentRight;
        numLab.textColor=[UIColor blackColor];
        [self.contentView addSubview:numLab];
        numLab.hidden=YES;
        
    }
    return self;
}


-(void)contactCellDisplayWithModel:(UserModel *)model{
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"ic_m_head"]];
    
    //昵称
    nameLbl.text=kIsEmptyString(model.remark)?model.nick_name:model.remark;
    CGFloat nameW=[nameLbl.text boundingRectWithSize:CGSizeMake(kScreenWidth-imgView.right-50, 30) withTextFont:nameLbl.font].width;
    nameW=nameW<20.0?20.0:nameW;
    nameLbl.frame=CGRectMake(imgView.right+10, 10, nameW, 30);
    
    //性别
    if (model.sex<1||model.sex>2) {
        sexImageView.hidden=YES;
    }else{
        sexImageView.hidden=NO;
        sexImageView.image=[UIImage imageNamed:model.sex==1?@"ic_m_male":@"ic_m_famale"];
        sexImageView.frame=CGRectMake(nameLbl.right, 10, 30, 30);
    }
    
    //年龄
    NSString *birthdayStr=[[TCHelper sharedTCHelper] timeWithTimeIntervalString:model.birthday format:@"yyyy-MM-dd"];
    if (!kIsEmptyString(birthdayStr)&&[birthdayStr isEqualToString:@"1970-01-01"]) {
        ageLbl.text=@"--";
    }else{
        NSString *ageStr=[[TCHelper sharedTCHelper] dateToOldForTimeSp:model.birthday format:@"yyyy-MM-dd"];
        ageLbl.text=[NSString stringWithFormat:@"%@岁",ageStr];
    }

    CGFloat ageW=[ageLbl.text boundingRectWithSize:CGSizeMake(kScreenWidth-imgView.right-50, 30) withTextFont:ageLbl.font].width;
    ageLbl.frame=CGRectMake(imgView.right+10, nameLbl.bottom, ageW, 30);
    
    linelbl.frame=CGRectMake(ageLbl.right+5, nameLbl.bottom+10, 1, 10);
    
    //糖尿病类型
    bloodLbl.text=kIsEmptyString(model.diabetes_type)?@"未知类型":model.diabetes_type;
    CGFloat bloodW=[bloodLbl.text boundingRectWithSize:CGSizeMake(kScreenWidth-ageLbl.right-10, 30) withTextFont:bloodLbl.font].width;
    bloodLbl.frame=CGRectMake(ageLbl.right+10, nameLbl.bottom, bloodW, 30);
    
    if (model.num>0) {
        numLab.hidden=NO;
        NSString *str=[NSString stringWithFormat:@"%ld次",(long)model.num];
        CGFloat numW=[str boundingRectWithSize:CGSizeMake(kScreenWidth-imgView.right-60, 30) withTextFont:numLab.font].width;
        numLab.frame=CGRectMake(kScreenWidth-numW-10, 25, numW, 30);
        numLab.text=str;
    }else{
        numLab.hidden=YES;
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
