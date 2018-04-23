//
//  ContactHeaderView.h
//  TangShiService
//
//  Created by vision on 17/7/11.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGroupModel.h"



typedef void(^ContactHeaderViewExpandCallback)(BOOL isExpanded);

@interface ContactHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) TCGroupModel *sectionModel;
@property (nonatomic,  copy ) ContactHeaderViewExpandCallback expandCallback;

@end
