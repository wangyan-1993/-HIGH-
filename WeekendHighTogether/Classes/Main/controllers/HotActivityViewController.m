//
//  HotActivityViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "HotActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "ThemeViewController.h"
#import "HotActivityTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotActivityViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}

@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) NSMutableArray *arrayImage;
@property(nonatomic, strong) NSMutableArray *arrayID;
@property(nonatomic, strong) NSMutableArray *arrayCount;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtnWithImage:@"back"];
    self.title = @"热门专题";
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth - 64) pullingDelegate:self];
     [self.tableView registerNib:[UINib nibWithNibName:@"HotActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"hotcell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 200;
    [self.tableView launchRefreshing];
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.tableView];
    
}
#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayImage.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotcell" forIndexPath:indexPath];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:self.arrayImage[indexPath.row]] placeholderImage:nil];
    cell.coubtsLabel.text = self.arrayCount[indexPath.row];
    return cell;
    
}
#pragma mark--- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeViewController *themeVC = [[ThemeViewController alloc]init];
    themeVC.themeid = self.arrayID[indexPath.row];
    [self.navigationController pushViewController:themeVC animated:YES];
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
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
    
    
}

- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    City *cityModel = [dbManager selectAllCity];
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%lu&cityid=%ld&lat=%@&lng=%@", kHotActivity, _pageCount, [cityModel.cityID integerValue], lat, lng] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        if (self.arrayImage.count > 0) {
            [self.arrayImage removeAllObjects];
        }
        if (self.arrayID.count > 0) {
            [self.arrayID removeAllObjects];
        }
        if (self.arrayCount.count > 0) {
            [self.arrayCount removeAllObjects];
        }
        

        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *array = dict[@"rcData"];
            if (self.refreshing) {
                //下拉刷新的时候需要移除数组中的元素
                if (self.arrayImage.count > 0) {
                    [self.arrayImage removeAllObjects];
                }
                if (self.arrayID.count > 0) {
                    [self.arrayID removeAllObjects];
                }
                if (self.arrayCount.count > 0) {
                    [self.arrayCount removeAllObjects];
                }
                
            }
            for (NSDictionary *dic in array) {
                [self.arrayImage addObject:dic[@"img"]];
                [self.arrayID addObject:dic[@"id"]];
                [self.arrayCount addObject:dic[@"counts"]];
            }
            [self.tableView reloadData];
        }else{
            
        }
        
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

- (NSMutableArray *)arrayImage{
    if (_arrayImage == nil) {
        self.arrayImage = [NSMutableArray new];
    }
    return _arrayImage;
}
- (NSMutableArray *)arrayID{
    if (_arrayID == nil) {
        self.arrayID = [NSMutableArray new];
    }
    return _arrayID;
}


- (NSMutableArray *)arrayCount{
    if (_arrayCount == nil) {
        self.arrayCount = [NSMutableArray new];
    }
    return _arrayCount;
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
