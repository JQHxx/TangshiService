//
//  TCQuestionnarieTableViewCell.h
//  TangShiService
//
//  Created by vision on 17/12/15.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCQuestionnarieModel.h"
@protocol  QuestionnaireCellDelegate<NSObject>

-(void)didSelectQuestionnaire:(TCQuestionnarieModel *)model;

@end
@interface TCQuestionnarieTableViewCell : UITableViewCell

@property (nonatomic,assign)id<QuestionnaireCellDelegate>questionaireDelegate;

-(void)setQuestionnarieModel:(TCQuestionnarieModel *)questionnarieModel;


@end
