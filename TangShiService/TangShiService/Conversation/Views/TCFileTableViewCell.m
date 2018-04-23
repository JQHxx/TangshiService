//
//  TCFileTableViewCell.m
//  TonzeCloud
//
//  Created by 肖栋 on 18/4/10.
//  Copyright © 2018年 tonze. All rights reserved.
//

#import "TCFileTableViewCell.h"

@interface TCFileTableViewCell (){

    CGFloat btnw;
    CGFloat btnh;
}
@end
@implementation TCFileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        btnw = kScreenWidth;
        btnh = 48;
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, (btnh-30)/2, kScreenWidth/2-15, 30)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x313131"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
        
        _contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(btnw/2,(btnh-15)/2,btnw/2-20, 15)];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textAlignment=NSTextAlignmentRight;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor grayColor];
        [self addSubview:_contentLabel];

        _supplementLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _supplementLabel.font = [UIFont systemFontOfSize:13];
        _supplementLabel.textColor = [UIColor grayColor];
        _supplementLabel.numberOfLines = 0;
        [self addSubview:_supplementLabel];

    }
    return self;
}
- (void)setType:(NSInteger)type{
    _type = type;
    CGFloat height = 0.0;
    if (type==2) {
        CGFloat width =[self.contentLabel.text sizeWithLabelWidth:1000 font:[UIFont systemFontOfSize:13]].width;
        CGFloat suppleWidth =[self.supplementLabel.text sizeWithLabelWidth:1000 font:[UIFont systemFontOfSize:13]].width;

        if (width>btnw/2-20) {
            _contentLabel.textAlignment=NSTextAlignmentLeft;
            _supplementLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            _contentLabel.textAlignment=NSTextAlignmentRight;
            if (suppleWidth>btnw/2-20) {
                _supplementLabel.textAlignment = NSTextAlignmentLeft;
            }else{
                _supplementLabel.textAlignment = NSTextAlignmentRight;
            }
        }
        
        
        if (self.supplementLabel.text.length>0) {
            
            if ([self.contentLabel.text isEqualToString:@"未选择"]) {
                _contentLabel.hidden = YES;
                CGFloat suppleheight = [self.supplementLabel.text sizeWithLabelWidth:btnw/2-20 font:[UIFont systemFontOfSize:13]].height;
                _supplementLabel.frame =CGRectMake(btnw/2,(btnh-15)/2,btnw/2-20, suppleheight);
                height = suppleheight + 33;
            }else{
                _contentLabel.hidden = NO;
                CGFloat contentheight = [self.contentLabel.text sizeWithLabelWidth:btnw/2-20 font:[UIFont systemFontOfSize:13]].height;
                _contentLabel.frame =CGRectMake(btnw/2,(btnh-15)/2,btnw/2-20, contentheight);
                height = contentheight+33;
                
                CGFloat suppleheight = [self.supplementLabel.text sizeWithLabelWidth:btnw/2-20 font:[UIFont systemFontOfSize:13]].height;
                _supplementLabel.frame =CGRectMake(btnw/2,_contentLabel.bottom+5,btnw/2-20, suppleheight);
                height = height + suppleheight + 5;
            }
        }else{
            _contentLabel.hidden = NO;
            CGFloat contentheight = [self.contentLabel.text sizeWithLabelWidth:btnw/2-20 font:[UIFont systemFontOfSize:13]].height;
            _contentLabel.frame =CGRectMake(btnw/2,(btnh-15)/2,btnw/2-20, contentheight);
            height = contentheight+33;
        }

        if (height>0) {
            _titleLabel.frame =CGRectMake(15, (height-30)/2, kScreenWidth/2-15, 30);
        }
    }
}
@end
