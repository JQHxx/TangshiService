/*!
 *  \~chinese
 *  @header IEMGroupManager.h
 *  @abstract 此协议定义了群组相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMGroupManager.h
 *  @abstract This protocol defines the group operations
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMGroupManagerDelegate.h"
#import "EMGroup.h"
#import "EMGroupOptions.h"
#import "EMCursorResult.h"
#import "EMGroupSharedFile.h"

/*!
 *  \~chinese
 *  群组相关操作
 *
 *  \~english
 *  Group operations
 */
@protocol IEMGroupManager <NSObject>

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
- (void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 */
- (void)removeDelegate:(id)aDelegate;


#pragma mark - Get Group

/*!
 *  \~chinese
 *  获取用户所有群组
 *
 *  @result 群组列表<EMGroup>
 *
 *  \~english
 *  Get all groups
 *
 *  @result Group list<EMGroup>
 *
 */
- (NSArray *)getJoinedGroups;

/*!
 *  \~chinese
 *  从内存中获取屏蔽了推送的群组ID列表
 *
 *  @param pError  错误信息
 *
 */
- (NSArray *)getGroupsWithoutPushNotification:(EMError **)pError;


#pragma mark - Get group from server

/*!
 *  \~chinese
 *  按数目从服务器获取自己加入的群组
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aPageNum  获取自己加入群的cursor，首次调用传空
 *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param pError    出错信息
 *
 *  @return 群组列表<EMGroup>
 *
 *
 *  @return Group list<EMGroup>
 */
- (NSArray *)getJoinedGroupsFromServerWithPage:(NSInteger)aPageNum
                                      pageSize:(NSInteger)aPageSize
                                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  按数目从服务器获取自己加入的群组
 *
 *  @param aPageNum  获取自己加入群的cursor，首次调用传空
 *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param aCompletionBlock      完成的回调
 *
 *
 */

- (void)getJoinedGroupsFromServerWithPage:(NSInteger)aPageNum
                                 pageSize:(NSInteger)aPageSize
                               completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从服务器获取指定范围内的公开群
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aCursor   获取公开群的cursor，首次调用传空
 *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param pError    出错信息
 *
 *  @return    获取的公开群结果
 *
 */
- (EMCursorResult *)getPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                               pageSize:(NSInteger)aPageSize
                                                  error:(EMError **)pError;

/*!
 *  \~chinese
 *  从服务器获取指定范围内的公开群
 *
 *  @param aCursor          获取公开群的cursor，首次调用传空
 *  @param aPageSize        期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)getPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                   pageSize:(NSInteger)aPageSize
                                 completion:(void (^)(EMCursorResult *aResult, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  根据群ID搜索公开群
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroundId   群组id
 *  @param pError      错误信息
 *
 *  @return 搜索到的群组
 *
 */
- (EMGroup *)searchPublicGroupWithId:(NSString *)aGroundId
                               error:(EMError **)pError;

/*!
 *  \~chinese
 *  根据群ID搜索公开群
 *
 *  @param aGroundId        群组id
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)searchPublicGroupWithId:(NSString *)aGroundId
                     completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - Create

/*!
 *  \~chinese
 *  创建群组
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject        群组名称
 *  @param aDescription    群组描述
 *  @param aInvitees       群组成员（不包括创建者自己）
 *  @param aMessage        邀请消息
 *  @param aSetting        群组属性
 *  @param pError          出错信息
 *
 *  @return    创建的群组
 *
 */
- (EMGroup *)createGroupWithSubject:(NSString *)aSubject
                        description:(NSString *)aDescription
                           invitees:(NSArray *)aInvitees
                            message:(NSString *)aMessage
                            setting:(EMGroupOptions *)aSetting
                              error:(EMError **)pError;

/*!
 *  \~chinese
 *  创建群组
 *
 *  @param aSubject         群组名称
 *  @param aDescription     群组描述
 *  @param aInvitees        群组成员（不包括创建者自己）
 *  @param aMessage         邀请消息
 *  @param aSetting         群组属性
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)createGroupWithSubject:(NSString *)aSubject
                   description:(NSString *)aDescription
                      invitees:(NSArray *)aInvitees
                       message:(NSString *)aMessage
                       setting:(EMGroupOptions *)aSetting
                    completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - Fetch Info

/*!
 *  \~chinese
 *  获取群组详情，包含群组ID,群组名称，群组描述，群组基本属性，群组Owner, 群组管理员
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId              群组ID
 *  @param pError                错误信息
 *
 *  @return    群组
 *
 */
- (EMGroup *)getGroupSpecificationFromServerWithId:(NSString *)aGroupId
                                             error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组详情,包含群组ID,群组名称，群组描述，群组基本属性，群组Owner, 群组管理员
 *
 *  @param aGroupId              群组ID
 *  @param aCompletionBlock      完成的回调
 *
 *
 *
 */
- (void)getGroupSpecificationFromServerWithId:(NSString *)aGroupId
                                   completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群组成员列表
 *
 *  @param aGroupId         群组ID
 *  @param aCursor          游标，，首次调用传空
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *  @return    列表和游标
 *
 *
 */
- (EMCursorResult *)getGroupMemberListFromServerWithId:(NSString *)aGroupId
                                                cursor:(NSString *)aCursor
                                              pageSize:(NSInteger)aPageSize
                                                 error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组成员列表
 *
 *  @param aGroupId         群组ID
 *  @param aCursor          游标，首次调用传空
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)getGroupMemberListFromServerWithId:(NSString *)aGroupId
                                    cursor:(NSString *)aCursor
                                  pageSize:(NSInteger)aPageSize
                                completion:(void (^)(EMCursorResult *aResult, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner/admin权限
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *
 *
 */
- (NSArray *)getGroupBlacklistFromServerWithId:(NSString *)aGroupId
                                    pageNumber:(NSInteger)aPageNum
                                      pageSize:(NSInteger)aPageSize
                                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner/admin权限
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)getGroupBlacklistFromServerWithId:(NSString *)aGroupId
                               pageNumber:(NSInteger)aPageNum
                                 pageSize:(NSInteger)aPageSize
                               completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群组被禁言列表
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *
 *
 */
- (NSArray *)getGroupMuteListFromServerWithId:(NSString *)aGroupId
                                   pageNumber:(NSInteger)aPageNum
                                     pageSize:(NSInteger)aPageSize
                                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组被禁言列表
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)getGroupMuteListFromServerWithId:(NSString *)aGroupId
                              pageNumber:(NSInteger)aPageNum
                                pageSize:(NSInteger)aPageSize
                              completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群共享文件列表
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *  @result     群共享文件列表
 *
 */
