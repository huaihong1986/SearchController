//
//  ViewController.m
//  searchController
//
//  Created by 柴东鹏 on 15/5/14.
//  Copyright (c) 2015年 CDP. All rights reserved.
//

#import "ViewController.h"

#import "CDPSearchModel.h"


//CDPSearchController适用于iOS8.0及以上

//调用CDPSearchController的controller需要遵守以下tableView的协议

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    NSMutableArray *_dataArr;//数据源
    UITableView *_tableView;
    UISearchBar *_searchBar;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
 
    [self creatData];
    
    [self creatUI];
    
    [self addSearchBar];
    
}
#pragma mark 创建Data和UI
//创建Data
-(void)creatData{
    CDPSearchModel *model1=[[CDPSearchModel alloc] initWithNameStr:@"王二货" andPhoneStr:@"13119491824" signStr:@"我只是个二货"];
    
    CDPSearchModel *model2=[[CDPSearchModel alloc] initWithNameStr:@"李四" andPhoneStr:@"13119412312" signStr:@"李四就是我"];
    
    CDPSearchModel *model3=[[CDPSearchModel alloc] initWithNameStr:@"菲菲" andPhoneStr:@"13119493421" signStr:@"额。。。"];
    
    CDPSearchModel *model4=[[CDPSearchModel alloc] initWithNameStr:@"女神经" andPhoneStr:@"13217491814" signStr:@"女汉子"];
    
    CDPSearchModel *model5=[[CDPSearchModel alloc] initWithNameStr:@"王小二" andPhoneStr:@"13115137224" signStr:@"小二哥"];
    
    CDPSearchModel *model6=[[CDPSearchModel alloc] initWithNameStr:@"ccToday" andPhoneStr:@"13819444824" signStr:@"gogoggo"];
    
    CDPSearchModel *model7=[[CDPSearchModel alloc] initWithNameStr:@"美美" andPhoneStr:@"13222491824" signStr:@"我去"];
    
    CDPSearchModel *model8=[[CDPSearchModel alloc] initWithNameStr:@"疯子d" andPhoneStr:@"13937182412" signStr:@"疯疯疯"];
    
    CDPSearchModel *model9=[[CDPSearchModel alloc] initWithNameStr:@"LEO" andPhoneStr:@"18231255123" signStr:@"LLLLL"];
    
    CDPSearchModel *model10=[[CDPSearchModel alloc] initWithNameStr:@"女" andPhoneStr:@"18431266123" signStr:@"女L"];

    CDPSearchModel *model11=[[CDPSearchModel alloc] initWithNameStr:@"男" andPhoneStr:@"18928171241" signStr:@"男男"];
    
    
    //创建数据源
    _dataArr=[[NSMutableArray alloc] initWithObjects:model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11,nil];
    

}
//创建UI
-(void)creatUI{
    
      //tableView
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
 
}

#pragma mark 添加搜索栏
-(void)addSearchBar{
    CGRect searchBarRect=CGRectMake(0, 0, self.view.frame.size.width, 80);
    
    _searchBar=[[UISearchBar alloc]initWithFrame:searchBarRect];
    _searchBar.prompt=@"搜索栏标题";
    _searchBar.placeholder=@"搜索为空时默认灰色字";
    _searchBar.showsCancelButton=YES;    //添加搜索框到页眉位置
    _searchBar.delegate=self;
    _tableView.tableHeaderView=_searchBar;
    
}

#pragma mark - 搜索框代理
#pragma mark  取消搜索
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarCancelButtonClicked");
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    _tableView.allowsSelection=YES;
    _tableView.scrollEnabled=YES;
    [self creatData];
    [_tableView reloadData];
}




//添加搜索框事件：
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //NSLog(@"searchBarTextDidBeginEditing");
    [searchBar setShowsCancelButton:YES animated:YES];
    _tableView.allowsSelection=NO;
    _tableView.scrollEnabled=NO;
}


//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarSearchButtonClicked");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    NSString *searchStr = searchBar.text;
    [self doSearch:searchStr];
   
    _tableView.allowsSelection=YES;
    _tableView.scrollEnabled=YES;
    [_tableView reloadData];
}

-(void) doSearch:searchStr{
    NSMutableString *_predicateStr=[NSMutableString stringWithFormat:@""];
    NSArray *_parameterArr=@[@"nameStr",@"phoneStr",@"signStr"];
    for (NSString *parameterStr in _parameterArr) {
        
        [_predicateStr appendString:[NSString stringWithFormat:@"self.%@ CONTAINS[D]'%@' OR ",parameterStr,searchStr]];
    }
    
    
    [_predicateStr deleteCharactersInRange:NSMakeRange(_predicateStr.length-4,4)];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:_predicateStr];
    _dataArr = [NSMutableArray arrayWithArray:[_dataArr filteredArrayUsingPredicate:predicate]];
}

//输入搜索文字时隐藏搜索按钮，清空时显示

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //NSLog(@"searchBarShouldBeginEditing");
    searchBar.showsScopeBar = YES;
    
    [searchBar sizeToFit];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    //NSLog(@"searchBarShouldEndEditing");
    searchBar.showsScopeBar = NO;
    
    [searchBar sizeToFit];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
    
}



#pragma mark tableViewDelegate
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断是否搜索tableView
    return _dataArr.count;

}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cdpCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cdpCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:15];
    }
    //判断是否搜索tableView
    CDPSearchModel *model=[_dataArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[NSString stringWithFormat:@"姓名:%@",model.nameStr];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"电话:%@  签名:%@",model.phoneStr,model.signStr];
    
    return cell;
}
//cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"搜索点击" message:[NSString stringWithFormat:@"点击了第%ld行",(long)indexPath.row] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
   
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
