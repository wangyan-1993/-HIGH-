//
//  MainViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property (nonatomic, strong) NSMutableArray *themeArray;

@property(nonatomic, strong) NSMutableArray *adArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //left
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self configTableViewHeaderView];
    //请求网络数据
    [self requestModel];
    
}

#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.listArray[section];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.listArray[indexPath.section][indexPath.row];
    return cell;
}


#pragma mark---UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 343;
//    }
//    return 0;
//}
//自定义分区头部
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
//view.backgroundColor = [UIColor redColor];
//self.tableView.tableHeaderView = view;

//       return view;
//}


//自定义tableView头部
- (void)configTableViewHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
    //添加轮播图
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186)];
    scrollView.contentSize = CGSizeMake(self.adArray.count * [UIScreen mainScreen].bounds.size.width, 186);
    for (int i = 0; i < self.adArray.count; i ++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 186)];
        [imageview sd_setImageWithURL:self.adArray[i] placeholderImage:nil];
        [scrollView addSubview:imageview];
        
    }
    [headerView addSubview:scrollView];
    
    //button
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width / 4, 186, [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 4);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i + 1]] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(activityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
    }
    
    //竞选活动&热门专题
   
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 186 + [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4);
        [btn1 setImage:[UIImage imageNamed:@"home_huodong"]forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(goodActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn1];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 186 + [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4);
    [btn2 setImage:[UIImage imageNamed:@"home_zhuanti"]forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(hotActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn2];
    
    
    
    self.tableView.tableHeaderView = headerView;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
  UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 160, 5, 320, 16)];
    if (section == 0) {
       sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
    } else {
       sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
   [view addSubview:sectionView];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}
#pragma mark---button method
- (void)selectCityAction:(UIBarButtonItem *)barBtn{
    
}
- (void)searchActivityAction:(UIBarButtonItem *)barBtn{
    
}
- (void)activityButtonAction:(UIButton *)btn{
    
}
- (void)goodActivityButtonAction:(UIButton *)btn{
    
}
- (void)hotActivityButtonAction:(UIButton *)btn{
    
}


#pragma mark---网络请求
- (void)requestModel{

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1";
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //*****************解析数据
        NSDictionary *dictionary = responseObject;
        NSString *status = dictionary[@"status"];
        NSInteger code = [dictionary[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && (code == 0)) {
            NSDictionary *dic = dictionary[@"success"];
            NSArray *acDataArray = dic[@"acData"];//推荐活动
            NSArray *adDataArray = dic[@"adData"];//广告
            NSArray *rcDataArray = dic[@"rcData"];//推荐专题
            NSString *cityName = dic[@"cityname"];
            //以请求回来的城市作为导航栏按钮标题
            self.navigationItem.leftBarButtonItem.title = cityName;
            
            //推荐活动
            for (NSDictionary *dict in acDataArray) {
                MainModel *model = [[MainModel alloc]initWithDictionary:dict];
                [self.activityArray addObject:model];
            }
            //推荐专题
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc]initWithDictionary:dict];
                [self.themeArray addObject:model];
            }
            
            [self.listArray addObject:self.activityArray];
            [self.listArray addObject:self.themeArray];
            
            //广告
            for (NSDictionary *dict in adDataArray) {
                [self.adArray addObject:dict[@"url"]];
            }
            //取到数据之后重新刷新headerView
            [self configTableViewHeaderView];
            [self.tableView reloadData];
            
        }else{
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    //*****************
//    NSString *URLString = @"http://e.kumi.cn/app/v1.3/index.php?";
//    NSDictionary *parameters = @{@"s": @"02a411494fa910f5177d82a6b0a63788", @"t": @"1451307342", @"channelid":@"appstore", @"cityid":@"1", @"lat":@"34.62172291944134", @"limit":@"30", @"lng":@"112.4149512442411", @"page":@"1"};
}
#pragma mark---数组懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}

- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}
- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
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
