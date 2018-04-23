//
//  TCBasewebViewController.h
//  TonzeCloud
//
//  Created by vision on 17/3/21.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    BaseWebViewTypeDefault         =0,    //默认
    BaseWebViewTypeArticle         =1,    //文章详情
    BaseWebViewTypeSystemNews      =2,    //系统消息
    BaseWebViewTypeNewsArticle     =3,    //消息文章
} BaseWebViewType;

typedef void(^WebViewControllerBackBlock)();

@interface TCBasewebViewController : BaseViewController

@property (nonatomic, copy )NSString   *titleText;
@property (nonatomic, copy )NSString   *urlStr;
@property (nonatomic, copy )NSString   *shareTitle;
@property (nonatomic, copy )NSString   *image_url;
@property (nonatomic,assign)NSInteger  articleID;
@property (nonatomic,assign)NSInteger  articleIndex;
@property (nonatomic,assign)BOOL       isSystemNewsIn;
@property (nonatomic,assign)BaseWebViewType   type;

//消息文章参数
@property (nonatomic,assign)NSInteger  message_id;
@property (nonatomic,assign)NSInteger  message_user_id;

@property (nonatomic,copy)WebViewControllerBackBlock backBlock;


@end
