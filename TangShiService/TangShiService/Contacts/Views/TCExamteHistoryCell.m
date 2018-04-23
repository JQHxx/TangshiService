//
//  TCExamteHistoryCell.m
//  TonzeCloud
//
//  Created by 肖栋 on 17/7/16.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCExamteHistoryCell.h"

@implementation TCExamteHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)cellExamteHsitoryModel:(TCExaminationModel *)model{

    for (int i=0; i<model.image.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+50*i, 10, 40, 40)];
        NSString *imageName = model.image[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@""]];
        [self addSubview:imgView];
    }
    
    _timeLabel.text = [[TCHelper sharedTCHelper] timeWithTimeIntervalString:model.add_time format:@"HH:mm"];
}

@end
