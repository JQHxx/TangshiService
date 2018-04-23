/*!
 *  \~chinese
 *  @header IEMChatroomManager.h
 *  @abstract 此协议定义了聊天室相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatroomManager.h
 *  @abstract This protocol defines the chat room operations
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMChatroomManagerDelegate.h"
#import "EMChatroomOptions.h"
#import "EMChatroom.h"
#import "EMPageResult.h"

#import "EMCursorResult.h"

@class EMError;

/*!
 *  \~chinese
 *  聊天室相关操作
 *
 *  \~english
 *  Chatroom operations
 */
@protocol IEMChatroomManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     添加回调代理
 *
 */
- (void)addDelegate:(id<EMChatroomManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 */
- (void)removeDelegate:(id<EMChatroomManagerDelegate>)aDelegate;

#pragma mark - Fetch Chatrooms

/*!
 *  \~chinese
 *  从服务器获取指定数目的聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           出错信息
 *
 *  @return 聊天室列表<EMChatroom>
 *
 */
- (EMPageResult *)getChatroomsFromServerWithPage:(NSInteger)aPageNum
                                        pageSize:(NSInteger)aPageSize
                                           error:(EMError **)pError;

/*!
 *  \~chinese
 *  从服务器获取指定数目的聊天室
 *
 *  @param aPageNum             获取第几页
 *  @param aPageSize            获取多少条
 *  @param aCompletionBlock      完成的回调
 *
 *
 */

- (void)getChatroomsFromServerWithPage:(NSInteger)aPageNum
                              pageSize:(NSInteger)aPageSize
                            completion:(void (^)(EMPageResult *aResult, EMError *aError))aCompletionBlock;

#pragma mark - Create

/*!
 *  \~chinese
 *  创建聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject             名称
 *  @param aDescription         描述
 *  @param aInvitees            成员（不包括创建者自己）
 *  @param aMessage             邀请消息
 *  @param aMaxMembersCount     群组最大成员数
 *  @param pError               出错信息
 *
 *  @return    创建的聊天室
 *
 */
- (EMChatroom *)createChatroomWithSubject:(NSString *)aSubject
                           description:(NSString *)aDescription
                              invitees:(NSArray *)aInvitees
                               message:(NSString *)aMessage
                          maxMembersCount:(NSInteger)aMaxMembersCount
                                 error:(EMError **)pError;

/*!
 *  \~chinese
 *  创建群组
 *
 *  @param aSubject                 群组名称
 *  @param aDescription             群组描述
 *  @param aInvitees                群组成员（不包括创建者自己）
 *  @param aMessage                 邀请消息
 *  @param aMaxMembersCount         群组最大成员数
 *  @param aCompletionBlock         完成的回调
 *
 *
 *
 */
- (void)createChatroomWithSubject:(NSString *)aSubject
                      description:(NSString *)aDescription
                         invitees:(NSArray *)aInvitees
                          message:(NSString *)aMessage
                  maxMembersCount:(NSInteger)aMaxMembersCount
                       completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

#pragma mark - Edit Chatroom

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室的ID
 *  @param pError       返回的错误信息
 *
 *  @result 所加入的聊天室
 */
- (EMChatroom *)joinChatroom:(NSString *)aChatroomId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  @param aChatroomId      聊天室的ID
 *  @param aCompletionBlock      完成的回调
 *
 *
 *
 */
- (void)joinChatroom:(NSString *)aChatroomId
          completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *
 */
- (void)leaveChatroom:(NSString *)aChatroomId
                error:(EMError **)pError;

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  @param aChatroomId          聊天室ID
 *  @param aCompletionBlock      完成的回调
 *
 *
 */
- (void)leaveChatroom:(NSString *)aChatroomId
           completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  解散聊天室, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室ID
 *
 *  @result    错误信息, 成功返回nil
 *
 */
- (EMError *)destroyChatroom:(NSString *)aChatroomId;

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)destroyChatroom:(NSString *)aChatroomId
             completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - Fetch

/*!
 *  \~chinese
 *  获取聊天室详情
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId           聊天室ID
 *  @param pError                错误信息
 *
 *  @return    聊天室
 *
 */
- (EMChatroom *)getChatroomSpecificationFromServerWithId:(NSString *)aChatroomId
                                                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  @param aChatroomId           聊天室ID
 *  @param aCompletionBlock      完成的回调
 *
 *
 */
- (void)getChatroomSpecificationFromServerWithId:(NSString *)aChatroomId
                                      completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取聊天室成员列表
 *
 *  @param aChatroomId      聊天室ID
 *  @param aCursor          游标，首次调用传空
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *  @return    列表和游标
 *
 *
 */