- (NSArray *)getGroupFileListWithId:(NSString *)aGroupId
                         pageNumber:(NSInteger)aPageNum
                           pageSize:(NSInteger)aPageSize
                              error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群共享文件列表
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 */
- (void)getGroupFileListWithId:(NSString *)aGroupId
                    pageNumber:(NSInteger)aPageNum
                      pageSize:(NSInteger)aPageSize
                    completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群公告
 *
 *  @param aGroupId         群组ID
 *  @param pError           错误信息
 *
 *  @result     群声明, 失败返回nil
 *
 */
- (NSString *)getGroupAnnouncementWithId:(NSString *)aGroupId
                                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群公告
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)getGroupAnnouncementWithId:(NSString *)aGroupId
                        completion:(void (^)(NSString *aAnnouncement, EMError *aError))aCompletionBlock;

#pragma mark - Edit Group

/*!
 *  \~chinese
 *  邀请用户加入群组
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants      被邀请的用户名列表
 *  @param aGroupId        群组ID
 *  @param aWelcomeMessage 欢迎信息
 *  @param pError          错误信息
 *
 *  @result    群组实例, 失败返回nil
 *
 */
- (EMGroup *)addOccupants:(NSArray *)aOccupants
                  toGroup:(NSString *)aGroupId
           welcomeMessage:(NSString *)aWelcomeMessage
                    error:(EMError **)pError;

/*!
 *  \~chinese
 *  邀请用户加入群组
 *
 *  @param aUsers           被邀请的用户名列表
 *  @param aGroupId         群组ID
 *  @param aMessage         欢迎信息
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)addMembers:(NSArray *)aUsers
           toGroup:(NSString *)aGroupId
           message:(NSString *)aMessage
        completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将群成员移出群组, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要移出群组的用户列表
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组实例
 *
 */
