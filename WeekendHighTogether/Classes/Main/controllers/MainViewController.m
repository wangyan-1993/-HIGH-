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
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityViewController.h"
#import "ThemeViewController.h"
#import "ClassifyViewController.h"
#import "GoodActivityViewController.h"
#import "HotActivityViewController.h"
@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property (nonatomic, strong) NSMutableArray *themeArray;
//广告
@property(nonatomic, strong) NSMutableArray *adArray;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
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


#pragma mark---UITableViewDelegate

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
//UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 343)];
//view.backgroundColor = [UIColor redColor];
//self.tableView.tableHeaderView = view;

//       return view;
//}


//自定义tableView头部
- (void)configTableViewHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 343)];
    //添加轮播图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 186)];
    self.scrollView.contentSize = CGSizeMake(self.adArray.count * kWidth, 186);
    //整屏滑动
    self.scrollView.pagingEnabled = YES;
    //不显示水平方向的滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    //创建小圆点
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 186 - 30, kWidth, 30)];
    self.pageControl.numberOfPages = self.adArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    [self.pageControl addTarget:self action:@selector(pageSelectAction) forControlEvents:UIControlEventValueChanged];
    
    for (int i = 0; i < self.adArray.count; i ++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 186)];
        [imageview sd_setImageWithURL:self.adArray[i] placeholderImage:nil];
        [self.scrollView addSubview:imageview];
        
    }
    [headerView addSubview:self.scrollView];
    [headerView addSubview:self.pageControl];
    
    
    //button
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kWidth / 4, 186, kWidth / 4, kWidth / 4);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i + 1]] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(activityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
    }
    
    //精选活动&热门专题
   
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 186 + kWidth / 4, kWidth / 2, 343 - 186 - kWidth / 4);
        [btn1 setImage:[UIImage imageNamed:@"home_huodong"]forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(goodActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn1];
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(kWidth / 2, 186 + kWidth / 4, kWidth / 2, 343 - 186 - kWidth / 4);
        [btn2 setImage:[UIImage imageNamed:@"home_zhuanti"]forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(hotActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn2];
    
    
    
    self.tableView.tableHeaderView = headerView;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
  UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 160, 5, 320, 16)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityViewController *activityVC = [[ActivityViewController alloc]init];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}

#pragma mark---button method
- (void)selectCityAction:(UIBarButtonItem *)barBtn{
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc]init];
    [self.navigationController presentViewController:selectCityVC animated:YES completion:nil];
}
- (void)searchActivityAction:(UIBarButtonItem *)barBtn{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
//分类列表
- (void)activityButtonAction:(UIButton *)btn{
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc]init];
    [self.navigationController pushViewController:classifyVC animated:YES];
}
//精选活动
- (void)goodActivityButtonAction:(UIButton *)btn{
    GoodActivityViewController *goodVC = [[GoodActivityViewController alloc]init];
    [self.navigationController pushViewController:goodVC animated:YES];
}
//热门专题
- (void)hotActivityButtonAction:(UIButton *)btn{
    HotActivityViewController *hotVC = [[HotActivityViewController alloc]init];
    [self.navigationController pushViewController:hotVC animated:YES];
}


#pragma mark---网络请求
- (void)requestModel{

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = kMainDataList;
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
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
        WYLog(@"%@", error);
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
#pragma mark-----首页轮播图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //第一步：获取scrollView页面的宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //第二步：获取scrollview停止时候的偏移量
    CGPoint offset = self.scrollView.contentOffset;
    //第三步：通过偏移量和页面宽度计算当前页数
    NSInteger pageNum = offset.x / pageWidth;
    //
    self.pageControl.currentPage = pageNum;
}

- (void)pageSelectAction{
    NSInteger pageNum = self.pageControl.currentPage;
    CGFloat pageWidth = self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(pageNum * pageWidth, 0);
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
