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
#import "TableViewCellTest1.h"
#import "TableViewCellTest2.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface MessageViewController ()
@property (nonatomic, strong) JKTopBottomViewCoordinator *coordinator;
@end

@implementation MessageViewController


- (NSDictionary *)modeData{
    return @{
             @"name":@"dengjie dengjie dengjie dengjie dengjie",
             @"avatar":@"avatar"
             };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coordinator = [[JKTopBottomViewCoordinator alloc] init];
    self.coordinator.topView = self.navigationController.navigationBar;
    self.coordinator.bottomView = self.tabBarController.tabBar;
    self.coordinator.scrollView = self.tableView;
    self.coordinator.topViewMinisedHeight = 0;
    [self.coordinator startMonitoring];
    
    [self.tableView registerClass:[TableViewCellTest1 class] forCellReuseIdentifier:@"test1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCellTest2" bundle:nil] forCellReuseIdentifier:@"test2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - overrite
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row % 2) {
        TableViewCellTest1 *test1 = [tableView dequeueReusableCellWithIdentifier:@"test1" forIndexPath:indexPath];
        [test1 configData:[self modeData]];
        cell = test1;
    }else{
        TableViewCellTest2 *test2 = [tableView dequeueReusableCellWithIdentifier:@"test2" forIndexPath:indexPath];
        [test2 configData:[self modeData]];
        cell = test2;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2) {
        return [tableView fd_heightForCellWithIdentifier:@"test1" cacheByIndexPath:indexPath configuration:^(TableViewCellTest1 *cell) {
            [cell configData:[self modeData]];
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:@"test2" cacheByIndexPath:indexPath configuration:^(TableViewCellTest2 *cell) {
            [cell configData:[self modeData]];
        }];
    }
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
