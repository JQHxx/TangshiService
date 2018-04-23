//
//  PatientGroupViewController.m
//  TangShiService
//
//  Created by vision on 17/7/11.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "PatientGroupViewController.h"
#import "GroupTableViewCell.h"
#import "UIAlertView+Extension.h"
#import "TCGroupModel.h"

@interface PatientGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITextField     *groupNameText;
    
    BOOL            isChangeGroup;
}

@property (nonatomic,strong)UITableView  *groupTableView;

@end

@implementation PatientGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"分组管理";
    self.view.backgroundColor=[UIColor bgColor_Gray];
    
    self.isBackBtnHidden=YES;
    
    self.rigthTitleName=@"完成";
    
    [self.view addSubview:self.groupTableView];
}

#pragma mark -- UITableViewDelegate and UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"GroupTableViewCell";
    GroupTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!groupCell) {
        groupCell = [[GroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    groupCell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    TCGroupModel *group=self.groupArray[indexPath.row];
    groupCell.nameTextField.text=group.group_name;
    __weak typeof(self) weakSelf=self;
    __block GroupTableViewCell *blockCell=groupCell;
    groupCell.setGroupCallback=^(NSString *name){
        if (name.length==0) {
            [weakSelf.view makeToast:@"分组名不能为空" duration:1.0 position:CSToastPositionCenter];
            blockCell.nameTextField.text=group.group_name;
        }else if (name.length>8){
            [weakSelf.view makeToast:@"分组名不能超过8位" duration:1.0 position:CSToastPositionCenter];
        }else{
            NSString *body=[NSString stringWithFormat:@"group_id=%ld&group_name=%@",(long)group.group_id,name];
            [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kUpadateGroupName body:body success:^(id json) {
                [TCHelper sharedTCHelper].isUserGroupReload=YES;
            } failure:^(NSString *errorStr) {
                [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            }];
        }
    };
    
    [groupCell.deleteBtn addTarget:self action:@selector(deletePatientGroup:) forControlEvents:UIControlEventTouchUpInside];
    groupCell.deleteBtn.tag=indexPath.row;
    
    // -- 添加移动手势
    UILongPressGestureRecognizer *pan=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panReg:)];
    [groupCell addGestureRecognizer:pan];
    
    return groupCell;
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    [groupNameText resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([textField isFirstResponder]) {
        
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([[TCHelper sharedTCHelper] isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([[TCHelper sharedTCHelper] hasEmoji:string] || [[TCHelper sharedTCHelper] strIsContainEmojiWithStr:string]){
                return NO;
            }
        }
    }
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
    if (groupNameText == textField)
    {
        if ([toBeString length] > 8)
        {   //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:8];
            [self.view makeToast:@"不能超过8个字" duration:1.0 position:CSToastPositionCenter];
            return NO;
        }
    }
    return YES;
}

#pragma mark -- Event Response
#pragma mark 完成
-(void)rightButtonAction{
    if (isChangeGroup) {
        NSMutableArray *groupSortArr=[[NSMutableArray alloc] init];
        for (NSInteger i=0; i<self.groupArray.count; i++) {
            TCGroupModel *group=self.groupArray[i];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:group.group_id],@"group_id",@(i),@"sort", nil];
            [groupSortArr addObject:dict];
        }
        
        __weak typeof(self) weakSelf=self;
        NSString *params=[[TCHttpRequest sharedTCHttpRequest] getValueWithParams:groupSortArr];
        NSString *body=[NSString stringWithFormat:@"group_arr=%@",params];
        [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kChangeGroupSort body:body success:^(id json) {
            [TCHelper  sharedTCHelper].isUserGroupReload=YES;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *errorStr) {
            [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 添加分组
-(void)addPatientGroupAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分组名称" message:@"请输入新分组名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setPlaceholder:@"8个字以内"];
        [textField setTextAlignment:NSTextAlignmentCenter];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setDelegate:self];
        groupNameText=textField;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    __weak typeof(self) weakSelf=self;
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController.textFields.firstObject resignFirstResponder];
        alertController.textFields.firstObject.text = [alertController.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *toBeString=alertController.textFields.firstObject.text;
        NSString *groupName=nil;
        if (toBeString.length<1) {
            [weakSelf.view makeToast:@"分组名称不能为空" duration:1.0 position:CSToastPositionCenter];
        }else if (toBeString.length>8) {
            [weakSelf.view makeToast:@"不能超过8个字" duration:1.0 position:CSToastPositionCenter];
        }else{
            groupName=alertController.textFields.firstObject.text;
            NSString *body=[NSString stringWithFormat:@"group_name=%@",groupName];
            [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kAddUserGroup body:body success:^(id json) {
                isChangeGroup=YES;
                [TCHelper  sharedTCHelper].isUserGroupReload=YES;
                NSDictionary *result=[json objectForKey:@"result"];
                if (kIsDictionary(result)&&result.count>0) {
                    TCGroupModel *newGroup=[[TCGroupModel alloc] init];
                    [newGroup setValues:result];
                    newGroup.group_name=kIsEmptyString(newGroup.group_name)?groupName:newGroup.group_name;
                    newGroup.count=0;
                    [weakSelf.groupArray addObject:newGroup];
                    [weakSelf.groupTableView reloadData];
                }
            } failure:^(NSString *errorStr) {
                [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            }];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    alertController.view.layer.cornerRadius = 20;
    alertController.view.layer.masksToBounds = YES;
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark 删除分组
-(void)deletePatientGroup:(UIButton *)sender{
    UIView *contentView = [sender superview];
    GroupTableViewCell *cell = (GroupTableViewCell *)[contentView superview];
    NSIndexPath *indexPath = [self.groupTableView indexPathForCell:cell];
    
    TCGroupModel *selGroup=self.groupArray[indexPath.row];
    if (selGroup.count>0) {
        UIAlertView *deleteTaskAlertView = [[UIAlertView alloc]initWithTitle:@"该分组下还有患者，删除后患者会移至默认分组中" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        
        __weak typeof(self) weakSelf=self;
        [deleteTaskAlertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf requestForDeleteUserGroup:selGroup indexPath:indexPath];
            }
        }];
    }else{
        [self requestForDeleteUserGroup:selGroup indexPath:indexPath];
    }
}

#pragma mark 移动cell
- (void)panReg:(UILongPressGestureRecognizer*)recognise{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)recognise;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.groupTableView];
    NSIndexPath *indexPath = [self.groupTableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.groupTableView cellForRowAtIndexPath:indexPath];
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.groupTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.groupArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.groupTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                isChangeGroup=YES;
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.groupTableView cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            break;
        }
    }
}