- (EMGroup *)removeOccupants:(NSArray *)aOccupants
                   fromGroup:(NSString *)aGroupId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  将群成员移出群组, 需要owner权限
 *
 *  @param aUsers           要移出群组的用户列表
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)removeMembers:(NSArray *)aUsers
            fromGroup:(NSString *)aGroupId
           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  加人到群组黑名单, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要加入黑名单的用户
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组实例
 *
 */
- (EMGroup *)blockOccupants:(NSArray *)aOccupants
                  fromGroup:(NSString *)aGroupId
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  加人到群组黑名单, 需要owner权限
 *
 *  @param aMembers         要加入黑名单的用户
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)blockMembers:(NSArray *)aMembers
           fromGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  从群组黑名单中减人, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要从黑名单中移除的用户名列表
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组对象
 
 */
- (EMGroup *)unblockOccupants:(NSArray *)aOccupants
                     forGroup:(NSString *)aGroupId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  从群组黑名单中减人, 需要owner权限
 *
 *  @param aMembers         要从黑名单中移除的用户名列表
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)unblockMembers:(NSArray *)aMembers
             fromGroup:(NSString *)aGroupId
            completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更改群组主题, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject  新主题
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @result    群组对象
 *
 */
- (EMGroup *)changeGroupSubject:(NSString *)aSubject
                       forGroup:(NSString *)aGroupId
                          error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改群组主题, 需要owner权限
 *
 *  @param aSubject         新主题
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)updateGroupSubject:(NSString *)aSubject
                  forGroup:(NSString *)aGroupId
                completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更改群组说明信息, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aDescription 说明信息
 *  @param aGroupId     群组ID
 *  @param pError       错误信息
 *
 *  @result    群组对象
 *
 */
- (EMGroup *)changeDescription:(NSString *)aDescription
                      forGroup:(NSString *)aGroupId
                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改群组说明信息, 需要owner权限
 *
 *  @param aDescription     说明信息
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)updateDescription:(NSString *)aDescription
                 forGroup:(NSString *)aGroupId
               completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  退出群组，owner不能退出群，只能销毁群
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *
 *
 */
- (void)leaveGroup:(NSString *)aGroupId
             error:(EMError **)pError;

/*!
 *  \~chinese
 *  退出群组，owner不能退出群，只能销毁群
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)leaveGroup:(NSString *)aGroupId
        completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *
 *  @result    错误信息, 成功返回nil
 *
 */
- (EMError *)destroyGroup:(NSString *)aGroupId;

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)destroyGroup:(NSString *)aGroupId
    finishCompletion:(void (^)(EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   要屏蔽的群ID
 *  @param pError     错误信息
 *
 *  @result           群组实例
 *
 */
- (EMGroup *)blockGroup:(NSString *)aGroupId
                  error:(EMError **)pError;

/*!
 *  \~chinese
 *  屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
 *
 *  @param aGroupId         要屏蔽的群ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)blockGroup:(NSString *)aGroupId
        completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  取消屏蔽群消息
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   要取消屏蔽的群ID
 *  @param pError     错误信息
 *
 *  @result    返回群组实例
 *
 */
- (EMGroup *)unblockGroup:(NSString *)aGroupId
                    error:(EMError **)pError;

/*!
 *  \~chinese
 *  取消屏蔽群消息
 *
 *  @param aGroupId         要取消屏蔽的群ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)unblockGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  改变群主，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   群ID
 *  @param aNewOwner  新群主
 *  @param pError     错误信息
 *
 *  @result    返回群组实例
 *
 */
- (EMGroup *)updateGroupOwner:(NSString *)aGroupId
                     newOwner:(NSString *)aNewOwner
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  改变群主，需要Owner权限
 *
 *  @param aGroupId   群ID
 *  @param aNewOwner  新群主
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)updateGroupOwner:(NSString *)aGroupId
                newOwner:(NSString *)aNewOwner
              completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  添加群组管理员，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aAdmin     要添加的群组管理员
 *  @param aGroupId   群ID
 *  @param pError     错误信息
 *  @result           返回群组实例
 *
 */
- (EMGroup *)addAdmin:(NSString *)aAdmin
              toGroup:(NSString *)aGroupId
                error:(EMError **)pError;

/*!
 *  \~chinese
 *  添加群组管理员，需要Owner权限
 *
 *  @param aAdmin     要添加的群组管理员
 *  @param aGroupId   群ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)addAdmin:(NSString *)aAdmin
         toGroup:(NSString *)aGroupId
      completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  移除群组管理员，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aAdmin     要移除的群组管理员
 *  @param aGroupId   群ID
 *  @param pError     错误信息
 *
 *  @result    返回群组实例
 *
 */
- (EMGroup *)removeAdmin:(NSString *)aAdmin
               fromGroup:(NSString *)aGroupId
                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  移除群组管理员，需要Owner权限
 *
 *  @param aAdmin     要移除的群组管理员
 *  @param aGroupId   群ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)removeAdmin:(NSString *)aAdmin
          fromGroup:(NSString *)aGroupId
         completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  将一组成员禁言，需要Owner / Admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMuteMembers         要禁言的成员列表<NSString>
 *  @param aMuteMilliseconds    禁言时长
 *  @param aGroupId             群ID
 *  @param pError               错误信息
 *
 *  @result    返回群组实例
 *
 */
