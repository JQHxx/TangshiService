//
//  Interface.h
//  TangShiService
//
//  Created by vision on 17/5/25.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#ifndef Interface_h
#define Interface_h


#endif /* Interface_h */

/*
 测试帐号
 测试环境
 专家账号：jingege（13723787053）
 专家密码：123456
 
 助手
 账号：13631288826
 密码：123456
 
 正式环境
 专家账号：13928460864
 专家密码：bhh864
 
 
 【正式环境的测试专家号】
 
 郑雄
 13631288826
 123456
 
 杨蓝
 13049079790
 123456
 
 李丹
 13005344588
 123456
 
 健康小助手
 13762220707
 tjy20170731
 
 */

/********************** app环境 ****************************/
#pragma mark - app环境，0开发或1发布

#define isTrueEnvironment 1

#if isTrueEnvironment

#define kHostURL             @"http://api.360tj.com/%@"                             //正式
#define kWebUrl              @"http://ht.360tj.com:8081/article/article.html"
#define kNewsWebUrl          @"http://ht.360tj.com:8081/System/system.html"

#else

//#define kHostURL           @"http://172.16.0.108/%@"                       //程荣禄（测试）
//#define kHostURL           @"http://172.16.0.78/%@"                        //叶剑武（测试）
#define kHostURL             @"http://api-ts-t.360tj.com/%@"                 //测试
#define kWebUrl              @"http://wm-ts-t.360tj.com/article/article.html"
#define kNewsWebUrl          @"http://wm-ts-t.360tj.com/System/system.html"

#endif


/***************************app接口*****************************/
#define kGetTokenAPI            @"expert/getToken"                         //刷新用户凭证
#define kLoginAPI               @"expert/login"                            //登录
#define kExpertInfo             @"expert/getInfo"                          //获取专家信息

#define kGetUserServices        @"expert/getServices"                      //获取用户的服务信息
#define kGetUsers               @"expert/getUsers"                         //获取患者列表
#define kGetUserDetail          @"expert/getUserHome"                      //获取用户基本信息
#define kGetUserInfo            @"expert/getUserInfo"                      //获取服务用户基本信息
#define kGetUserBloodFile       @"expert/getUserHealth"                    //获取用户糖档案
#define kSugarRecordLists       @"expert/patient_service/bloodSugar"       //获取血糖数据
#define kGetSugarUsers          @"expert/count_glucose/lists"              //偏高偏低患者列表
#define kRecordHistory          @"expert/patient_service/history"          //血糖记录列表\饮食记录列表\运动记录列表
#define kBloodPressureHistory   @"expert/history_record/bloodPressure"     //血压历史记录
#define kGlycosylatedHistory    @"expert/history_record/glycosylated"      //糖化血红蛋白历史记录
#define kExaminationHistory     @"expert/history_record/examination"       //检查单历史记录
#define kGetMyServiceOrders     @"expert/patient_service/myServiceOrder"   //获取我的服务订单列表
#define kGetMyServiceDetail     @"expert/patient_service/serviceDetail"    //获取我的服务订单详情

//聊天管理
#define kAddChatMessage           @"webapp/Groupchat/add"                        //保存聊天记录
#define kChatMessageList          @"webapp/Groupchat/lists"                      //获取聊天记录
//调查表
#define kResearchList             @"expert/Research/lists"                       //调查表列表
#define kResearchDetail           @"expert/Research/detail"                      //调查表详情

/********文章管理*********/
#define kColumnList            @"webapp/special_column/lists"                     //专栏列表
#define kColumnDtailList       @"webapp/special_column/read"                      //专栏详情
#define kArticleCategory       @"webapp/Articleclassificationindex/lists"         //文章分类
#define kArticleList           @"webapp/Articlemanagementindex/lists"             //文章列表
#define kRecommandArticleList  @"webapp/Articlemanagementindex/recArticle"        //推荐文章列表
#define kMyCommentList         @"webapp/articlemanagementindex/commentLists"      //我评论的列表
#define kCommentMineList       @"webapp/articlemanagementindex/commentedLists"    //评论我的列表

/******分组管理******/
#define kGetUsersGroup          @"expert/group/lists"                      //获取用户分组列表
#define kAddUserGroup           @"expert/group/add"                        //新建分组
#define kChangeUserGroup        @"expert/group/changeGroup"                //改变分组
#define kDeleteUserGroup        @"expert/group/delete"                     //删除分组
#define kUpadateGroupName       @"expert/group/update"                     //更改分组名
#define kChangeGroupSort        @"expert/group/changeSort"                 //更改分组排序
#define kSetRemarkName          @"expert/group/setRemark"                  //设置备注名称

