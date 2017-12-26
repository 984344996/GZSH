//
//  MessageViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/24.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "MessageViewController.h"
#import "JKTopBottomViewCoordinator.h"
#import "CustomAniamtionViewController.h"

@interface MessageViewController ()
@property (nonatomic, strong) JKTopBottomViewCoordinator *coordinator;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coordinator = [[JKTopBottomViewCoordinator alloc] init];
    self.coordinator.topView = self.navigationController.navigationBar;
    self.coordinator.bottomView = self.tabBarController.tabBar;
    self.coordinator.scrollView = self.tableView;
    self.coordinator.topViewMinisedHeight = 0;
    [self.coordinator startMonitoring];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - overrite
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self presentViewController:[[CustomAniamtionViewController alloc] init] animated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.coordinator scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.coordinator scrollViewDidScroll:scrollView];
    NSLog(@"uitableView inset %@ offset %@",[NSValue valueWithUIEdgeInsets:self.tableView.contentInset],[NSValue valueWithCGPoint:self.tableView.contentOffset]);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.coordinator scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark -  没有数据配置
- (UIImage *)emptyImage{
    return [UIImage imageNamed:@""];
}

- (NSString *)emptyTitle{
    return @"暂时没有消息";
}

-(NSString *)emptyDescription{
    return @"快去邀请好友一起互动吧！";
}

- (NSString *)emptyButtonTitle{
    return @"去添加好友";
}

@end
