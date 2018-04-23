//
//  QuestionnaireViewController.h
//  TangShiService
//
//  Created by vision on 17/12/12.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "BaseViewController.h"
#import "TCQuestionnarieModel.h"

@class QuestionnaireViewController;

@protocol  QuestionnaireViewControllerDelegate<NSObject>

-(void)questionnaireViewController:(QuestionnaireViewController *)viewController didSelectQuestionnaire:(NSDictionary *)questionDict;

@end

@interface QuestionnaireViewController : BaseViewController

@property (nonatomic,assign)id<QuestionnaireViewControllerDelegate>delegate;

@property (nonatomic,assign)NSInteger userId;


@end
