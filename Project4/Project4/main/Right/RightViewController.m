//
//  RightViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "RightViewController.h"
#import "CommunityViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "CollectViewController.h"
#import "NotificationViewController.h"
#import "MyhomeViewController.h"
#import "BaseNavController.h"
#import "UIViewController+MMDrawerController.h"
#import "FollowerViewController.h"
#import "UserInfoViewController.h"


@interface RightViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    UIView *cellView;
    int _index;
    MMDrawerController *_mmDraw;
    NSMutableData *_receiveData;
    UILabel *_noteNumLabel;
    UILabel *_notelabel;
    UILabel *_followsNumLabel;
    UILabel *_fansNumLabel;
    UILabel *_userNameLabel;
    UIImageView *_userHeaderImage;
}

@end

@implementation RightViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //BaseNavController *baseNav = [[BaseNavController alloc] initWithRootViewController:self];
    _index = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
    
    [self _loadData];
    
    [self _createSubViews];
    [self _loadURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexChange:) name:kLeftTabbarSelected object:nil];
}



-(void)indexChange:(NSNotification *)noti
{
    NSIndexPath *path = noti.object;
    
    if (path.row == 2) {
    }
    else if (path.row == 4){
        
    }
    
    else if (path.row != 0 && path.row != 1) {
        _index = 0;
    }
    else{
        _index = (int)path.row;
    }
}


- (void)_createSubViews {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 300, kScreenHeight)];
    _tableView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    [self.view addSubview:_tableView];
    
    
    //设置头视图
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 260)];
    
    _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth*0.8-100)/2, 35, 100, 100)];
    _userHeaderImage.layer.cornerRadius = 50;
    _userHeaderImage.layer.masksToBounds = YES;
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth*0.8, 30)];
    
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    _userNameLabel.font = [UIFont systemFontOfSize:16 weight:.1];
    [_headView addSubview:_userNameLabel];
    
    
    
    UIButton *noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    noteButton.frame = CGRectMake((kScreenWidth*0.8-40)/2-80, 190, 40, 50);
    noteButton.backgroundColor = [UIColor clearColor];
    [noteButton addTarget:self action:@selector(noteAction) forControlEvents:UIControlEventTouchUpInside];
    _noteNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    //_noteNumLabel.text = @"???";
    _noteNumLabel.textAlignment = NSTextAlignmentCenter;
    _noteNumLabel.font = [UIFont systemFontOfSize:18 weight:.5];
    _notelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 40, 20)];
    _notelabel.text = @"笔记";
    _notelabel.textAlignment = NSTextAlignmentCenter;
    _notelabel.font = [UIFont systemFontOfSize:12 weight:.2];
    [noteButton addSubview:_notelabel];
    [noteButton addSubview:_noteNumLabel];
    
    
    UIButton *followsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followsButton.frame = CGRectMake((kScreenWidth*0.8-40)/2, 190, 40, 50);
    followsButton.backgroundColor = [UIColor clearColor];
    [followsButton addTarget:self action:@selector(followsAction) forControlEvents:UIControlEventTouchUpInside];
    _followsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    //_followsNumLabel.text = @"???";
    _followsNumLabel.textAlignment = NSTextAlignmentCenter;
    _followsNumLabel.font = [UIFont systemFontOfSize:18 weight:.5];
    UILabel *followsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 40, 20)];
    followsLabel.text = @"关注";
    followsLabel.textAlignment = NSTextAlignmentCenter;
    followsLabel.font = [UIFont systemFontOfSize:12 weight:.2];
    [followsButton addSubview:followsLabel];
    [followsButton addSubview:_followsNumLabel];
    
    
    UIButton *fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fansButton.frame = CGRectMake((kScreenWidth*0.8-40)/2+80, 190, 40, 50);
    fansButton.backgroundColor = [UIColor clearColor];
    [fansButton addTarget:self action:@selector(fansAction) forControlEvents:UIControlEventTouchUpInside];
    _fansNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    //_fansNumLabel.text = @"???";
    _fansNumLabel.textAlignment = NSTextAlignmentCenter;
    _fansNumLabel.font = [UIFont systemFontOfSize:18 weight:.5];
    UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 40, 20)];
    fansLabel.text = @"粉丝";
    fansLabel.textAlignment = NSTextAlignmentCenter;
    fansLabel.font = [UIFont systemFontOfSize:12 weight:.2];
    [fansButton addSubview:fansLabel];
    [fansButton addSubview:_fansNumLabel];
    
    
    [_headView addSubview:_userHeaderImage];
    [_headView addSubview:followsButton];
    [_headView addSubview:noteButton];
    [_headView addSubview:fansButton];
    _tableView.tableHeaderView = _headView;
    
    
    
}

- (void)_loadURL {
    
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/login"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyStr = @"username=736410133@qq.com&password=1e6884248ecba26ca94035a5d2296d79";
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
}

