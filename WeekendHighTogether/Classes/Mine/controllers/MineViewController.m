//
//  MineViewController.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *headImageBtn;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UILabel *nikeNameLabel;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self setHeaderView];
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.imageArray = @[@"clear", @"return", @"share", @"user", @"now"];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存", @"用户反馈", @"分享给好友", @"给我评分", @"当前版本", nil];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%.2fM)", (CGFloat)cacheSize / 1024 / 1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"mine";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark----UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
            
            
        default:
            break;
    }
    
}
#pragma mark--自定义
- (void)setHeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    headView.backgroundColor = mainColor;
    self.tableView.tableHeaderView = headView;
    self.headImageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.headImageBtn.frame=CGRectMake(20, 40, kWidth/3, kWidth/3);
    self.headImageBtn.layer.cornerRadius=kWidth/6;
    self.headImageBtn.clipsToBounds=YES;
    [self.headImageBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.headImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.headImageBtn.backgroundColor=[UIColor whiteColor];
    [self.headImageBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.headImageBtn];
    [headView addSubview:self.nikeNameLabel];
}

- (void)login{
    
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeigth - 64 - 44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 80;
        
    }
    return _tableView;
}

- (UILabel *)nikeNameLabel{
    if (_nikeNameLabel == nil) {
        self.nikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 80, kWidth - 200, 40)];
        self.nikeNameLabel.text = @"欢迎来到Hi周末";
        self.nikeNameLabel.textColor = [UIColor whiteColor];
        self.nikeNameLabel.numberOfLines = 0;
    }
    return _nikeNameLabel;
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
