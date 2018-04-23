//
//  TCSuagrHistoryCell.m
//  TonzeCloud
//
//  Created by vision on 17/3/2.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCSuagrHistoryCell.h"

@implementation TCSuagrHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)cellDisplayWithSugar:(TCSugarModel *)model{
    
    self.iconImageView.image=[UIImage imageNamed:[model.way integerValue]==1?@"ic_n_tang_luru":@"ic_n_tang_shebei"];
    
    NSString *period=[[TCHelper sharedTCHelper] getPeriodChNameForPeriodEn:model.time_slot];
    NSDictionary *valueDict=[[TCHelper sharedTCHelper] getNormalValueDictWithPeriodString:period];
    
    double minValue=[[valueDict valueForKey:@"min"] doubleValue];
    double maxValue=[[valueDict valueForKey:@"max"] doubleValue];
    double value=[model.glucose doubleValue];
    
    NSArray *colorItems=[NSArray arrayWithObjects:[UIColor colorWithHexString:@"#fa6f6e"],
                                                  [UIColor colorWithHexString:@"#37deba"],
                                                  [UIColor colorWithHexString:@"#ffd03e"],nil];
    NSMutableAttributedString *attributeStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1fmmol/L",value]];
    UIColor *color;
    if (value>maxValue) {
        color=colorItems[0];
    }else if (value<minValue){
        color=colorItems[2];
    }else{
        color=colorItems[1];
    }
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} range:NSMakeRange(0, attributeStr.length-6)];
    self.valueLabel.attributedText=attributeStr;
    
    NSString *timeStr= [[TCHelper sharedTCHelper] timeWithTimeIntervalString:model.measurement_time format:@"HH:mm"];
    self.periodLabel.text=[NSString stringWithFormat:@"%@ %@",period,timeStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