- (EMCursorResult *)getChatroomMemberListFromServerWithId:(NSString *)aChatroomId
                                                   cursor:(NSString *)aCursor
                                                 pageSize:(NSInteger)aPageSize
                                                    error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室成员列表
 *
 *  @param aChatroomId      聊天室ID
 *  @param aCursor          游标，首次调用传空
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)getChatroomMemberListFromServerWithId:(NSString *)aChatroomId
                                       cursor:(NSString *)aCursor
                                     pageSize:(NSInteger)aPageSize
                                   completion:(void (^)(EMCursorResult *aResult, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取聊天室黑名单列表, 需要owner/admin权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *
 *
 */
- (NSArray *)getChatroomBlacklistFromServerWithId:(NSString *)aChatroomId
                                       pageNumber:(NSInteger)aPageNum
                                         pageSize:(NSInteger)aPageSize
                                            error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室黑名单列表, 需要owner/admin权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)getChatroomBlacklistFromServerWithId:(NSString *)aChatroomId
                                  pageNumber:(NSInteger)aPageNum
                                    pageSize:(NSInteger)aPageSize
                                  completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取聊天室被禁言列表
 *
 *  @param aChatroomId      聊天室ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *
 *
 */
- (NSArray *)getChatroomMuteListFromServerWithId:(NSString *)aChatroomId
                                      pageNumber:(NSInteger)aPageNum
                                        pageSize:(NSInteger)aPageSize
                                           error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室被禁言列表
 *
 *  @param aChatroomId      聊天室ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)getChatroomMuteListFromServerWithId:(NSString *)aChatroomId
                                 pageNumber:(NSInteger)aPageNum
                                   pageSize:(NSInteger)aPageSize
                                 completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取聊天室公告
 *
 *  @param aChatroomId      聊天室ID
 *  @param pError           错误信息
 *
 *  @return    聊天室公告
 *
 */
- (NSString *)getChatroomAnnouncementWithId:(NSString *)aChatroomId
                                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室公告
 *
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)getChatroomAnnouncementWithId:(NSString *)aChatroomId
                           completion:(void (^)(NSString *aAnnouncement, EMError *aError))aCompletionBlock;

#pragma mark - Edit

/*!
 *  \~chinese
 *  更改聊天室主题, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject     新主题
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室对象
 *
 */
- (EMChatroom *)updateSubject:(NSString *)aSubject
                  forChatroom:(NSString *)aChatroomId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改聊天室主题, 需要owner权限
 *
 *  @param aSubject         新主题
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)updateSubject:(NSString *)aSubject
          forChatroom:(NSString *)aChatroomId
           completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更改聊天室说明信息, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aDescription 说明信息
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室对象
 *
 */
- (EMChatroom *)updateDescription:(NSString *)aDescription
                      forChatroom:(NSString *)aChatroomId
                            error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改聊天室说明信息, 需要owner权限
 *
 *  @param aDescription     说明信息
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)updateDescription:(NSString *)aDescription
              forChatroom:(NSString *)aChatroomId
               completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将成员移出聊天室, 需要owner/admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMembers     要移出的用户列表
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 */
- (EMChatroom *)removeMembers:(NSArray *)aMembers
                 fromChatroom:(NSString *)aChatroomId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  将成员移出聊天室, 需要owner/admin权限
 *
 *  @param aMembers         要移出的用户列表
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)removeMembers:(NSArray *)aMembers
         fromChatroom:(NSString *)aChatroomId
           completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  加人到聊天室黑名单, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMembers     要加入黑名单的用户
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 */
- (EMChatroom *)blockMembers:(NSArray *)aMembers
                fromChatroom:(NSString *)aChatroomId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  加人到聊天室黑名单, 需要owner权限
 *
 *  @param aMembers         要加入黑名单的用户
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)blockMembers:(NSArray *)aMembers
        fromChatroom:(NSString *)aChatroomId
          completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  从聊天室黑名单中减人, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMembers     要从黑名单中移除的用户名列表
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室对象
 *
 */
- (EMChatroom *)unblockMembers:(NSArray *)aMembers
                  fromChatroom:(NSString *)aChatroomId
                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  从聊天室黑名单中减人, 需要owner权限
 *
 *  @param aMembers         要从黑名单中移除的用户名列表
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)unblockMembers:(NSArray *)aMembers
          fromChatroom:(NSString *)aChatroomId
            completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  改变聊天室创建者，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室ID
 *  @param aNewOwner    新Owner
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 */
- (EMChatroom *)updateChatroomOwner:(NSString *)aChatroomId
                           newOwner:(NSString *)aNewOwner
                              error:(EMError **)pError;

