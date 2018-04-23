/*!
 *  \~chinese
 *  @header EMGroupManagerDelegate.h
 *  @abstract 此协议定义了群组相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMGroupManagerDelegate.h
 *  @abstract This protocol defined the callbacks of group
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese 
 *  离开群组的原因
 *
 *  \~english
 *  The reason of user leaving the group
 */
typedef enum{
    EMGroupLeaveReasonBeRemoved = 0,    /*! \~chinese 被移除 \~english Removed by owner */
    EMGroupLeaveReasonUserLeave,        /*! \~chinese 自己主动离开 \~english User leave the group */
    EMGroupLeaveReasonDestroyed,        /*! \~chinese 群组销毁 \~english Group has been destroyed */
}EMGroupLeaveReason;

@class EMGroup;
@class EMGroupSharedFile;

/*!
 *  \~chinese
 *  群组相关的回调
 *
 *  \~english
 *  Delegate
 */
@protocol EMGroupManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  用户A邀请用户B入群,用户B接收到该回调
 *
 *  @param aGroupId    群组ID
 *  @param aInviter    邀请者
 *  @param aMessage    邀请信息
 *
 */
- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage;

/*!
 *  \~chinese
 *  用户B同意用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组实例
 *  @param aInvitee  被邀请者
 *
 */
- (void)groupInvitationDidAccept:(EMGroup *)aGroup
                         invitee:(NSString *)aInvitee;

/*!
 *  \~chinese
 *  用户B拒绝用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组
 *  @param aInvitee  被邀请者
 *  @param aReason   拒绝理由
 *
 */
- (void)groupInvitationDidDecline:(EMGroup *)aGroup
                          invitee:(NSString *)aInvitee
                           reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
 *
 *  @param aGroup    群组实例
 *  @param aInviter  邀请者
 *  @param aMessage  邀请消息
 *
 */
- (void)didJoinGroup:(EMGroup *)aGroup
             inviter:(NSString *)aInviter
             message:(NSString *)aMessage;

/*!
 *  \~chinese
 *  离开群组回调
 *
 *  @param aGroup    群组实例
 *  @param aReason   离开原因
 *
 */
- (void)didLeaveGroup:(EMGroup *)aGroup
               reason:(EMGroupLeaveReason)aReason;

/*!
 *  \~chinese
 *  群组的群主收到用户的入群申请，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     群组实例
 *  @param aUsername 申请者
 *  @param aReason    申请者的附属信息
 *
 */
- (void)joinGroupRequestDidReceive:(EMGroup *)aGroup
                              user:(NSString *)aUsername
                            reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  群主拒绝用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    群组ID
 *  @param aReason     拒绝理由
 *
 */
- (void)joinGroupRequestDidDecline:(NSString *)aGroupId
                            reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  群主同意用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   通过申请的群组
 *
 */
- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup;

/*!
 *  \~chinese
 *  群组列表发生变化
 *
 *  @param aGroupList  群组列表<EMGroup>
 *
 */
- (void)groupListDidUpdate:(NSArray *)aGroupList;


/*!
 *  \~chinese
 *  有成员被加入禁言列表
 *
 *  @param aGroup           群组
 *  @param aMutedMembers    被禁言的成员
 *  @param aMuteExpire      禁言失效时间，当前不可用
 *
 */
- (void)groupMuteListDidUpdate:(EMGroup *)aGroup
             addedMutedMembers:(NSArray *)aMutedMembers
                    muteExpire:(NSInteger)aMuteExpire;

/*!
 *  \~chinese
 *  有成员被移出禁言列表
 *
 *  @param aGroup           群组
 *  @param aMutedMembers    移出禁言列表的成员
 *
 */
- (void)groupMuteListDidUpdate:(EMGroup *)aGroup
           removedMutedMembers:(NSArray *)aMutedMembers;

/*!
 *  \~chinese
 *  有成员被加入管理员列表
 *
 *  @param aGroup    群组
 *  @param aAdmin    加入管理员列表的成员
 *
 */
- (void)groupAdminListDidUpdate:(EMGroup *)aGroup
                     addedAdmin:(NSString *)aAdmin;

/*!
 *  \~chinese
 *  有成员被移出管理员列表
 *
 *  @param aGroup    群组
 *  @param aAdmin    移出管理员列表的成员
 *
 */
- (void)groupAdminListDidUpdate:(EMGroup *)aGroup
                   removedAdmin:(NSString *)aAdmin;

