//
//  TCCommentArticleCell.h
//  TonzeCloud
//
//  Created by vision on 17/10/13.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCommentArticleModel.h"

@protocol TCCommentArticleCellDelegate <NSObject>

//跳转的用户的个人主页
-(void)pushIntoPersonalVCWithIsSelf:(BOOL)isSelf userId:(NSInteger)user_id;
//跳转到文章详情
-(void)pushIntoArticelDetailsVCWithArticleInfo:(NSDictionary *)info;

@end


@interface TCCommentArticleCell : UITableViewCell

@property (nonatomic,assign)id<TCCommentArticleCellDelegate>cellDelegate;

-(void)commentArticleCellDisplayWithModel:(TCCommentArticleModel *)model;

+(CGFloat)getCommentArticleCellHeightWithModel:(TCCommentArticleModel *)model;

@end