- (EMGroup *)muteMembers:(NSArray *)aMuteMembers
        muteMilliseconds:(NSInteger)aMuteMilliseconds
               fromGroup:(NSString *)aGroupId
                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  将一组成员禁言，需要Owner / Admin权限
 *
 *  @param aMuteMembers         要禁言的成员列表<NSString>
 *  @param aMuteMilliseconds    禁言时长
 *  @param aGroupId             群ID
 *  @param aCompletionBlock     完成的回调
 *
 *
 */
- (void)muteMembers:(NSArray *)aMuteMembers
   muteMilliseconds:(NSInteger)aMuteMilliseconds
          fromGroup:(NSString *)aGroupId
         completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  解除禁言，需要Owner / Admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMuteMembers     被解除的列表<NSString>
 *  @param aGroupId         群ID
 *  @param pError           错误信息
 *
 *  @result    返回群组实例
 *
 */
- (EMGroup *)unmuteMembers:(NSArray *)aMembers
                 fromGroup:(NSString *)aGroupId
                     error:(EMError **)pError;

/*!
 *  \~chinese
 *  解除禁言，需要Owner / Admin权限
 *
 *  @param aMuteMembers     被解除的列表<NSString>
 *  @param aGroupId         群ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)unmuteMembers:(NSArray *)aMembers
            fromGroup:(NSString *)aGroupId
           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  上传群共享文件
 *
 *  @param aGroupId         群ID
 *  @param aFilePath        文件路径
 *  @param pError           错误信息
 *
 *  @result    群实例
 *
 */
