//
//  TCQuestionnarieTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/12/15.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "TCQuestionnarieTableViewCell.h"

@interface TCQuestionnarieTableViewCell (){
    UIImageView   *myImageView;
    UILabel       *nameLabel;
    UILabel       *statusLabel;
    
    TCQuestionnarieModel *questionModel;
}

@end

@implementation TCQuestionnarieTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        myImageView=[[UIImageView alloc] initWithFrame:CGRectMake(18, 21/2, 40, 40)];
        [self.contentView addSubview:myImageView];
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(myImageView.right+10, 23, kScreenWidth-myImageView.right-80, 15)];
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, (60-15)/2, 40, 15)];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:statusLabel];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(statusLabel.right+5, (60-15)/2, 15, 15)];
        imgView.image = [UIImage imageNamed:@"pub_ic_arrow"];
        [self.contentView addSubview:imgView];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, kScreenWidth, 1)];
        line.backgroundColor = [UIColor bgColor_Gray];
        [self.contentView addSubview:line];
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-130)/2,line.bottom+12, 130, 36)];
        [sendButton setTitle:@"发送调查表" forState:UIControlStateNormal];
        [sendButton setTitleColor:kbgBtnColor forState:UIControlStateNormal];
        sendButton.layer.cornerRadius = 18;
        sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        sendButton.layer.borderColor=kbgBtnColor.CGColor;
        sendButton.layer.borderWidth=1;
        sendButton.clipsToBounds=YES;
        [sendButton addTarget:self action:@selector(sendFormButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:sendButton];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, sendButton.bottom+12, kScreenWidth, 10)];
        bgView.backgroundColor = [UIColor bgColor_Gray];
        [self.contentView addSubview:bgView];
    }
    return self;
}


-(void)setQuestionnarieModel:(TCQuestionnarieModel *)questionnarieModel{
    questionModel = questionnarieModel;
    
    [myImageView sd_setImageWithURL:[NSURL URLWithString:questionnarieModel.image_url] placeholderImage:[UIImage imageNamed:@"chat_ic_form_list"]];
    nameLabel.text = questionnarieModel.name;
    statusLabel.text = questionnarieModel.status==0?@"未填":@"已填";
    statusLabel.textColor =[UIColor colorWithHexString:questionnarieModel.status==0?@"0x626262":@"0x05d380"];
}

- (void)sendFormButton:(UIButton *)button{
    
    if ([self.questionaireDelegate respondsToSelector:@selector(didSelectQuestionnaire:)]) {
        [self.questionaireDelegate didSelectQuestionnaire:questionModel];
    }
}
@end
