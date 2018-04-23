//
//  ConversationTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/5/31.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ConversationTableViewCell.h"
#import "TCCommonNewsModel.h"

@interface ConversationTableViewCell (){
    UIImageView   *imgView;
    UILabel       *nameLbl;
    UILabel       *timeLbl;
    UILabel       *messageLbl;
    UILabel       *badgeLbl;
}

@end

@implementation ConversationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        imgView.layer.cornerRadius=25;
        imgView.clipsToBounds=YES;
        [self.contentView addSubview:imgView];
        
        nameLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        nameLbl.font=[UIFont boldSystemFontOfSize:16];
        nameLbl.textColor=[UIColor blackColor];
        [self.contentView addSubview:nameLbl];
        
        timeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        timeLbl.font=[UIFont systemFontOfSize:12];
        timeLbl.textAlignment=NSTextAlignmentRight;
        timeLbl.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:timeLbl];
        
        messageLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        messageLbl.font=[UIFont systemFontOfSize:14];
        messageLbl.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:messageLbl];
        
        badgeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        badgeLbl.backgroundColor=[UIColor redColor];
        badgeLbl.textColor=[UIColor whiteColor];
        badgeLbl.textAlignment=NSTextAlignmentCenter;
        badgeLbl.font=[UIFont systemFontOfSize:10];
        [self.contentView addSubview:badgeLbl];
        badgeLbl.hidden=YES;
        
    }
    return self;
}



-(void)conversationCellDisplayWithModel:(id )model type:(NSInteger)type{
    if (type==0) {
        BOOL isRead=YES;
        if ([model isKindOfClass:[TCSystemNewsModel class]]) {
            imgView.image=[UIImage imageNamed:@"ic_msg_tips"];
            nameLbl.text=@"系统消息";
            nameLbl.frame=CGRectMake(imgView.right+10, 5,100, 30);
            
            TCSystemNewsModel *newsModel=(TCSystemNewsModel *)model;
            
            NSString *msgDate=[[TCHelper sharedTCHelper] timeWithTimeIntervalString:newsModel.send_time format:@"yyyy-MM-dd HH:mm"];
            timeLbl.text=kIsEmptyString(newsModel.send_time)?@"":msgDate;
            CGFloat timeW=[msgDate boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:timeLbl.font].width;
            timeLbl.frame=CGRectMake(kScreenWidth-timeW-10,10, timeW, 20);
            
            messageLbl.text=kIsEmptyString(newsModel.title)?@"暂无":newsModel.title;
            
            isRead=kIsEmptyString(newsModel.title)?YES:newsModel.isRead;
        }else{
            imgView.image=[UIImage imageNamed:@"ic_m_pinglun"];
            nameLbl.text=@"文章评论";
            nameLbl.frame=CGRectMake(imgView.right+10, 15,100, 30);
            timeLbl.frame=CGRectMake(kScreenWidth-40,10, 30, 20);
            timeLbl.hidden=YES;
            
            TCCommonNewsModel *commentModel=(TCCommonNewsModel *)model;
            isRead=commentModel.newsIndex>0?commentModel.hasNewMessages:YES;
        }
        
        badgeLbl.hidden=isRead;
        badgeLbl.frame=CGRectMake(kScreenWidth-20, timeLbl.bottom+10, 10, 10);
        badgeLbl.layer.cornerRadius=5;
        badgeLbl.clipsToBounds=YES;
        badgeLbl.text=@"";
        
    }else{
        ConversationModel *conversation=(ConversationModel *)model;
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:conversation.lastMsgHeadPic] placeholderImage:[UIImage imageNamed:@"ic_m_head"]];
        nameLbl.text=conversation.lastMsgUserName;
        timeLbl.text=conversation.lastMsgTime;
        
        CGFloat timeW=[conversation.lastMsgTime boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:timeLbl.font].width;
        timeLbl.frame=CGRectMake(kScreenWidth-timeW-10,10, timeW, 20);
        nameLbl.frame=CGRectMake(imgView.right+10, 5, kScreenWidth-imgView.right-timeW-20, 30);
        
        messageLbl.text=conversation.lastMsg;
        
        NSInteger count=conversation.unreadCount;
        if (count>0) {
            badgeLbl.hidden=NO;
            NSString *countStr=nil;
            if (count>99) {
                countStr=@"99+";
            }else{
                countStr=[NSString stringWithFormat:@"%ld",(long)count];
            }
            badgeLbl.text=countStr;
            CGSize countSize=[countStr boundingRectWithSize:CGSizeMake(80,60) withTextFont:badgeLbl.font];
            badgeLbl.frame=CGRectMake(kScreenWidth-countSize.width-20, nameLbl.bottom, countSize.width+12, countSize.height+5);
            badgeLbl.layer.cornerRadius=(countSize.height+5)/2.0;
            badgeLbl.clipsToBounds=YES;
            
        }else{
            badgeLbl.hidden=YES;
        }
    }
    
    
    
    messageLbl.frame=CGRectMake(imgView.right+10, nameLbl.bottom, kScreenWidth-imgView.right-badgeLbl.width-20, 20);
    
}


@end