- (void)uploadGroupSharedFileWithId:(NSString *)aGroupId
                           filePath:(NSString*)aFilePath
                           progress:(void (^)(int progress))aProgressBlock
                         completion:(void (^)(EMGroupSharedFile *aSharedFile, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  下载群共享文件
 *
 *  @param aGroupId         群ID
 *  @param aFilePath        文件路径
 *  @param aSharedFileId    共享文件ID
 *  @param aProgressBlock   文件下载进度回调block
 *  @param aCompletionBlock 完成回调block
 *
 */
- (void)downloadGroupSharedFileWithId:(NSString *)aGroupId
                             filePath:(NSString *)aFilePath
                         sharedFileId:(NSString *)aSharedFileId
                             progress:(void (^)(int progress))aProgressBlock
                           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  删除群共享文件
 *
 *  @param aGroupId         群ID
 *  @param aSharedFileId    共享文件ID
 *  @param pError           错误信息
 *
 *  @result    群实例
 *
 */
- (EMGroup *)removeGroupSharedFileWithId:(NSString *)aGroupId
                            sharedFileId:(NSString *)aSharedFileId
                                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  删除群共享文件
 *
 *  @param aGroupId         群ID
 *  @param aSharedFileId    共享文件ID
 *  @param aCompletionBlock 完成的回调
 *
 */
- (void)removeGroupSharedFileWithId:(NSString *)aGroupId
                       sharedFileId:(NSString *)aSharedFileId
                         completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  修改群公告，需要Owner / Admin权限
 *
 *  @param aGroupId         群ID
 *  @param aAnnouncement    群公告
 *  @param pError           错误信息
 *
 *  @result    群实例
 *
 */
- (EMGroup *)updateGroupAnnouncementWithId:(NSString *)aGroupId
                              announcement:(NSString *)aAnnouncement
                                     error:(EMError **)pError;

/*!
 *  \~chinese
 *  修改群公告，需要Owner / Admin权限
 *
 *  @param aGroupId         群ID
 *  @param aAnnouncement    群公告
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)updateGroupAnnouncementWithId:(NSString *)aGroupId
                         announcement:(NSString *)aAnnouncement
                           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  修改群扩展信息，需要Owner权限
 *
 *  @param aGroupId         群ID
 *  @param aExt             扩展信息
 *  @param pError           错误信息
 *
 *  @result    群实例
 *
 */
- (EMGroup *)updateGroupExtWithId:(NSString *)aGroupId
                              ext:(NSString *)aExt
                            error:(EMError **)pError;

/*!
 *  \~chinese
 *  修改群扩展信息，需要Owner权限
 *
 *  @param aGroupId         群ID
 *  @param aExt             扩展信息
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)updateGroupExtWithId:(NSString *)aGroupId
                         ext:(NSString *)aExt
                  completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - Edit Public Group

/*!
 *  \~chinese
 *  加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId 公开群组的ID
 *  @param pError   错误信息
 *
 *  @result    所加入的公开群组
 *
 */
- (EMGroup *)joinPublicGroup:(NSString *)aGroupId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         公开群组的ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)joinPublicGroup:(NSString *)aGroupId
             completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId    公开群组的ID
 *  @param aMessage    请求加入的信息
 *  @param pError      错误信息
 *
 *  @result    申请加入的公开群组
 *
 */
- (EMGroup *)applyJoinPublicGroup:(NSString *)aGroupId
                          message:(NSString *)aMessage
                            error:(EMError **)pError;

/*!
 *  \~chinese
 *  申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         公开群组的ID
 *  @param aMessage         请求加入的信息
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)requestToJoinPublicGroup:(NSString *)aGroupId
                         message:(NSString *)aMessage
                      completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - Application

/*!
 *  \~chinese
 *  批准入群申请, 需要Owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   所申请的群组ID
 *  @param aUsername  申请人
 *
 *  @result 错误信息
 *
 */
- (EMError *)acceptJoinApplication:(NSString *)aGroupId
                         applicant:(NSString *)aUsername;

/*!
 *  \~chinese
 *  批准入群申请, 需要Owner权限
 *
 *  @param aGroupId         所申请的群组ID
 *  @param aUsername        申请人
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)approveJoinGroupRequest:(NSString *)aGroupId
                         sender:(NSString *)aUsername
                     completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  拒绝入群申请, 需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  被拒绝的群组ID
 *  @param aUsername 申请人
 *  @param aReason   拒绝理由
 *
 *  @result 错误信息
 *
 */
- (EMError *)declineJoinApplication:(NSString *)aGroupId
                          applicant:(NSString *)aUsername
                             reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  拒绝入群申请, 需要Owner权限
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aUsername        申请人
 *  @param aReason          拒绝理由
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)declineJoinGroupRequest:(NSString *)aGroupId
                         sender:(NSString *)aUsername
                         reason:(NSString *)aReason
                     completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  接受入群邀请
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param groupId     接受的群组ID
 *  @param aUsername   邀请者
 *  @param pError      错误信息
 *
 *  @result 接受的群组实例
 *
 */
- (EMGroup *)acceptInvitationFromGroup:(NSString *)aGroupId
                               inviter:(NSString *)aUsername
                                 error:(EMError **)pError;

/*!
 *  \~chinese
 *  接受入群邀请
 *
 *  @param groupId          接受的群组ID
 *  @param aUsername        邀请者
 *  @param pError           错误信息
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)acceptInvitationFromGroup:(NSString *)aGroupId
                          inviter:(NSString *)aUsername
                       completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  拒绝入群邀请
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  被拒绝的群组ID
 *  @param aUsername 邀请人
 *  @param aReason   拒绝理由
 *
 *  @result 错误信息
 *
 */
