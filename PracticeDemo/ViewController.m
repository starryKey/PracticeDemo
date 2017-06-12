//
//  ViewController.m
//  PracticeDemo
//
//  Created by Li_JinLin on 16/10/24.
//  Copyright © 2016年 www.dahuatech.com. All rights reserved.
//

#import "ViewController.h"

#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开

#define DIC_ARARRY @"array"

#define DIC_TITILESTRING @"title"


#define CELL_HEIGHT 40.0f


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableVIew;
    
    NSMutableArray *_DataArray;
}

@end

@implementation ViewController

- (void)initDataSource

{
    
    //创建一个数组
    
    _DataArray=[[NSMutableArray alloc] init];
    
    for (int i=0;i<=5 ; i++) {
        
        NSMutableArray *array=[[NSMutableArray alloc] init];
        
        for (int j=0; j<=5;j++) {
            
            NSString *string=[NSString stringWithFormat:@"%i组-%i行",i,j];
            
            [array addObject:string];
            
        }
        
        NSString *string=[NSString stringWithFormat:@"第%i分组",i];
        
        //创建一个字典 包含数组，分组名，是否展开的标示
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:array,DIC_ARARRY,string,DIC_TITILESTRING,[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
        
        //将字典加入数组
        
        [_DataArray addObject:dic];
        
    }
    int i = 0;
    [NSString stringWithFormat:@"%i",i];
    
}

//初始化表

- (void)initTableView

{
    
    _tableVIew=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableVIew.dataSource=self;
    
    _tableVIew.delegate=self;
    
    [self.view addSubview:_tableVIew];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initDataSource];
    
    [self initTableView];
    self.view.backgroundColor = [UIColor greenColor];
}


#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    
    return _DataArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
    
    NSArray *array=[dic objectForKey:DIC_ARARRY];
    
    //判断是收缩还是展开
    
    if ([[dic objectForKey:DIC_EXPANDED]intValue]) {
        
        return array.count;
        
    }else
        
    {
        
        return 0;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *acell=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:acell];
    
    if (!cell) {
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:acell];
        
    }
    cell.backgroundColor = [UIColor cyanColor];
    NSArray *array=[[_DataArray objectAtIndex:indexPath.section] objectForKey:DIC_ARARRY];
    
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
    
    return cell;
    
}

//设置分组头的视图

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, CELL_HEIGHT)];
    
    hView.backgroundColor=[UIColor redColor];
    
    UIButton* eButton = [[UIButton alloc] init];
    
    //按钮填充整个视图
    
    eButton.frame = hView.frame;
    
    [eButton addTarget:self action:@selector(expandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    
    eButton.tag = section;
    
    //设置图标
    
    //根据是否展开，切换按钮显示图片
    
    if ([self isExpanded:section])
        
        [eButton setImage: [UIImage imageNamed: @"btn_xiala_pre.png" ]forState:UIControlStateNormal];
    
    else
        
        [eButton setImage: [UIImage imageNamed: @"btn_xiala_nor.png" ]forState:UIControlStateNormal];
    
    //设置分组标题
    
    [eButton setTitle:[[_DataArray objectAtIndex:section] objectForKey:DIC_TITILESTRING]forState:UIControlStateNormal];
    
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    
    //4个参数是到上边界，左边界，下边界，右边界的距离
    
    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,5, 0,0)];
    
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,300, 0,0)];
    
    //上显示线
    
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, -1, hView.frame.size.width,1)];
    
    label1.backgroundColor=[UIColor blueColor];
    
    [hView addSubview:label1];
    
    //下显示线
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, hView.frame.size.height-1, hView.frame.size.width,1)];
    
    label.backgroundColor=[UIColor blueColor];
    
    [hView addSubview:label];
    
    [hView addSubview: eButton];
    
    return hView;
    
}

//单元行内容递进

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 2;
    
}

//控制表头分组表头高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    
    return 40;
    
}


#pragma mark -- 内部调用

//对指定的节进行“展开/折叠”操作,若原来是折叠的则展开，若原来是展开的则折叠

-(void)collapseOrExpand:(NSInteger)section{
    
    NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
    
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    
    if (expanded) {
        
        [dic setValue:[NSNumber numberWithInt:0]forKey:DIC_EXPANDED];
        
    }else
        
    {
        
        [dic setValue:[NSNumber numberWithInt:1]forKey:DIC_EXPANDED];
        
    }
    
}

//返回指定节是否是展开的

-(int)isExpanded:(NSInteger)section{
    
    NSDictionary *dic=[_DataArray objectAtIndex:section];
    
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    
    return expanded;
    
}


//按钮被点击时触发

-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn= (UIButton*)sender;
    
    NSInteger section= btn.tag;//取得tag知道点击对应哪个块
    
    [self collapseOrExpand:section];
    
    //刷新tableview
    
    [_tableVIew reloadData];
    
}
@end