/*********系统消息*******/
#define kGetExpertMessage       @"expert/Expertmessageindex/getExpertMessageIndex"     //专家系统消息
#define kGetMessageList         @"expert/Expertmessageindex/lists"                     //系统消息列表
#define kDeleteMessage          @"expert/Expertmessageindex/delete"                    //删除系统消息

#define kExpertLoginOut         @"expert/loginOut"               //退出登录
#define kAddFeedBack            @"webapp/Feedbackindex/add"      //意见反馈
#define kChangePassWord         @"expert/modifyPwd"              //修改密码

//糖友圈
#define KLoadFoucsOnList        @"friend/Newsattindex/follow_lists"                // 获取关注人列表
#define KLoadotherFoucsOnList   @"friend/Newsattindex/other_follow_lists"          // 获取其他人关注人列表
#define KLoadBeFoucsOnList      @"friend/Newsattindex/followed_lists"              // 获取被关注人列表
#define KLoadotherBeFoucsOnList @"friend/Newsattindex/other_followed_lists"        // 获取被其他人关注人列表
#define KLoadNewFriendList      @"friend/Newsattindex/new_followed_lists"          // 获取新好友列表
#define KLoadDynamicDetail      @"friend/dynamics/read"                            // 获取动态详情
#define KLoadPraiseList         @"friend/dynamics/praiseList"                      // 获取动态点赞列表
#define KLoadCommentsList       @"friend/dynamics/commentList"                     // 获取动态评论列表
#define KReleaseDynamic         @"friend/dynamics/release"                         // 发布动态
#define KLoadMyCommentsList     @"friend/Newsattindex/comment_lists"               // 获取我的评论列表
#define KLoadCommentsMyList     @"friend/Newsattindex/commented_lists"             // 获取评论我的列表
#define KLoadAtedList           @"friend/Newsattindex/ated_lists"                  // 获取@我的列表
#define KLoadMySugarFriendInfo  @"friend/Newsattindex/info_index"                  // 获取我的糖友圈首页
#define KfriendGroupList        @"friend/lists/list"                               // 获取糖友圈动态
#define KDynamicDoComment       @"friend/dynamics/doComment"                       // 评论动态／回复评论
#define KDynamicDoLike          @"friend/dynamics/doLike"                          // 点赞动态／评论
#define KDynamicMoreComment     @"friend/dynamics/moreComment"                     // 获取更多回复
#define kFocusFriend            @"friend/dynamics/focus"                           // 关注／取消关注
#define kLoadLikeList           @"friend/Newsattindex/like_lists"                  // 我赞的列表
#define kLoadLikedList          @"friend/Newsattindex/liked_lists"                 // 赞我的列表
#define kattr_setUpdate         @"friend/Newsattindex/attr_set"                    // 提醒查看／更新
#define KLoadFriendUserInfo     @"friend/user/info"                                // 获取糖友圈个人信息
#define KDynamicDelete          @"friend/dynamics/delete"                          // 动态删除
#define KCommentsDelete         @"friend/dynamics/deleteComment"                   // 评论删除
#define KTopicLists             @"friend/topic/lists"                              // 话题列表
#define KTopicDetail            @"friend/topic/detail"                             // 话题详情
#define KSugarFriendSerarch     @"friend/friend_search/lists"                      // 糖友圈搜索
#define KSearchMoreFriend       @"friend/friend_search/moreFriends"                // 更多好友
#define KUserGagRemind          @"webapp/gag/lists"                                // 禁言提醒
#define kHotKeyword             @"webapp/Hotkeywordindex/read"                     //搜索热门关键词
#define KRankLists              @"friend/dynamics/rankLists"                       // 排行榜
#define KFriendHotKeyWords      @"friend/friend_search/hotKeyWords"                // 糖友圈热门关键字

#define KFeedbackLists          @"webapp/Feedbackindex/lists"                       // 意见反馈列表
#define KFeedbackDetail         @"webapp/Feedbackindex/info"                        // 意见反馈详情
#define KFeedbackNewMessage     @"webapp/Feedbackindex/redPoint"                    // 反馈红点


