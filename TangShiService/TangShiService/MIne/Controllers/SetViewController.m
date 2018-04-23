//
//  SetViewController.m
//  TangShiService
//
//  Created by vision on 17/6/5.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "SetViewController.h"
#import "LoginViewController.h"
#import "NewNotificationViewController.h"
#import "PassWordViewController.h"
#import "AppDelegate.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    BOOL                   isSetNewSound;
    BOOL                   isSetVibration;
}

@property (nonatomic,strong)UITableView  *setTableView;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle=@"设置";
    
    [self.view addSubview:self.setTableView];
}

#pragma mark  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"TCInstallTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSArray *arr=@[@"清除缓存",@"修改密码",@"消息通知",@"退出登录"];
    if (indexPath.section == 3) {
        cell.accessoryType=UITableViewCellAccessoryNone;
        UIButton *leaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [leaveBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [leaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leaveBtn addTarget:self action:@selector(leaveButton) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:leaveBtn];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section==0) {
            float Value = [self filePath];
            NSString *dataValueStr = nil;
            if (Value>100) {
                dataValueStr = [NSString stringWithFormat:@"大于%.2fMB",Value];
            }else if (Value<1){
                dataValueStr = [NSString stringWithFormat:@"%.fKB",Value*1024];
            }else {
                dataValueStr = [NSString stringWithFormat:@"%.2fMB",Value];
            }
            cell.detailTextLabel.text=dataValueStr;
            cell.textLabel.text=arr[indexPath.section];
        }else{
            cell.textLabel.text=arr[indexPath.section];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        float dataValue = [self filePath];
        NSString *dataValueStr = [NSString stringWithFormat:@"%.2fMB",dataValue];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否清除缓存" message:dataValueStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=99;
        [alertView show];
    }else if (indexPath.section==1) {
        PassWordViewController *passWordVC = [[PassWordViewController alloc] init];
        [self.navigationController pushViewController:passWordVC animated:YES];
    } else{
        NewNotificationViewController *newNotificationVC = [[NewNotificationViewController alloc] init];
        [self.navigationController pushViewController:newNotificationVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section==2?30:10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}
#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 99) {
        if (buttonIndex == 1) {
            [self clearFile];
        }
    }
}
#pragma mark -- Event Response
#pragma mark  退出登录
- (void)leaveButton{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kExpertLoginOut body:@"" success:^(id json) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserToken];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserSecret];
            
            [[EMClient sharedClient] logout:NO];
            
            [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:NO]];
            [NSUserDefaultsInfos removeObjectForKey:kImAllHelpers];
            [NSUserDefaultsInfos removeObjectForKey:kImMyPatients];
            [NSUserDefaultsInfos removeObjectForKey:kExpertInfoKey];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginViewController *loginVC=[[LoginViewController alloc] init];
                appDelegate.window.rootViewController=loginVC;
                appDelegate.tabBarViewController = nil;
                [ChatHelper sharedChatHelper].tabbarVC = nil;
            });
        } failure:^(NSString *errorStr) {
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -- 清除缓存
// 显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
}
#pragma mark -- 计算单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}
#pragma mark -- 计算文件大小
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

#pragma mark -- 清理缓存
- (void)clearFile{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
#pragma mark -- 清除成功
-(void)clearCachSuccess
{
    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除缓存成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [successAlert show];
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];//刷新
    [_setTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- Setters and Getters
#pragma mark 信息设置列表
-(UITableView *)setTableView{
    if (!_setTableView) {
        _setTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor=[UIColor bgColor_Gray];
    }
    return _setTableView;
}

@end
