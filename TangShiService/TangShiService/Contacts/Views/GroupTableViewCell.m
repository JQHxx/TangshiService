//
//  GroupTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/7/12.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "GroupTableViewCell.h"


@implementation GroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake( 20, (60 - 26)/2, 26, 26);
        [_deleteBtn setImage:[UIImage imageNamed:@"fz_ic_del"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBtn];
        
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(_deleteBtn.right + 10, 15, kScreenWidth - _deleteBtn.right - 80, 30)];
        _nameTextField.textColor = [UIColor blackColor];
        _nameTextField.font = [UIFont systemFontOfSize:16];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;  //编辑时出现叉号
        _nameTextField.returnKeyType =UIReturnKeyDone;   //return键变成完成键
        _nameTextField.delegate=self;
        [self.contentView addSubview:_nameTextField];
        
        UIImageView *moveIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 44,(60-24)/2, 24, 24)];
        moveIcon.image = [UIImage imageNamed:@"fz_ic_move"];
        [self.contentView addSubview:moveIcon];
        
        
    }
    return self;
}


#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    MyLog(@"textFieldShouldReturn");
    [_nameTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.setGroupCallback(_nameTextField.text);
    MyLog(@"textFieldDidEndEditing");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //按会车可以改变
    if ([string isEqualToString:@"n"])
    {
        return YES;
    }
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    //判断是否时我们想要限定的那个输入框
    if (self.nameTextField == textField)
    {
        if ([toBeString length] > 8)
        {   //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:8];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
