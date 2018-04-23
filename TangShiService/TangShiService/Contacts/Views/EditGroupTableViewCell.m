//
//  EditGroupTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/7/18.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "EditGroupTableViewCell.h"

@interface EditGroupTableViewCell (){
    UILabel    *titleLabel;
    UIButton   *selectButton;
}

@end


@implementation EditGroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth/3*2, 20)];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleLabel];
        
        selectButton=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, (44-25)/2, 25, 25)];
        [selectButton setImage:[UIImage imageNamed:@"ic_pub_choose_nor"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"ic_pub_choose_sel"] forState:UIControlStateSelected];
        [self.contentView addSubview:selectButton];
    }
    return self;
}

-(void)editGroupViewCellDisplayWithModel:(TCGroupModel *)group{
    titleLabel.text=group.group_name;
    [selectButton setImage:[UIImage imageNamed:group.isSelected?@"ic_pub_choose_sel":@"ic_pub_choose_nor"] forState:UIControlStateNormal];
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
