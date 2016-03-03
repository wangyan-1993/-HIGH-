//
//  SelectCityViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "SelectCityViewController.h"
#import "City.h"
#import "DataBaseManager.h"
@interface SelectCityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *allArray;
@property(nonatomic, strong) UILabel *labelCity;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"切换城市";    
    self.navigationController.navigationBar.barTintColor = mainColor;
    [self showBackBtnWithImage:@"camera_cancel_up"];
    [self.view addSubview:self.collectionView];
    [self configData];
    //创建数据库管理对象
    DataBaseManager *dataBaseManager = [DataBaseManager shareInatance];
    //创建数据库
    [dataBaseManager openDataBase];

}
- (void)backBtnAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark---解析数据
- (void)configData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:kSelectCity parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@", responseObject);
        NSDictionary *dictionary = responseObject;
        NSString *string = dictionary[@"status"];
        if ([string isEqualToString:@"success"] && ([dictionary[@"code"] integerValue] == 0)) {
            NSDictionary *dic = dictionary[@"success"];
            NSArray *array = dic[@"list"];
            for (NSDictionary *dict in array) {
                City *city = [[City alloc]initWithDictionary:dict];
                [self.allArray addObject:city];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark---lazy loading
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //创建一个layout布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向,垂直方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个item的大小
        //layout.itemSize = CGSizeMake(kWidth/3-10, 50);
        //每一行的间距
        layout.minimumLineSpacing = 1;
        //item的间距
        layout.minimumInteritemSpacing = 1;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
        //通过一个layout布局来创建一个collectionView
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        //设置代理
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.6];
        
        //注册item类型
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"city"];
        //注册区头
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [[NSMutableArray alloc]init];
    }
    return _allArray;
}
#pragma mark---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"city" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    City *city = self.allArray[indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth/3-1, kWidth/6)];
    label.text = city.name;
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    return cell;
}
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    [dbManager deleteCity];
    City *city = self.allArray[indexPath.row];
    [dbManager insertIntoCity:city];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kWidth / 3 - 1, kWidth / 6);
}
//设置头部，尾部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *city =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    city.text = @"   当前定位城市";
    city.font = [UIFont systemFontOfSize:15];
    city.textColor = [UIColor darkGrayColor];
    city.backgroundColor= [UIColor whiteColor];
    [reusableView addSubview:city];


    self.labelCity =[[UILabel alloc]initWithFrame:CGRectMake(0, 45, kWidth, 44)];
    self.labelCity.textColor =[UIColor blackColor];
    self.labelCity.backgroundColor = [UIColor whiteColor];
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    City *cityModel = [dbManager selectAllCity];

    self.labelCity.text = [NSString stringWithFormat:@"  %@", cityModel.name];
    
    
    
    [reusableView addSubview:self.labelCity];
    UIButton *btnCity = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCity.frame = CGRectMake(kWidth/4*3+10, 52, kWidth/4-20, 30);
    btnCity.backgroundColor = mainColor;
    [btnCity setTitle:@"重新定位" forState:UIControlStateNormal];
    [btnCity addTarget:self action:@selector(dingwei) forControlEvents:UIControlEventTouchUpInside];
    [reusableView addSubview:btnCity];

    UILabel *selectCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 94, kWidth, 44)];
    selectCityLabel.text = @"   选择城市";
    selectCityLabel.font = [UIFont systemFontOfSize:15];
    selectCityLabel.textColor = [UIColor darkGrayColor];
    selectCityLabel.backgroundColor = [UIColor whiteColor];
    [reusableView addSubview:selectCityLabel];
    return reusableView;
}
#pragma mark ---UICollectionViewDelegateFlowLayout

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kWidth, 138};
    return size;
}
#pragma mark---btn method
- (void)dingwei{
    NSString *city = [[NSUserDefaults standardUserDefaults]valueForKey:@"city"];
    self.labelCity.text = city;
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