- (EMError *)declineInvitationFromGroup:(NSString *)aGroupId
                                inviter:(NSString *)aUsername
                                 reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  拒绝入群邀请
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aInviter         邀请人
 *  @param aReason          拒绝理由
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)declineGroupInvitation:(NSString *)aGroupId
                       inviter:(NSString *)aInviter
                        reason:(NSString *)aReason
                    completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - Apns

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId    群组ID
 *  @param aIgnore     是否屏蔽
 *
 *  @result 错误信息
 *
 */
- (EMError *)ignoreGroupPush:(NSString *)aGroupId
                      ignore:(BOOL)aIsIgnore;


/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupIDs   群组ID列表
 *  @param aIgnore     是否屏蔽
 *
 *  @result 错误信息
 *
 */
- (EMError *)ignoreGroupsPush:(NSArray *)aGroupIDs
                       ignore:(BOOL)aIsIgnore;

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  @param aGroupId          群组ID
 *  @param aIsEnable         是否允许推送
 *  @param aCompletionBlock  完成的回调
 *
 *
 *
 */
- (void)updatePushServiceForGroup:(NSString *)aGroupId
                    isPushEnabled:(BOOL)aIsEnable
                       completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  @param aGroupIDs         群组ID列表
 *  @param aIsEnable         是否允许推送
 *  @param aCompletionBlock  完成的回调
 *
 *
 */
- (void)updatePushServiceForGroups:(NSArray *)aGroupIDs
                     isPushEnabled:(BOOL)aIsEnable
                        completion:(void (^)(NSArray *groups, EMError *aError))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.3.0

/**
 *  \~chinese
 *  从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError  错误信息
 *
 *  @return 群组列表<EMGroup>
 *
 */
- (NSArray *)getMyGroupsFromServerWithError:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getJoinedGroupsFromServerWithPage:pageSize:error:]");

/**
 *  \~chinese
 *  从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
 *
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)getJoinedGroupsFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getJoinedGroupsFromServerWithPage:pageSize:completion:]");

/*!
 *  \~chinese
 *  获取群组详情
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId              群组ID
 *  @param aIncludeMembersList   是否获取成员列表，为YES时，返回200个成员
 *  @param pError                错误信息
 *
 *  @return    群组
 *
 */
- (EMGroup *)fetchGroupInfo:(NSString *)aGroupId
         includeMembersList:(BOOL)aIncludeMembersList
                      error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getGroupSpecificationFromServerWithId:error:]");

/*!
 *  \~chinese
 *  获取群组详情
 *
 *  @param aGroupId              群组ID
 *  @param aIncludeMembersList   是否获取成员列表，为YES时，返回200个成员
 *  @param aCompletionBlock      完成的回调
 *
 *
 *
 */
- (void)getGroupSpecificationFromServerByID:(NSString *)aGroupID
                         includeMembersList:(BOOL)aIncludeMembersList
                                 completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getGroupSpecificationFromServerWithId:completion:]");

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @return    群组黑名单列表<NSString>
 *
 */
- (NSArray *)fetchGroupBansList:(NSString *)aGroupId
                          error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getGroupBlacklistFromServerWithId:pageNumber:pageSize:error:]");

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *
 */
- (void)getGroupBlackListFromServerByID:(NSString *)aGroupId
                             completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getGroupBlacklistFromServerWithId:pageNumber:pageSize:completion:]");

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @result    销毁的群组实例, 失败返回nil
 *
 */
- (EMGroup *)destroyGroup:(NSString *)aGroupId
                    error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager destroyGroup:]");

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)destroyGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup* aGroup, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager destroyGroup:finishCompletion:]");

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
- (void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMGroupManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  获取所有群组，如果内存中不存在，则先从DB加载
 *
 *  @result 群组列表<EMGroup>
 *
 *  \~english
 *  Get all groups, will load from DB if not exist in memory
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)getAllGroups __deprecated_msg("Use -getJoinedGroups");

