//
//  TCRecordDietViewController.m
//  TonzeCloud
//
//  Created by vision on 17/2/22.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCRecordDietViewController.h"
#import "TCDiningButton.h"
#import "TCFoodAddTableViewCell.h"
#import "TCFoodAddModel.h"

@interface TCRecordDietViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray               *periodArray;
    NSMutableArray        *foodListArray;
}

@property (nonatomic,strong)UILabel          *colaryLabel;
@property (nonatomic,strong)TCDiningButton   *diningTimeButton;
@property (nonatomic,strong)TCDiningButton   *diningTypeButton;
@property (nonatomic,strong)UITableView      *foodTableView;
@property (nonatomic,strong)UIButton         *saveFoodButton;

@end

@implementation TCRecordDietViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"记录饮食";
    self.view.backgroundColor=[UIColor bgColor_Gray];
    
    foodListArray=[[NSMutableArray alloc] init];
    

    [self.view addSubview:self.colaryLabel];
    [self.view addSubview:self.diningTimeButton];
    [self.view addSubview:self.diningTypeButton];
    [self.view addSubview:self.foodTableView];
    
    [self loadDietRecordData];  //加载饮食记录数据
    
}


#pragma mark -- UITableViewDelegate and UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return foodListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"TCFoodAddTableViewCell";
    TCFoodAddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TCFoodAddTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    TCFoodAddModel *food=foodListArray[indexPath.row];
    [cell cellDisplayWithFood:food];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark -- Private Methods
#pragma mark 加载饮食记录
-(void)loadDietRecordData{
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    NSArray *list=self.foodRecordModel.detail;
    for (NSInteger i=0; i<list.count; i++) {
        NSDictionary *dict=list[i];
        TCFoodAddModel *model=[[TCFoodAddModel alloc] init];
        model.id=[dict[@"ingredient_id"] integerValue];
        model.image_url=dict[@"image_url"];
        model.name=dict[@"food_name"];
        model.calory=[NSNumber numberWithInteger:[dict[@"ingredient_calories"]  integerValue]];
        model.weight=[NSNumber numberWithInteger:[dict[@"ingredient_weight"] integerValue]];
        model.isSelected=[NSNumber numberWithBool:YES];
        [tempArr addObject:model];
    }
    foodListArray=tempArr;
    
    [self.foodTableView reloadData];
}


#pragma mark -- Getters and Setters
#pragma mark 能量值
-(UILabel *)colaryLabel{
    if (_colaryLabel==nil) {
        _colaryLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 60)];
        _colaryLabel.backgroundColor=[UIColor whiteColor];
        _colaryLabel.textColor=[UIColor blackColor];
        _colaryLabel.font=[UIFont systemFontOfSize:13.0f];
        _colaryLabel.textAlignment=NSTextAlignmentCenter;
        
        NSMutableAttributedString *attributeStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  千卡",(long)self.foodRecordModel.calorie]];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:kRGBColor(244, 182, 123),NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(0, attributeStr.length-2)];
        _colaryLabel.attributedText=attributeStr;
    }
    return _colaryLabel;
}

#pragma mark  用餐日期
-(TCDiningButton *)diningTimeButton{
    if (_diningTimeButton==nil) {
        _diningTimeButton=[[TCDiningButton alloc] initWithFrame:CGRectMake(0, self.colaryLabel.bottom+10, kScreenWidth, 50) title:@"用餐日期"];
        _diningTimeButton.valueString=[[TCHelper sharedTCHelper] timeWithTimeIntervalString:self.foodRecordModel.feeding_time format:@"yyyy-MM-dd"];
    }
    return _diningTimeButton;
}

#pragma mark 用餐类别
-(TCDiningButton *)diningTypeButton{
    if (_diningTypeButton==nil) {
        _diningTypeButton=[[TCDiningButton alloc] initWithFrame:CGRectMake(0, self.diningTimeButton.bottom, kScreenWidth, 50) title:@"用餐类别"];
    
        _diningTypeButton.valueString=[[TCHelper sharedTCHelper] getDietPeriodChTimeNameWithPeriod:self.foodRecordModel.time_slot];
        
        UILabel *lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineLabel.backgroundColor=kLineColor;
        [_diningTypeButton addSubview:lineLabel];
    }
    return _diningTypeButton;
}

#pragma mark 食物列表
-(UITableView *)foodTableView{
    if (_foodTableView==nil) {
        _foodTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.diningTypeButton.bottom+10, kScreenWidth, kScreenHeight-self.diningTypeButton.bottom-10) style:UITableViewStylePlain];
        _foodTableView.delegate=self;
        _foodTableView.dataSource=self;
        _foodTableView.showsVerticalScrollIndicator=NO;
        _foodTableView.backgroundColor=[UIColor bgColor_Gray];
        _foodTableView.tableFooterView=[[UIView alloc] init];
    }
    return _foodTableView;
}



@end