#pragma mark - Helper methods
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

#pragma mark -- Private Methods
#pragma mark 删除分组
-(void)requestForDeleteUserGroup:(TCGroupModel *)group indexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf=self;
    NSString *body=[NSString stringWithFormat:@"group_id=%ld",(long)group.group_id];
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kDeleteUserGroup body:body success:^(id json) {
        isChangeGroup=YES;
        [TCHelper sharedTCHelper].isUserGroupReload=YES;
        [weakSelf.groupArray removeObjectAtIndex:indexPath.row];
        [weakSelf.groupTableView reloadData];
    } failure:^(NSString *errorStr) {
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}

#pragma mark -- Setters and Getters
#pragma mark 分组管理
-(UITableView *)groupTableView{
    if (!_groupTableView) {
        _groupTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight) style:UITableViewStylePlain];
        _groupTableView.backgroundColor=[UIColor bgColor_Gray];
        _groupTableView.delegate=self;
        _groupTableView.dataSource=self;
        _groupTableView.tableHeaderView=[self tableViewHeaderView];
        _groupTableView.tableFooterView=[[UIView alloc] init];
        
    }
    return _groupTableView;
}


#pragma mark 添加分组
- (UIView *)tableViewHeaderView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 150, 40)];
    [btn setImage:[UIImage imageNamed:@"fz_ic_add"] forState:UIControlStateNormal];
    [btn setTitle:@"添加分组" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btn addTarget:self action:@selector(addPatientGroupAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    
    UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(0, 59, kScreenWidth, 1)];
    line.backgroundColor=kLineColor;
    [footerView addSubview:line];
  
    return footerView;
}



@end