/*!
 *  \~chinese
 *  从数据库加载所有群组，加载后更新内存中的群组列表
 *
 *  @result 群组列表<EMGroup>
 *
 *  \~english
 *  Load all groups from DB, will update group list in memory after loading
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)loadAllMyGroupsFromDB __deprecated_msg("Use -getJoinedGroups");

/*!
 *  \~chinese
 *  从内存中获取屏蔽了推送的群组ID列表
 *
 *  @result 群组ID列表<NSString>
 *
 *  \~english
 *  Get ID list of groups which block push from memory
 *
 *  @result Group id list<NSString>
 */
- (NSArray *)getAllIgnoredGroupIds __deprecated_msg("Use -getGroupsWithoutPushNotification");

/**
 *  \~chinese
 *  从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncGetMyGroupsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getJoinedGroupsFromServerWithCompletion:");

/*!
 *  \~chinese
 *  从服务器获取指定范围内的公开群
 *
 *  @param aCursor          获取公开群的cursor，首次调用传空
 *  @param aPageSize        期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncGetPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                        pageSize:(NSInteger)aPageSize
                                         success:(void (^)(EMCursorResult *aCursor))aSuccessBlock
                                         failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getPublicGroupsFromServerWithCursor:pageSize:completion:");

/*!
 *  \~chinese
 *  根据群ID搜索公开群
 *
 *  @param aGroundId        群组id
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncSearchPublicGroupWithId:(NSString *)aGroundId
                             success:(void (^)(EMGroup *aGroup))aSuccessBlock
                             failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -searchPublicGroupWithId:completion:");

/*!
 *  \~chinese
 *  创建群组
 *
 *  @param aSubject         群组名称
 *  @param aDescription     群组描述
 *  @param aInvitees        群组成员（不包括创建者自己）
 *  @param aMessage         邀请消息
 *  @param aSetting         群组属性
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 *
 *
 */
- (void)asyncCreateGroupWithSubject:(NSString *)aSubject
                        description:(NSString *)aDescription
                           invitees:(NSArray *)aInvitees
                            message:(NSString *)aMessage
                            setting:(EMGroupOptions *)aSetting
                            success:(void (^)(EMGroup *aGroup))aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -createGroupWithSubject:description:invitees:message:setting:completion");

/*!
 *  \~chinese
 *  获取群组详情
 *
 *  @param aGroupId              群组ID
 *  @param aIncludeMembersList   是否获取成员列表
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *
 */
- (void)asyncFetchGroupInfo:(NSString *)aGroupId
         includeMembersList:(BOOL)aIncludeMembersList
                    success:(void (^)(EMGroup *aGroup))aSuccessBlock
                    failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getGroupSpecificationFromServerByID:includeMembersList:completion:");

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 */
- (void)asyncFetchGroupBansList:(NSString *)aGroupId
                        success:(void (^)(NSArray *aList))aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock  __deprecated_msg("Use -getGroupBlackListFromServerByID:completion:");

