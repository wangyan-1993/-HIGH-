//
//  GoodActivityViewController.m
//  WeekendHighTogether
//  精选活动
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "GoodActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import "ActivityViewController.h"
@interface GoodActivityViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, strong) NSMutableArray *arrayModel;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;


@end

@implementation GoodActivityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"精选活动";
    [self showBackBtn];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //    [self.tableView setHeaderOnly:YES];          //只有上拉刷新
    //    [self.tableView setFooterOnly:YES];          //只有下拉刷新
   
    //如果整张视图只想让他显示4行的话，后面就变成空白
    //self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.tableView];
     [self.tableView launchRefreshing];
}


#pragma mark---UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu", self.arrayModel.count);
    return self.arrayModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityTableViewCell *goodActivityCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    goodActivityCell.goodModel = self.arrayModel[indexPath.row];
    return goodActivityCell;
}

#pragma mark---UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityViewController *activity = [mainSB instantiateViewControllerWithIdentifier:@"Activity"];
    GoodActivityModel *model = self.arrayModel[indexPath.row];
    activity.activityId = model.activityId;
    [self.navigationController pushViewController:activity animated:YES];
}

#pragma mark---PullingRefreshTableViewDelegate
//tableView开始刷新的时候要用，下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
      _pageCount = 1;    
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
  
}
//上拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
     _pageCount += 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
   
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}

//加载数据
- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld", kGoodActivity, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *array = dic[@"success"][@"acData"];
            for (NSDictionary *dic in array) {
            GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
            [self.arrayModel addObject:model];
        }
    }
         [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
    }];
   
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    }

#pragma mark - ScrollView Method
//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}



#pragma mark---懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 90;
    }
    return _tableView;
}

- (NSMutableArray *)arrayModel{
    if (_arrayModel == nil) {
        self.arrayModel = [NSMutableArray new];
    }
    return _arrayModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
