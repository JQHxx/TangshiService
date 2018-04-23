//
//  ContactToolView.h
//  TangShiService
//
//  Created by vision on 17/7/11.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactToolViewDelegate <NSObject>

-(void)contactToolViewDidSelectIndex:(NSInteger)index;

@end

@interface ContactToolView : UIView

@property(nonatomic,assign)id<ContactToolViewDelegate>toolDelegate;

@end
