//
//  TCQuestionnarieModel.h
//  TangShiService
//
//  Created by vision on 17/12/13.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCQuestionnarieModel : NSObject

@property (nonatomic,assign)NSInteger rs_id;
@property (nonatomic, copy )NSString  *image_url;
@property (nonatomic, copy )NSString  *name;
@property (nonatomic,assign)NSInteger status;    //是否填写 1是 ，0否

@end