/*!
 *  \~chinese
 *  邀请用户加入群组
 *
 *  @param aOccupants       被邀请的用户名列表
 *  @param aGroupId         群组ID
 *  @param aWelcomeMessage  欢迎信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncAddOccupants:(NSArray *)aOccupants
                  toGroup:(NSString *)aGroupId
           welcomeMessage:(NSString *)aWelcomeMessage
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addMembers:toGroup:message:completion:");

/*!
 *  \~chinese
 *  将群成员移出群组, 需要owner权限
 *
 *  @param aOccupants       要移出群组的用户列表
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncRemoveOccupants:(NSArray *)aOccupants
                   fromGroup:(NSString *)aGroupId
                     success:(void (^)(EMGroup *aGroup))aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -removeMembers:fromGroup:completion:");

/*!
 *  \~chinese
 *  加人到群组黑名单, 需要owner权限
 *
 *  @param aOccupants       要加入黑名单的用户
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncBlockOccupants:(NSArray *)aOccupants
                  fromGroup:(NSString *)aGroupId
                    success:(void (^)(EMGroup *aGroup))aSuccessBlock
                    failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -blockMembers:fromGroup:completion:");

/*!
 *  \~chinese
 *  从群组黑名单中减人, 需要owner权限
 *
 *  @param aOccupants       要从黑名单中移除的用户名列表
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncUnblockOccupants:(NSArray *)aOccupants
                     forGroup:(NSString *)aGroupId
                      success:(void (^)(EMGroup *aGroup))aSuccessBlock
                      failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -unblockMembers:fromGroup:completion:");

/*!
 *  \~chinese
 *  更改群组主题, 需要owner权限
 *
 *  @param aSubject         新主题
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncChangeGroupSubject:(NSString *)aSubject
                       forGroup:(NSString *)aGroupId
                        success:(void (^)(EMGroup *aGroup))aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updateGroupSubject:forGroup:completion");

/*!
 *  \~chinese
 *  更改群组说明信息, 需要owner权限
 *
 *  @param aDescription     说明信息
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncChangeDescription:(NSString *)aDescription
                      forGroup:(NSString *)aGroupId
                       success:(void (^)(EMGroup *aGroup))aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updateDescription:forGroup:completion");

/*!
 *  \~chinese
 *  退出群组，owner不能退出群，只能销毁群
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncLeaveGroup:(NSString *)aGroupId
                success:(void (^)(EMGroup *aGroup))aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -leaveGroup:completion");

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncDestroyGroup:(NSString *)aGroupId
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -destroyGroup:completion");

/*!
 *  \~chinese
 *  屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
 *
 *  @param aGroupId         要屏蔽的群ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncBlockGroup:(NSString *)aGroupId
                success:(void (^)(EMGroup *aGroup))aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -blockGroup:completion:");

/*!
 *  \~chinese
 *  取消屏蔽群消息
 *
 *  @param aGroupId         要取消屏蔽的群ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncUnblockGroup:(NSString *)aGroupId
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -unblockGroup:completion");

/*!
 *  \~chinese
 *  加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         公开群组的ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncJoinPublicGroup:(NSString *)aGroupId
                     success:(void (^)(EMGroup *aGroup))aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -joinPublicGroup:completion");

/*!
 *  \~chinese
 *  申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         公开群组的ID
 *  @param aMessage         请求加入的信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncApplyJoinPublicGroup:(NSString *)aGroupId
                          message:(NSString *)aMessage
                          success:(void (^)(EMGroup *aGroup))aSuccessBlock
                          failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -requestToJoinPublicGroup:message:completion:");

/*!
 *  \~chinese
 *  批准入群申请, 需要Owner权限
 *
 *  @param aGroupId         所申请的群组ID
 *  @param aUsername        申请人
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncAcceptJoinApplication:(NSString *)aGroupId
                         applicant:(NSString *)aUsername
                           success:(void (^)())aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -approveJoinGroupRequest:sender:completion:");

/*!
 *  \~chinese
 *  拒绝入群申请, 需要Owner权限
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aUsername        申请人
 *  @param aReason          拒绝理由
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *
 */
- (void)asyncDeclineJoinApplication:(NSString *)aGroupId
                          applicant:(NSString *)aUsername
                             reason:(NSString *)aReason
                            success:(void (^)())aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineJoinGroupRequest:sender:reason:completion:");

/*!
 *  \~chinese
 *  接受入群邀请
 *
 *  @param groupId          接受的群组ID
 *  @param aUsername        邀请者
 *  @param pError           错误信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncAcceptInvitationFromGroup:(NSString *)aGroupId
                               inviter:(NSString *)aUsername
                               success:(void (^)(EMGroup *aGroup))aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -acceptInvitationFromGroup:inviter:completion");

/*!
 *  \~chinese
 *  拒绝入群邀请
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aUsername        邀请人
 *  @param aReason          拒绝理由
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 */
- (void)asyncDeclineInvitationFromGroup:(NSString *)aGroupId
                                inviter:(NSString *)aUsername
                                 reason:(NSString *)aReason
                                success:(void (^)())aSuccessBlock
                                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineGroupInvitation:inviter:reason:completion:");

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  @param aGroupId          群组ID
 *  @param aIgnore           是否屏蔽
 *  @param aSuccessBlock     成功的回调
 *  @param aFailureBlock     失败的回调
 *
 *
 *
 */
- (void)asyncIgnoreGroupPush:(NSString *)aGroupId
                      ignore:(BOOL)aIsIgnore
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updatePushServiceForGroup:isPushEnabled:completion:");

@end
