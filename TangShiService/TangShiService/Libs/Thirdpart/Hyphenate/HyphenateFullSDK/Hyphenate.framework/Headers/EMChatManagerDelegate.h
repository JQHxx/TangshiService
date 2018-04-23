/*!
 *  \~chinese
 *  @header EMChatManagerDelegate.h
 *  @abstract 此协议定义了聊天相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMChatManagerDelegate.h
 *  @abstract This protocol defines chat related callbacks
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

@class EMMessage;
@class EMError;

/*!
 *  \~chinese
 *  聊天相关回调
 *
 *  \~english
 *  Chat related callbacks
 */
@protocol EMChatManagerDelegate <NSObject>

@optional

#pragma mark - Conversation

/*!
 *  \~chinese
 *  会话列表发生变化
 *
 *  @param aConversationList  会话列表<EMConversation>
 *
 *  \~english
 *  Delegate method will be invoked when the conversation list has changed
 *
 */
- (void)conversationListDidUpdate:(NSArray *)aConversationList;

#pragma mark - Message

/*!
 *  \~chinese
 *  收到消息
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  \~english
 *  Invoked when receiving new messages
 *
 */
- (void)messagesDidReceive:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到Cmd消息
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 *
 *  \~english
 *  Invoked when receiving command messages
 *
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages;

/*!
 *  \~chinese
 *  收到已读回执
 *
 *  @param aMessages  已读消息列表<EMMessage>
 *
 *  \~english
 *  Invoked when receiving read acknowledgement in message list
 *
 */
- (void)messagesDidRead:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到消息送达回执
 *
 *  @param aMessages  送达消息列表<EMMessage>
 *
 *  \~english
 *  Invoked when receiving delivered acknowledgement in message list
 *
 */
- (void)messagesDidDeliver:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到消息撤回
 *
 *  @param aMessages  撤回消息列表<EMMessage>
 *
 *  \~english
 * Delegate method will be invoked when receiving recall for message list
 *
 */
- (void)messagesDidRecall:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  消息状态发生变化
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 *
 *  \~english
 *  Invoked when message status has changed
 *
 */
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError;

/*!
 *  \~chinese
 *  消息附件状态发生改变
 *
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 *
 *  \~english
 *  Invoked when message attachment status has changed
 *
 */
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  会话列表发生变化
 *
 *  @param aConversationList  会话列表<EMConversation>
 *
 *  \~english
 *  The conversation list has changed
 *
 */
- (void)didUpdateConversationList:(NSArray *)aConversationList __deprecated_msg("Use -conversationListDidUpdate:");

/*!
 *  \~chinese
 *  收到消息
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  \~english
 *  Received messages
 *
 */
- (void)didReceiveMessages:(NSArray *)aMessages __deprecated_msg("Use -messagesDidReceive:");

/*!
 *  \~chinese
 *  收到Cmd消息
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 *
 *  \~english
 *  Received cmd messages
 *
 */
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages __deprecated_msg("Use -cmdMessagesDidReceive:");

/*!
 *  \~chinese
 *  收到已读回执
 *
 *  @param aMessages  已读消息列表<EMMessage>
 *
 *  \~english
 *  Received read acks
 *
 */
- (void)didReceiveHasReadAcks:(NSArray *)aMessages __deprecated_msg("Use -messagesDidRead:");

/*!
 *  \~chinese
 *  收到消息送达回执
 *
 *  @param aMessages  送达消息列表<EMMessage>
 *
 *  \~english
 *  Received deliver acks
 *
 */
- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages __deprecated_msg("Use -messagesDidDeliver:");

/*!
 *  \~chinese
 *  消息状态发生变化
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 *
 *  \~english
 *  Message status has changed
 *

 */
- (void)didMessageStatusChanged:(EMMessage *)aMessage
                          error:(EMError *)aError __deprecated_msg("Use -messageStatusDidChange:error");

/*!
 *  \~chinese
 *  消息附件状态发生改变
 *  
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 *
 *  \~english
 *  Attachment status has changed
 *
 */
- (void)didMessageAttachmentsStatusChanged:(EMMessage *)aMessage
                                     error:(EMError *)aError __deprecated_msg("Use -messageAttachmentStatusDidChange:error");
@end
