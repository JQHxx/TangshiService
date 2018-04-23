//
//  EditGroupTableViewCell.h
//  TangShiService
//
//  Created by vision on 17/7/18.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditGroupTableViewCell.h"
#import "TCGroupModel.h"

@interface EditGroupTableViewCell : UITableViewCell

-(void)editGroupViewCellDisplayWithModel:(TCGroupModel *)group;

@end
