//
//  MoreTableView.m
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MoreTableView.h"
#import "MoreTableViewCell.h"
#import "AppDelegate.h"
@interface MoreTableView ()<UITableViewDataSource,UITableViewDelegate,WBHttpRequestDelegate>


@end


@implementation MoreTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
        [self registerClass:[MoreTableViewCell class] forCellReuseIdentifier:@"MoreTableViewCell"];
    }
    
    return self;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *arr = @[@"会员与订阅",@"功能设置"];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kScreenWidth, 34)];
    
    label.text = arr[section];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:18 weight:.5];
    
    label.textColor = [UIColor lightGrayColor];
    
    return label;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 54;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreTableViewCell"];
    
    
    NSArray *arr = @[@[@"登陆",@"免费订阅"],
                     @[@"清除缓存",@"文章页使用较大字体",@"首页焦点图自动轮播"]
                     ];
    cell.label.text = arr[indexPath.section][indexPath.row];
    cell.label.textAlignment = NSTextAlignmentLeft;
    
    UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(290, 15, 60, 20)];
    
    [switchButton setOn:YES animated:YES];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-200, 5, 190, 54)];
    warnLabel.text = [NSString stringWithFormat:@"当前缓存大小:%.2fMB",[self countCacheFileSize]];
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.textColor = [UIColor lightGrayColor];
    warnLabel.numberOfLines = 0;
    warnLabel.font = [UIFont systemFontOfSize:16];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell.contentView addSubview:warnLabel];
    }
    
    if (indexPath.section == 1 && indexPath.row ==1 ) {
        [switchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:switchButton];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        [switchButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:switchButton];
    }
    
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {

        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"清除缓存时,您下载的杂志也将会被清除,是否确定清除缓存。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aler show];
        
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self withTag:@"user1"];
    }
    
}
-(CGFloat)countCacheFileSize{
    NSString *homePath=NSHomeDirectory();
    NSLog(@"%@",homePath);
    
    
    NSArray *arr=@[@"/library/Caches/ll.Project4/fsCachedData",
                   @"/library/Caches/default/com.hackemist.SDWebImageCache.default"];
    CGFloat fileSize=0;
    for (NSString *str in arr) {
        NSString *filePath=[homePath stringByAppendingPathComponent:str];
        
        fileSize+=[self getFileSize:filePath];
        
    }
    
    return fileSize ;
}


-(CGFloat)getFileSize:(NSString*)filePath{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *fileNames=[manager subpathsOfDirectoryAtPath:filePath error:nil];
    long long size=0;
    
    for (NSString *fileName in fileNames) {
        NSString *subFilePath=[filePath stringByAppendingPathComponent:fileName];
        NSDictionary *dic=[manager attributesOfItemAtPath:subFilePath error:nil];
        NSNumber *num=dic[NSFileSize];
        long long subFileSize=[num longLongValue];
        size+=subFileSize;
        
    }
    
    return size/1024.0/1024;
}

//清理缓存
-(void)clearCacheFile{
            NSString *homePath=NSHomeDirectory();
            NSLog(@"%@",homePath);
    
    
            NSArray *arr=@[@"/library/Caches/ll.Project4/fsCachedData",
                           @"/library/Caches/default/com.hackemist.SDWebImageCache.default"];
    
            for (NSString *str in arr) {
                NSString *filePath=[homePath stringByAppendingPathComponent:str];
                NSFileManager *manager=[NSFileManager defaultManager];
                NSArray *fileNames=[manager subpathsOfDirectoryAtPath:filePath error:nil];
                for (NSString *fileName in fileNames) {
                    NSString *subFilePath=[filePath stringByAppendingPathComponent:fileName];
                    [manager removeItemAtPath:subFilePath error:nil];
                }
    
            }
    
            NSMutableArray *IDarray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kMagazineID]];
            [IDarray removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setObject:IDarray forKey:kMagazineID];
    //[self reloadRowsAtIndexPaths: withRowAnimation:<#(UITableViewRowAnimation)#>];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // NSLog(@"%ld",buttonIndex);
    if (buttonIndex==1) {
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth/2-25,kScreenHeight/2-25, 50, 50)];
        
        
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        activityView.backgroundColor=[UIColor blackColor];
        activityView.alpha=0.3;
        [activityView startAnimating];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [activityView stopAnimating];
            [self clearCacheFile];
            [self reloadData];
//        });
//        [self addSubview:activityView];
        
        
        //        [self clearCacheFile];
    }
}




- (void)buttonAction:(UISwitch *)button {
    UISwitch *switchButton = button;
    
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        
        NSLog(@"大字体");
    }
    else{
        NSLog(@"小字体");
    }
    
    
    
}
- (void)switchButtonAction:(UISwitch *)button {
    UISwitch *switchButton = button;
    
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        
        NSLog(@"轮播");
    }
    else{
        NSLog(@"不轮播");
    }
    
    
    
}



@end
