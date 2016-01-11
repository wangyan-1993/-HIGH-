//
//  ClassifyViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ClassifyViewController.h"
#import "VOSegmentedControl.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import "ActivityViewController.h"
#import "GoodActivityModel.h"

@interface ClassifyViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, assign) BOOL refreshing;



@property(nonatomic, strong) PullingRefreshTableView *tableView;
//用来负责展示数据的数组
@property(nonatomic, strong) NSMutableArray *showDataArray;
//演出剧目
@property(nonatomic, strong) NSMutableArray *showArray;
//景点场馆
@property(nonatomic, strong) NSMutableArray *touristArray;
//学习益智
@property(nonatomic, strong) NSMutableArray *studyArray;
//亲子旅游
@property(nonatomic, strong) NSMutableArray *familyArray;

@property(nonatomic, strong) VOSegmentedControl *segctrl;
@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"classify"];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.tableView launchRefreshing];
    [self showBackBtn];
    //第一次进入分类列表请求全部的分类数据
    [self getFourRequest];
   
    [self.view addSubview:self.segctrl];
    [self.view addSubview:self.tableView];
}


#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classify" forIndexPath:indexPath];
    cell.goodModel = self.showDataArray[indexPath.row];
    return cell;
}



#pragma mark---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityViewController *activity = [mainSB instantiateViewControllerWithIdentifier:@"Activity"];
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    activity.activityId = model.activityId;
    [self.navigationController pushViewController:activity animated:YES];
}



#pragma mark---PullingRefreshTableViewDelegate
//tableView开始刷新的时候要用，下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(showPreviousSelect) withObject:nil afterDelay:1.0];
    
}
//上拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(showPreviousSelect) withObject:nil afterDelay:1.0];
    
}
//刷新完成时间
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





#pragma mark---custom mothed

- (void)getFourRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //演出剧目， typeid=6
    [manager GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@", kClassifyList, @(1), @(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *array = dic[@"success"][@"acData"];
        for (NSDictionary *dic in array) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.showArray addObject:model];
            }
        }else{
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //景点场馆， typeid=23
    [manager GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@", kClassifyList, @(1), @(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *array = dic[@"success"][@"acData"];
            for (NSDictionary *dic in array) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.touristArray addObject:model];
            }
        }else{
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    //学习益智， typeid=22
    [manager GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@", kClassifyList, @(1), @(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *array = dic[@"success"][@"acData"];
            for (NSDictionary *dic in array) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.studyArray addObject:model];
            }
        }else{
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    //亲子旅游， typeid=21
    [manager GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@", kClassifyList, @(1), @(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *array = dic[@"success"][@"acData"];
            for (NSDictionary *dic in array) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.familyArray addObject:model];
            }
        }else{
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //根据上一页选择的按钮，确定显示第几页数据
    [self showPreviousSelect];

}
- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
}

- (void)showPreviousSelect{
    if (self.showDataArray.count > 0) {
        [self.showDataArray removeAllObjects];
    }
   switch ((NSInteger)self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
        self.showDataArray = self.showArray;
            break;
        case ClassifyListTypeTouristPlace:
           self.showDataArray = self.touristArray;
            break;
        case ClassifyListTypeStudyPUZ:
           self.showDataArray = self.studyArray;
            break;
        case ClassifyListTypeFamilyTravel:
           self.showDataArray = self.familyArray;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}


#pragma mark---懒加载

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40, kWidth, kHeigth - 64 - 40) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 90;
        
    }
    return _tableView;
}
- (NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}

- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}
- (NSMutableArray *)touristArray{
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}
- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}
- (NSMutableArray *)familyArray{
    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
}
- (VOSegmentedControl *)segctrl{
    if (_segctrl == nil) {
        self.segctrl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"演出剧目"}, @{VOSegmentText: @"景点场馆"}, @{VOSegmentText: @"学习益智"}, @{VOSegmentText: @"亲子旅游"}]];
        self.segctrl.contentStyle = VOContentStyleTextAlone;
        self.segctrl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segctrl.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segctrl.selectedBackgroundColor = self.segctrl.backgroundColor;
        self.segctrl.allowNoSelection = NO;
        self.segctrl.frame = CGRectMake(0, 0, kWidth, 40);
        self.segctrl.indicatorThickness = 4;
        self.segctrl.selectedSegmentIndex = (NSInteger)self.classifyListType - 1;
       [self.segctrl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
        __block ClassifyViewController *weakVC = self;
        [self.segctrl setIndexChangeBlock:^(NSInteger index) {
            weakVC.classifyListType = index;
            NSLog(@"1: block --> %@", @(index));
        }];
    }
    return _segctrl;
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
