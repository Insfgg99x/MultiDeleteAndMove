
//
//  EditViewController.m
//  MultiDelete
//
//  Created by 夏桂峰 on 15/11/26.
//  Copyright © 2015年 夏桂峰. All rights reserved.
//

#import "EditViewController.h"
#import "CustomCell.h"
#import "Model.h"

#define kWidth ([UIScreen mainScreen].bounds.size.width)
#define kHeight ([UIScreen mainScreen].bounds.size.height)

#define RGB(r,g,b) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f])

@interface EditViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tbView;
    NSMutableArray *_dataArray;
    NSMutableArray *_delArray;
}
//底部工具栏
@property(nonatomic,strong)UIView *toolView;

@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    [self initDataArray];
    [self createTbView];
    [self createBottomTools];
}
//初始设置
-(void)setUp
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    //导航视图
    UIView *naviView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    naviView.backgroundColor=RGB(157, 25, 36);
    [self.view addSubview:naviView];
    //导航栏标题
    UILabel *titleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kWidth, 44)];
    titleLb.text=@"编辑分组";
    titleLb.textColor=[UIColor whiteColor];
    titleLb.textAlignment=NSTextAlignmentCenter;
    titleLb.font=[UIFont systemFontOfSize:20];
    [naviView addSubview:titleLb];
    //编辑按钮
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 27, 40, 30)];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}
//初始化数组
-(void)initDataArray
{
    //初始化数据源数组
    _dataArray=[NSMutableArray array];
    
    [_dataArray addObject:[Model modelWithDesc:@"我的自选"]];
    [_dataArray addObject:[Model modelWithDesc:@"我关注的牛股"]];
    [_dataArray addObject:[Model modelWithDesc:@"环保牛股"]];
    //初始化删除数组
    _delArray=[NSMutableArray array];
}
//点击编辑按钮执行的方法
-(void)editAction:(UIButton *)sender
{
    [_tbView setEditing:!_tbView.isEditing animated:YES];
    sender.selected=!sender.isSelected;
    
    if(sender.isSelected)
    {
        NSArray *allCells=[_tbView visibleCells];
        for(CustomCell *cell in allCells)
        {
            cell.selectBtn.hidden=NO;
            cell.selectBtn.selected=NO;
        }
        //显示底部toolView
        [self showToolView];
    }
    else
    {
        NSArray *allCells=[_tbView visibleCells];
        for(CustomCell *cell in allCells)
            cell.selectBtn.hidden=YES;
        
        //隐藏底部toolView
        [self hideToolView];
        
        //执行删除
        [_dataArray removeObjectsInArray:_delArray];
        //清空删除数组
        [_delArray removeAllObjects];
        //刷新表视图
        [_tbView reloadData];
    }
}
//表视图
-(void)createTbView
{
    _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    _tbView.backgroundColor=[UIColor blackColor];
    _tbView.separatorColor=[UIColor whiteColor];
    _tbView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tbView];
    _tbView.scrollEnabled=NO;
    _tbView.allowsSelectionDuringEditing=YES;
    _tbView.tableFooterView=[UIView new];
}
//底部工具栏
-(void)createBottomTools
{
    _toolView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, 49)];
    _toolView.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:_toolView];
    
    //全选按钮
    UIButton *selectAllBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 14.5, 20, 20)];
    [selectAllBtn setImage:[UIImage imageNamed:@"un_all_select"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [selectAllBtn addTarget:self action:@selector(selectAllRows:) forControlEvents:UIControlEventTouchUpInside];
    selectAllBtn.tag=100;
    [_toolView addSubview:selectAllBtn];
    
    //去选lb
    UILabel *selectAllLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectAllBtn.frame)+5, 14.5, 40, 20)];
    selectAllLb.textColor=[UIColor whiteColor];
    selectAllLb.text=@"全选";
    selectAllLb.textAlignment=NSTextAlignmentCenter;
    [_toolView addSubview:selectAllLb];
    
    //删除数量
    UILabel *deleteCountLb=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-70, 14.5, 60, 20)];
    deleteCountLb.text=@"删除(0)";
    deleteCountLb.textAlignment=NSTextAlignmentCenter;
    deleteCountLb.textColor=[UIColor whiteColor];
    deleteCountLb.tag=111;
    [_toolView addSubview:deleteCountLb];
    
    //默认隐藏
    _toolView.hidden=YES;
}
//全选
-(void)selectAllRows:(UIButton *)sender
{
    sender.selected=!sender.isSelected;
    if(_delArray.count<_dataArray.count)
    {
        for(Model *m in _dataArray)
        {
            if(![_delArray containsObject:m])
                [_delArray addObject:m];
        }
        
        NSArray *allCells=[_tbView visibleCells];
        for(CustomCell *cell in allCells)
            cell.selectBtn.selected=YES;
    }
    else
    {
        [_delArray removeAllObjects];
        NSArray *allCells=[_tbView visibleCells];
        for(CustomCell *cell in allCells)
            cell.selectBtn.selected=NO;
    }
    [self refreshDeleteCountLb];
}
//显示工具栏
-(void)showToolView
{
    __weak typeof(self) weakSelf=self;
    UILabel *deleteCountLb=(UILabel *)[self.toolView viewWithTag:111];
    deleteCountLb.text=@"删除(0)";
    self.toolView.hidden=NO;
    //全选标记置为否
    UIButton *selectAllBtn=(UIButton *)[self.toolView viewWithTag:100];
    selectAllBtn.selected=NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat ypos=weakSelf.toolView.frame.origin.y;
        ypos=kHeight-49;
        weakSelf.toolView.frame=CGRectMake(0, ypos, kWidth, 49);
    }];
}
//隐藏工具栏
-(void)hideToolView
{
    __weak typeof(self) weakSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat ypos=weakSelf.toolView.frame.origin.y;
        ypos=kHeight;
        weakSelf.toolView.frame=CGRectMake(0, ypos, kWidth, 49);
    }completion:^(BOOL finished) {
        weakSelf.toolView.hidden=YES;
    }];
}
//刷新删除数量Lb
-(void)refreshDeleteCountLb
{
    UILabel *deleteCountLb=(UILabel *)[self.toolView viewWithTag:111];
    deleteCountLb.text=[NSString stringWithFormat:@"删除(%ld)",_delArray.count];
}
#pragma mark - 
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cid=@"cid";
    CustomCell *cel=[tableView dequeueReusableCellWithIdentifier:cid];
    if(!cel)
        cel=[[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    Model *model=_dataArray[indexPath.row];
    cel.titleLb.text=model.desc;
    
    return cel;
}
//编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
//移动
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //交换数据
    [_dataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}
//选中时执行的逻辑
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_tbView.isEditing)
    {
        Model *m=_dataArray[indexPath.row];
        
        if(![_delArray containsObject:m])
        {
            [_delArray addObject:m];
            //若选择了所有行，则将全选标记置为是
            if(_delArray.count==_dataArray.count)
            {
                //全选标记置为是
                UIButton *selectAllBtn=(UIButton *)[self.toolView viewWithTag:100];
                selectAllBtn.selected=YES;
            }
            CustomCell *cell=[_tbView cellForRowAtIndexPath:indexPath];
            cell.selectBtn.selected=YES;
        }
        else
        {
            [_delArray removeObject:m];
            //全选标记置为否
            UIButton *selectAllBtn=(UIButton *)[self.toolView viewWithTag:100];
            selectAllBtn.selected=NO;
            //置为未选中
            CustomCell *cell=[_tbView cellForRowAtIndexPath:indexPath];
            cell.selectBtn.selected=NO;
        }
        
        //刷新删除数Lb
        [self refreshDeleteCountLb];
    }
}
@end
