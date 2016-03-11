//
//  MainViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//
#import "AppDelegate.h"
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
//轮播图
@property(nonatomic, strong) UIScrollView *scrollView;
//小圆点
@property(nonatomic, strong) UIPageControl *pageControl;
//定时器用于图片滚动播放
@property(nonatomic, strong) NSTimer *timer;
//精选活动&热门专题
@property(nonatomic, strong) UIButton *button1;
@property(nonatomic, strong) UIButton *button2;
@property(nonatomic, strong) UIBarButtonItem *leftBarBtn;
@property(nonatomic, strong) UIButton *leftBtn;
@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //left
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, 70, 44);
   
    [self.leftBtn setImage:[UIImage imageNamed:@"btn_chengshi"] forState:UIControlStateNormal];
    //调整btn图片的位置
    [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.leftBtn.frame.size.width-25, 0, 0)];
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    City *cityModel = [dbManager selectAllCity];
    NSLog(@"%@", cityModel.name);
    NSLog(@"%@", cityModel.cityID);
  
     [self.leftBtn setTitle:cityModel.name forState:UIControlStateNormal];
   self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];

        [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 10)];
    [self.leftBtn addTarget:self action:@selector(selectCityAction:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    self.leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.leftBarBtn;
    
    //right
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 20, 20);
//    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self configTableViewHeaderView];
    //请求网络数据
    [self requestModel];
    //启动定时器
    [self addTime];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    //self.leftBarBtn.title = @"";
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    City *cityModel = [dbManager selectAllCity];
    NSLog(@"%@", cityModel.name);
    if (cityModel.name == nil) {
        cityModel.name = @"北京";
    }
    [self.leftBtn setTitle:cityModel.name forState:UIControlStateNormal];
    if (cityModel.name.length > 2) {
        [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 10)];
    }else{
        //调整btn标题所在的位置，距离左上右下边界的距离
        [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    }

    
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

//自定义tableView头部
- (void)configTableViewHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 343)];
    self.pageControl.numberOfPages = self.adArray.count;
    for (int i = 0; i < self.adArray.count; i ++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 186)];
        [imageview sd_setImageWithURL:self.adArray[i][@"url"] placeholderImage:nil];
        imageview.userInteractionEnabled = YES;
        UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        touchButton.frame = self.scrollView.frame;
        touchButton.tag = 200 + i;
        [touchButton addTarget:self action:@selector(touchAD:) forControlEvents:UIControlEventTouchUpInside];
        [imageview addSubview:touchButton];
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
    [headerView addSubview:self.button1];
    [headerView addSubview:self.button2];
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
    MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ActivityViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Activity"];
        activityVC.activityId = mainModel.actuvityId;
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        themeVC.themeid = mainModel.actuvityId; 
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}

#pragma mark---button method
- (void)selectCityAction:(UIBarButtonItem *)barBtn{
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:selectCityVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//- (void)searchActivityAction:(UIBarButtonItem *)barBtn{
//    SearchViewController *searchVC = [[SearchViewController alloc]init];
//    [self.navigationController pushViewController:searchVC animated:YES];
//}
//分类列表
- (void)activityButtonAction:(UIButton *)btn{
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc]init];
    classifyVC.classifyListType = btn.tag - 100 + 1;
    
    
    
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
//点击广告
- (void)touchAD:(UIButton *)btn{
    //
    NSString *type = self.adArray[btn.tag - 200][@"type"];
    if ([type integerValue] == 1) {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ActivityViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Activity"];
        activityVC.activityId = self.adArray[btn.tag - 200][@"id"];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        themeVC.themeid = self.adArray[btn.tag - 200][@"id"];
        //推出的时候隐藏TabBar
//        themeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    
    
    
    
}
#pragma mark---网络请求
- (void)requestModel{
    
    
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    City *cityModel = [dbManager selectAllCity];
    NSLog(@"%@", cityModel.name);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];
    if (cityModel.cityID == nil) {
        cityModel.cityID = @"1";
    }
    NSString *url = [NSString stringWithFormat:@"%@%ld&lat=%@&lng=%@", kMainDataList, (long)[cityModel.cityID integerValue], lat, lng];
    WYLog(@"%@", url);
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

            if (self.adArray.count > 0) {
                [self.adArray removeAllObjects];
            }
            if (self.activityArray.count > 0) {
                [self.activityArray removeAllObjects];
            }
            if (self.themeArray.count > 0) {
                [self.themeArray removeAllObjects];
            }
            if (self.listArray.count > 0) {
                [self.listArray removeAllObjects];
            }

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
                NSDictionary *dic = @{@"url":dict[@"url"], @"id":dict[@"id"], @"type":dict[@"type"]};
                [self.adArray addObject:dic];
            }
            //取到数据之后重新刷新headerView
            [self configTableViewHeaderView];
            [self.tableView reloadData];
            
        }else{
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WYLog(@"%@", error);
    }];
   
}
#pragma mark---懒加载
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
//添加轮播图

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 186)];
        self.scrollView.contentSize = CGSizeMake(self.adArray.count * kWidth, 186);
        //整屏滑动
        self.scrollView.pagingEnabled = YES;
        //不显示水平方向的滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        
        
    }
    return _scrollView;
}
//小圆点
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        //创建小圆点
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 186 - 30, kWidth, 30)];
        self.pageControl.numberOfPages = self.adArray.count;
        self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self.pageControl addTarget:self action:@selector(pageSelectAction) forControlEvents:UIControlEventValueChanged];
     }
    return _pageControl;
}
//精选活动
- (UIButton *)button1{
    if (_button1 == nil) {
        self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button1.frame = CGRectMake(0, 186 + kWidth / 4, kWidth / 2, 343 - 186 - kWidth / 4);
        [self.button1 setImage:[UIImage imageNamed:@"home_huodong"]forState:UIControlStateNormal];
        [self.button1 addTarget:self action:@selector(goodActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _button1;
}
//热门专题
- (UIButton *)button2{
    if (_button2 == nil) {
        self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button2.frame = CGRectMake(kWidth / 2, 186 + kWidth / 4, kWidth / 2, 343 - 186 - kWidth / 4);
        [self.button2 setImage:[UIImage imageNamed:@"home_zhuanti"]forState:UIControlStateNormal];
        [self.button2 addTarget:self action:@selector(hotActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _button2;
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
#pragma mark ------轮播图
- (void)addTime{
    //防止定时器重复创建
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(move) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//每两秒执行一次，图片自动轮播
- (void)move{
    //数组元素个数可能为0， 如果为0 的时候没有意义
    if (self.adArray.count > 0) {
    NSInteger rollPage = (self.pageControl.currentPage + 1) % self.adArray.count;
    self.pageControl.currentPage = rollPage;
    //计算scrollView的偏移量
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * kWidth, 0)];
    }
}
//当手动去滑动scrollView的时候，定时器依然在计算时间，可能我们刚刚滑动到下一页，定时器时间刚好触发，导致在当前页停留的时间不到2秒
//解决方案：添加下面两个方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;//停止定时器后并置为nil
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTime];
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