- (void)_loadData {
    
    _titleNames = @[@"我的首页",@"浏览发现",@"通知中心",@"乐活社区",@"收藏夹",@"设置"];
    _titleImages = @[@"ico_rightmenu1@2x",@"ico_rightmenu2@2x",@"ico_rightmenu3@2x",@"ico_rightmenu4@2x",@"ico_rightmenu5@2x",@"ico_rightmenu6@2x"];
    
    
}
- (void)noteAction {
    
    _mmDraw = (MMDrawerController *)self.parentViewController;
    UITabBarController *tabbar = (UITabBarController *)_mmDraw.centerViewController;
    NSArray *viewControllers = tabbar.viewControllers;
    
    UINavigationController *navC = (UINavigationController *)viewControllers[_index];
    
    UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
    userInfo.uid = @"5281";
    [navC.topViewController.navigationController pushViewController:userInfo animated:YES];
    [_mmDraw closeDrawerAnimated:YES completion:nil];
}

- (void)followsAction {
    
    _mmDraw = (MMDrawerController *)self.parentViewController;
    UITabBarController *tabbar = (UITabBarController *)_mmDraw.centerViewController;
    NSArray *viewControllers = tabbar.viewControllers;
    
    UINavigationController *navC = (UINavigationController *)viewControllers[_index];
    
    FollowerViewController *followVC = [[FollowerViewController alloc] init];
    followVC.isfans = NO;
    followVC.uid = @"5281";
    followVC.title = @"我的关注";
    [navC.topViewController.navigationController pushViewController:followVC animated:YES];
    [_mmDraw closeDrawerAnimated:YES completion:nil];
}

- (void)fansAction {
    
    _mmDraw = (MMDrawerController *)self.parentViewController;
    UITabBarController *tabbar = (UITabBarController *)_mmDraw.centerViewController;
    NSArray *viewControllers = tabbar.viewControllers;
    
    UINavigationController *navC = (UINavigationController *)viewControllers[_index];
    
    FollowerViewController *followVC = [[FollowerViewController alloc] init];
    followVC.isfans = YES;
    followVC.title = @"粉丝";
    followVC.uid = @"5281";
    [navC.topViewController.navigationController pushViewController:followVC animated:YES];
    [_mmDraw closeDrawerAnimated:YES completion:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _titleImages.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RightCell"];
        
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titleImages.count; i++) {
        cellView = [[UIView alloc] initWithFrame:cell.bounds];
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 15, 20, 20)];
        titleImageView.image = [UIImage imageNamed:_titleImages[i]];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(125, 15, 100, 20)];
        label.text = _titleNames[i];
        label.font = [UIFont systemFontOfSize:16 weight:.6];
        [cellView addSubview:titleImageView];
        [cellView addSubview:label];
        
        [arr addObject:cellView];
        
    }
    
    cell.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
    cell.backgroundView = arr[indexPath.row];
    
    
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _mmDraw = (MMDrawerController *)self.parentViewController;
    UITabBarController *tabbar = (UITabBarController *)_mmDraw.centerViewController;
    NSArray *viewControllers = tabbar.viewControllers;
    
    UINavigationController *navC = (UINavigationController *)viewControllers[_index];
    
    if (indexPath.row == 0 ) {
        
        MyhomeViewController *home = [[MyhomeViewController alloc] init];
        home.urlStr = @"http://api.ilohas.com/club/myhome";
        home.bodyStr= @"token=668347be401c6500aea15598fbce8fab&pagesize=10";
        home.isUnnormal = NO;
        home.title = @"我的首页";
        
        [navC.topViewController.navigationController pushViewController:home animated:YES];
        
    }
    else if(indexPath.row == 1) {
        
        MyhomeViewController *Discoverhome = [[MyhomeViewController alloc] init];
        Discoverhome.urlStr = @"http://api.ilohas.com/club/note_list";
        Discoverhome.bodyStr = @"pagesize=10";
        Discoverhome.isUnnormal = NO;
        Discoverhome.title = @"广场";
        [navC.topViewController.navigationController pushViewController:Discoverhome animated:YES];
        
    }
    else if(indexPath.row == 2) {
        
        NotificationViewController *notification = [[NotificationViewController alloc ] init];
        
        [navC.topViewController.navigationController pushViewController:notification animated:YES];
        
    }
    else if(indexPath.row == 3) {
        
        CommunityViewController *community = [[CommunityViewController alloc] init];
        UINavigationController *CommunitynavC = [[UINavigationController alloc] initWithRootViewController:community];
        
        [navC.topViewController presentViewController:CommunitynavC animated:YES completion:nil];
        
    }
    else if(indexPath.row == 4) {
        
        CollectViewController *collect = [[CollectViewController alloc] init];
        
        [navC.topViewController.navigationController pushViewController:collect animated:YES];
        
    }
    else{
        MoreViewController *more = [[MoreViewController alloc] init];
        
        [navC.topViewController.navigationController pushViewController:more  animated:YES];
        
    }
    [_mmDraw closeDrawerAnimated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 50;
}

#pragma mark - 网络请求协议方法

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _receiveData = [[NSMutableData alloc] init];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_receiveData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];
    [self _loadDatas:dictionary];
    
}

- (void)_loadDatas:(NSDictionary *)dictionary {
    
    NSDictionary *dic = dictionary[@"content"];
    // NSLog(@"%@",dic);
    
    _noteNumLabel.text = dic[@"note_total"];
    _followsNumLabel.text = dic[@"follows"];
    _fansNumLabel.text = dic[@"fans"];
    _userNameLabel.text = dic[@"username"];
    NSURL *url = [NSURL URLWithString:dic[@"avatar"]];
    [_userHeaderImage sd_setImageWithURL:url];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






@end
