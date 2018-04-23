//
//  TCFoodAddTableViewCell.m
//  TonzeCloud
//
//  Created by vision on 17/3/1.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCFoodAddTableViewCell.h"

@implementation TCFoodAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)cellDisplayWithFood:(TCFoodAddModel *)foodAddModel{
    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:foodAddModel.image_url] placeholderImage:[UIImage imageNamed:@"img_bg40x40"]];
    self.foodNameLabel.text=foodAddModel.name;
    self.foodWeightLabel.text=[NSString stringWithFormat:@"%@克",foodAddModel.weight];
    
    NSInteger calorys=[foodAddModel.calory integerValue];

   
    self.foodColaryLabel.text=[NSString stringWithFormat:@"%ld千卡",(long)calorys];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
