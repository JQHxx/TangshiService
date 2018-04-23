//
//  FileTableViewCell.h
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTableViewCell : UITableViewCell


-(void)fileCellDisplayWithTitle:(NSString *)title detailText:(NSString *)detailStr indexPath:(NSInteger)pathRow;


+(CGFloat)getFileCellHeightWithTitle:(NSString *)title detailText:(NSString *)detailStr;


@end
