//
//  TCDietHistoryCell.m
//  TonzeCloud
//
//  Created by vision on 17/3/2.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCDietHistoryCell.h"

@implementation TCDietHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)cellDisplayWithModel:(TCFoodRecordModel *)diet{
    NSString *dietTime=[[TCHelper sharedTCHelper] getDietPeriodChNameWithPeriod:diet.time_slot];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"dietTime" ofType:@"plist"];
    NSDictionary *dict=[[NSDictionary alloc] initWithContentsOfFile:path];
    self.dietImageView.image=[UIImage imageNamed:dict[diet.time_slot]];
    self.dietTimeLabel.text=dietTime;
    
    NSMutableAttributedString *attributeStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld千卡",(long)diet.calorie]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:kRGBColor(244, 182, 123) range:NSMakeRange(0, attributeStr.length-2)];
    self.caloryLabel.attributedText=attributeStr;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
