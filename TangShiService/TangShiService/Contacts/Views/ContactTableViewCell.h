//
//  ContactTableViewCell.h
//  TangShiService
//
//  Created by vision on 17/5/27.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGroupModel.h"

@interface ContactTableViewCell : UITableViewCell

-(void)contactCellDisplayWithModel:(UserModel *)model;

@end