/*!
 *  \~chinese
 *  群组创建者有更新
 *
 *  @param aGroup       群组
 *  @param aNewOwner    新群主
 *  @param aOldOwner    旧群主
 *
 */
- (void)groupOwnerDidUpdate:(EMGroup *)aGroup
                   newOwner:(NSString *)aNewOwner
                   oldOwner:(NSString *)aOldOwner;

/*!
 *  \~chinese
 *  有用户加入群组
 *
 *  @param aGroup       加入的群组
 *  @param aUsername    加入者
 *
 */
- (void)userDidJoinGroup:(EMGroup *)aGroup
                    user:(NSString *)aUsername;

/*!
 *  \~chinese
 *  有用户离开群组
 *
 *  @param aGroup       离开的群组
 *  @param aUsername    离开者
 *
 */
- (void)userDidLeaveGroup:(EMGroup *)aGroup
                     user:(NSString *)aUsername;

/*!
 *  \~chinese
 *  群公告有更新
 *
 *  @param aGroup           群组
 *  @param aAnnouncement    群公告
 *
 */
- (void)groupAnnouncementDidUpdate:(EMGroup *)aGroup
                      announcement:(NSString *)aAnnouncement;

/*!
 *  \~chinese
 *  有用户上传群共享文件
 *
 *  @param aGroup       群组
 *  @param aSharedFile  共享文件
 *
 */
- (void)groupFileListDidUpdate:(EMGroup *)aGroup
               addedSharedFile:(EMGroupSharedFile *)aSharedFile;

/*!
 *  \~chinese
 *  有用户删除群共享文件
 *
 *  @param aGroup       群组
 *  @param aFileId      共享文件ID
 *
 */
- (void)groupFileListDidUpdate:(EMGroup *)aGroup
             removedSharedFile:(NSString *)aFileId;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  用户A邀请用户B入群,用户B接收到该回调
 *
 *  @param aGroupId    群组ID
 *  @param aInviter    邀请者
 *  @param aMessage    邀请信息
 *
 */
- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage __deprecated_msg("Use -groupInvitationDidReceive:inviter:message:");

/*!
 *  \~chinese
 *  用户B同意用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组实例
 *  @param aInvitee  被邀请者
 *
 */
- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee __deprecated_msg("Use -groupInvitationDidAccept:invitee:");

/*!
 *  \~chinese
 *  用户B拒绝用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组
 *  @param aInvitee  被邀请者
 *  @param aReason   拒绝理由
 *
 */
- (void)didReceiveDeclinedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
                                   reason:(NSString *)aReason __deprecated_msg("Use -groupInvitationDidDecline:invitee:reason:");

/*!
 *  \~chinese
 *  SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
 *
 *  @param aGroup    群组实例
 *  @param aInviter  邀请者
 *  @param aMessage  邀请消息
 *
 */
- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage __deprecated_msg("Use -didJoinGroup:inviter:message:");

/*!
 *  \~chinese
 *  离开群组回调
 *
 *  @param aGroup    群组实例
 *  @param aReason   离开原因
 *
 */
- (void)didReceiveLeavedGroup:(EMGroup *)aGroup
                       reason:(EMGroupLeaveReason)aReason __deprecated_msg("Use -didLeaveGroup:reason:");

/*!
 *  \~chinese
 *  群组的群主收到用户的入群申请，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     群组实例
 *  @param aApplicant 申请者
 *  @param aReason    申请者的附属信息
 *
 */
- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason __deprecated_msg("Use -joinGroupRequestDidReceive:user:reason:");

/*!
 *  \~chinese
 *  群主拒绝用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    群组ID
 *  @param aReason     拒绝理由
 *
 */
- (void)didReceiveDeclinedJoinGroup:(NSString *)aGroupId
                             reason:(NSString *)aReason __deprecated_msg("Use -joinGroupRequestDidDecline:reason:");

/*!
 *  \~chinese
 *  群主同意用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   通过申请的群组
 *
 */
- (void)didReceiveAcceptedJoinGroup:(EMGroup *)aGroup __deprecated_msg("Use -joinGroupRequestDidApprove:");

/*!
 *  \~chinese
 *  群组列表发生变化
 *
 *  @param aGroupList  群组列表<EMGroup>
 *
 */
- (void)didUpdateGroupList:(NSArray *)aGroupList __deprecated_msg("Use -groupListDidUpdate:");

@end
