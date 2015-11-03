//
//  MainTabBarController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavController.h"
#import "VideoFrequencyViewController.h"
#import "ShopViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载子控制器
    [self _createSubController];
    
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeftIndexPath:) name:kLeftTabbarSelected object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:kNavButtonSelected object:nil];

}

- (void)changeLeftIndexPath:(NSNotification *)notification {
    NSIndexPath *path = (NSIndexPath *)notification.object;
    
    if (path.row == 2) {
        VideoFrequencyViewController *video = [[VideoFrequencyViewController alloc] init];
        video.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:video];
        [self presentViewController:navC animated:YES completion:nil];
    }
    else if (path.row == 4){
        ShopViewController *shop = [[ShopViewController alloc] init];
        shop.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:shop];
        [self presentViewController:navC animated:YES completion:nil];
    }
    else
    {
        self.selectedIndex = path.row;
        [[NSNotificationCenter defaultCenter] postNotificationName:kViewControllerChanged object:nil];
    }
    
}

//- (void)changeRightIndexPath:(NSNotification *)notification {
//    
//    NSIndexPath *path = notification.object;
//    self.selectedIndex = path.row+6;
//    [[NSNotificationCenter defaultCenter] postNotificationName:kViewControllerChanged object:nil];
//    
//}

- (void)changeView:(NSNotification *)notification {
    
    NSString *str = notification.object;
    
    if ([str isEqualToString:@"0"]) {
        [UIView animateWithDuration:.6 animations:^{
            int viewNum = 3;
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
            self.selectedIndex = viewNum;
        }];
    }
    else{
        [UIView animateWithDuration:.6 animations:^{
            
            int viewNum = 0;
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            self.selectedIndex = viewNum;
        }];
    }
    

}


//加载子控制器
- (void)_createSubController {
    
    NSArray *controllerNames = @[@"Recommend",@"SolarTerm",@"Video",@"Magazine",@"Shop"];
    NSMutableArray *navArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (int i = 0 ; i < 5 ; i++) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:controllerNames[i] bundle:nil];
        BaseNavController *nav = [storyBoard instantiateInitialViewController];
        [navArray addObject:nav];
        
    }
    self.tabBar.hidden = YES;
    self.viewControllers = navArray;
    
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
