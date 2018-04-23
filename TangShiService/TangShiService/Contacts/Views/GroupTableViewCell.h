//
//  GroupTableViewCell.h
//  TangShiService
//
//  Created by vision on 17/7/12.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetGroupNameCallback)(NSString *name);

@interface GroupTableViewCell : UITableViewCell<UITextFieldDelegate>

// 组名
@property (nonatomic ,strong) UITextField *nameTextField;
/// 删除按钮
@property (nonatomic ,strong) UIButton *deleteBtn;

@property (nonatomic,  copy ) SetGroupNameCallback setGroupCallback;



@end
