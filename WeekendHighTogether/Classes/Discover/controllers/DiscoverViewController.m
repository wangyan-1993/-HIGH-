//
//  DiscoverViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "DiscoverModel.h"
#import "ProgressHUD.h"
#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *likeArray;
@property(nonatomic, strong) NSMutableArray *idArray;
@end

@implementation DiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    //edgesForExtendedLayout默认的值是UIRectEdgeAll就是全部布局的意思
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"discover"];
    [self.tableView launchRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [self loadData];
}
- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    City *cityModel = [dbManager selectAllCity];
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];
[manager GET:[NSString stringWithFormat:@"%@&cityid=%ld&lat=%@&lng=%@", kDiscover, [cityModel.cityID integerValue], lat, lng] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    WYLog(@"%@", downloadProgress);
    [ProgressHUD showSuccess:@"Success"];
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
   // WYLog(@"%@", responseObject);
    NSDictionary *dict = responseObject;
    NSString *code = dict[@"code"];
    NSString *status = dict[@"status"];
    if (self.likeArray.count > 0) {
        [self.likeArray removeAllObjects];
    }
    if (self.idArray.count > 0) {
        [self.idArray removeAllObjects];
    }
    if ([status isEqualToString:@"success"]&& [code integerValue] == 0) {
        NSDictionary *dic = dict[@"success"];
        NSArray *array = dic[@"like"];
        for (NSDictionary *dictionary in array) {
            DiscoverModel *model = [[DiscoverModel alloc]initWithDictionary:dictionary];
            [self.likeArray addObject:model];
            [self.idArray addObject:dictionary[@"id"]];
        }
    }
    
   [self.tableView reloadData];
    self.tableView.reachedTheEnd = NO;
    [self.tableView tableViewDidFinishedLoading];
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    WYLog(@"%@", error);
    [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
}];
    
}

#pragma mark---UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.likeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discover" forIndexPath:indexPath];
    cell.model = self.likeArray[indexPath.row];
    return cell;
}


#pragma mark---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityViewController *activity = [mainSB instantiateViewControllerWithIdentifier:@"Activity"];
    activity.activityId = self.idArray[indexPath.row];
    [self.navigationController pushViewController:activity animated:YES];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"大家都喜欢";
}
#pragma mark---PullingRefreshTableViewDelegate
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
   [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
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
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth - 64 - 44) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor grayColor];
        self.tableView.rowHeight = 104;
        //只有上边的下拉刷新
        [self.tableView setHeaderOnly:YES];
    }
    return _tableView;
}
- (NSMutableArray *)likeArray{
    if (_likeArray == nil) {
        self.likeArray = [NSMutableArray new];
    }
    return _likeArray;
}
- (NSMutableArray *)idArray{
    if (_idArray == nil) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;
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