/*!
 *  \~chinese
 *  改变聊天室创建者，需要Owner权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aNewOwner        新Owner
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)updateChatroomOwner:(NSString *)aChatroomId
                   newOwner:(NSString *)aNewOwner
                 completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  添加聊天室管理员，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aAdmin       要添加的管理员
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 */
- (EMChatroom *)addAdmin:(NSString *)aAdmin
              toChatroom:(NSString *)aChatroomId
                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  添加聊天室管理员，需要Owner权限
 *
 *  @param aAdmin           要添加的群组管理员
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)addAdmin:(NSString *)aAdmin
      toChatroom:(NSString *)aChatroomId
      completion:(void (^)(EMChatroom *aChatroomp, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  移除聊天室管理员，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aAdmin       要移除的群组管理员
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 */
- (EMChatroom *)removeAdmin:(NSString *)aAdmin
               fromChatroom:(NSString *)aChatroomId
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  移除聊天室管理员，需要Owner权限
 *
 *  @param aAdmin           要添加的群组管理员
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)removeAdmin:(NSString *)aAdmin
       fromChatroom:(NSString *)aChatroomId
         completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  将一组成员禁言，需要Owner / Admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMuteMembers         要禁言的成员列表<NSString>
 *  @param aMuteMilliseconds    禁言时长
 *  @param aChatroomId          聊天室ID
 *  @param pError               错误信息
 *
 *  @result    聊天室实例
 *
 */
- (EMChatroom *)muteMembers:(NSArray *)aMuteMembers
           muteMilliseconds:(NSInteger)aMuteMilliseconds
               fromChatroom:(NSString *)aChatroomId
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  将一组成员禁言，需要Owner / Admin权限
 *
 *  @param aMuteMembers         要禁言的成员列表<NSString>
 *  @param aMuteMilliseconds    禁言时长
 *  @param aChatroomId          聊天室ID
 *  @param aCompletionBlock     完成的回调
 *
 *
 */
- (void)muteMembers:(NSArray *)aMuteMembers
   muteMilliseconds:(NSInteger)aMuteMilliseconds
       fromChatroom:(NSString *)aChatroomId
         completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  解除禁言，需要Owner / Admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMuteMembers     被解除的列表<NSString>
 *  @param aChatroomId      聊天室ID
 *  @param pError           错误信息
 *
 *  @result    聊天室实例
 *
 */
- (EMChatroom *)unmuteMembers:(NSArray *)aMembers
                 fromChatroom:(NSString *)aChatroomId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  解除禁言，需要Owner / Admin权限
 *
 *  @param aMuteMembers     被解除的列表<NSString>
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)unmuteMembers:(NSArray *)aMembers
         fromChatroom:(NSString *)aChatroomId
           completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  修改聊天室公告，需要Owner / Admin权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aAnnouncement    群公告
 *  @param pError           错误信息
 *
 *  @result    聊天室实例
 *
 */
- (EMChatroom *)updateChatroomAnnouncementWithId:(NSString *)aChatroomId
                                    announcement:(NSString *)aAnnouncement
                                           error:(EMError **)pError;

/*!
 *  \~chinese
 *  修改聊天室公告，需要Owner / Admin权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aAnnouncement    群公告
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)updateChatroomAnnouncementWithId:(NSString *)aChatroomId
                            announcement:(NSString *)aAnnouncement
                              completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.3.0

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId           聊天室ID
 *  @param aIncludeMembersList   是否获取成员列表，为YES时，返回200个成员
 *  @param pError                错误信息
 *
 *  @return    聊天室
 *
 */
- (EMChatroom *)fetchChatroomInfo:(NSString *)aChatroomId
               includeMembersList:(BOOL)aIncludeMembersList
                            error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMChatroomManager getChatroomSpecificationFromServerWithId:error:]");

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  @param aChatroomId           聊天室ID
 *  @param aIncludeMembersList   是否获取成员列表，为YES时，返回200个成员
 *  @param aCompletionBlock      完成的回调
 *
 *
 */
- (void)getChatroomSpecificationFromServerByID:(NSString *)aChatroomId
                            includeMembersList:(BOOL)aIncludeMembersList
                                    completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMChatroomManager getChatroomSpecificationFromServerWithId:completion:]");

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)addDelegate:(id<EMChatroomManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMChatroomManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError   出错信息
 *
 *  @return 聊天室列表<EMChatroom>
 *
 */
- (NSArray *)getAllChatroomsFromServerWithError:(EMError **)pError __deprecated_msg("Use -getChatroomsFromServerWithPage");

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  @param aCompletionBlock      完成的回调
 *
 *
 */
- (void)getAllChatroomsFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock __deprecated_msg("Use -getChatroomsFromServerWithPage");

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *
 */
- (void)asyncGetAllChatroomsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getAllChatroomsFromServerWithCompletion:");

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  @param aChatroomId      聊天室的ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncJoinChatroom:(NSString *)aChatroomId
                  success:(void (^)(EMChatroom *aRoom))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -joinChatroom:completion:");

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  @param aChatroomId          聊天室ID
 *  @param aSuccessBlock        成功的回调
 *  @param aFailureBlock        失败的回调
 *
 *  @result 退出的聊天室
 *

 */
- (void)asyncLeaveChatroom:(NSString *)aChatroomId
                   success:(void (^)(EMChatroom *aRoom))aSuccessBlock
                   failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -leaveChatroom:completion:");

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  @param aChatroomId           聊天室ID
 *  @param aIncludeMembersList   是否获取成员列表
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *
 */
- (void)asyncFetchChatroomInfo:(NSString *)aChatroomId
            includeMembersList:(BOOL)aIncludeMembersList
                       success:(void (^)(EMChatroom *aChatroom))aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getChatroomSpecificationFromServerByID:includeMembersList:completion:");
@end
