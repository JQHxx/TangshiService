/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 54
#define INSETS 10
#define MOREVIEW_COL 4
#define MOREVIEW_ROW 2
#define MOREVIEW_BUTTON_TAG 1000

@implementation UIView (MoreView)

- (void)removeAllSubview
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end

@interface EaseChatBarMoreView ()
{
    EMChatToolbarType _type;
}

@property (nonatomic, strong) UIButton *photoButton;     //相册
@property (nonatomic, strong) UIButton *takePicButton;   //照相机
@property (nonatomic, strong) UIButton *questionnaireButton;  //调查表

@end

@implementation EaseChatBarMoreView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseChatBarMoreView *moreView = [self appearance];
    moreView.moreViewBackgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
}

- (instancetype)initWithFrame:(CGRect)frame type:(EMChatToolbarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = type;
        [self setupSubviewsForType:_type];
    }
    return self;
}

- (void)setupSubviewsForType:(EMChatToolbarType)type
{
    self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.accessibilityIdentifier = @"more_view";
    
    UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor=[UIColor colorWithHexString:@"#cdcdcd"];
    [self addSubview:line];
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    _photoButton = [self btnWithImage:[UIImage imageNamed:@"chat_ic_pic"] title:@"相册"];
    _photoButton.accessibilityIdentifier = @"image";
    [_photoButton setFrame:CGRectMake(insets, 24, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    _photoButton.tag = MOREVIEW_BUTTON_TAG;
    [self addSubview:_photoButton];
    
    _takePicButton = [self btnWithImage:[UIImage imageNamed:@"chat_ic_camera"] title:@"拍照"];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 24, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    _takePicButton.tag = MOREVIEW_BUTTON_TAG + 1;
    [self addSubview:_takePicButton];
    
    
    _questionnaireButton = [self btnWithImage:[UIImage imageNamed:@"chat_ic_form"] title:@"调查表"];
    [_questionnaireButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 24, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_questionnaireButton addTarget:self action:@selector(questionnaireAction) forControlEvents:UIControlEventTouchUpInside];
    _questionnaireButton.tag = MOREVIEW_BUTTON_TAG + 2;
    [self addSubview:_questionnaireButton];
    
    CGRect frame = self.frame;
    frame.size.height = 180;
    self.frame = frame;
}


- (UIButton *)btnWithImage:(UIImage *)aImage title:(NSString *)aTitle {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:aImage forState:UIControlStateNormal];
    [btn setTitle:aTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#626262"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    btn.titleEdgeInsets = UIEdgeInsetsMake(40, -CHAT_BUTTON_SIZE, -40, 0);
    return btn;
}

- (void)setMoreViewBackgroundColor:(UIColor *)moreViewBackgroundColor
{
    _moreViewBackgroundColor = moreViewBackgroundColor;
    if (_moreViewBackgroundColor) {
        [self setBackgroundColor:_moreViewBackgroundColor];
    }
}

#pragma mark - action
#pragma mark 相册
- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

#pragma mark 拍照
- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

#pragma mark 调查表
-(void)questionnaireAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewQuestionnaireAction:)]){
        [_delegate moreViewQuestionnaireAction:self];
    }
}

#pragma mark 位置
- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

#pragma mark 语音
- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

#pragma mark 视频
- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

- (void)moreAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button && _delegate && [_delegate respondsToSelector:@selector(moreView:didItemInMoreViewAtIndex:)]) {
        [_delegate moreView:self didItemInMoreViewAtIndex:button.tag-MOREVIEW_BUTTON_TAG];
    }
}

@end
