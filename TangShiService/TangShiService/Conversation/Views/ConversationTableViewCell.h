//
//  ConversationTableViewCell.h
//  TangShiService
//
//  Created by vision on 17/5/31.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationModel.h"
#import "TCSystemNewsModel.h"

@interface ConversationTableViewCell : UITableViewCell


-(void)conversationCellDisplayWithModel:(id )model type:(NSInteger)type;

@end
