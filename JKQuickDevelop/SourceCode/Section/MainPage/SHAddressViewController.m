//
//  SHAddressViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHAddressViewController.h"
#import "AddressTableViewHeader.h"
#import "AddressTableViewCell.h"
#import <ReactiveObjC.h>
#import <MJExtension.h>
#import <JKCategories.h>
#import "Contact.h"
#import "ObjectPingSortHelper.h"
#import "PersonalInfoViewController.h"

@interface SHAddressViewController ()
@property (nonatomic, strong) AddressTableViewHeader *header;
@property (nonatomic, strong) NSMutableArray *allModes;
@property (nonatomic, strong) NSMutableArray *sortedModes;
@property (nonatomic, strong) NSMutableArray *letterModes;
@property (nonatomic, strong) NSMutableArray *filterModes;
@property (nonatomic, strong) ObjectPingSortHelper *helper;

//{@"letter":@"A",array:{}}
@property (nonatomic, strong) NSMutableArray *sortedLetterArray;
@end

@implementation SHAddressViewController

#pragma mark - Test Data;

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.tableView.tableHeaderView = self.header;
    self.tableView.sectionHeaderHeight = 29;
    self.tableView.separatorColor = kMainBottomLayerColor;
    self.tableView.sectionIndexBackgroundColor = kMainBottomLayerColor;
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}

- (void)configData{
    [super configData];
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"contact" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"friends"]) {
        [self.allModes addObject:[Contact mj_objectWithKeyValues:eachDic]];
    }
    
    self.sortedModes = [self.helper sortObjects:self.allModes key:@"userName"];
    self.letterModes = self.helper.sortedLetters;
    
    [self.tableView reloadData];
}

- (AddressTableViewHeader *)header{
    if (!_header) {
        _header = [[AddressTableViewHeader alloc] init];
        [_header sizeToFit];
    }
    return _header;
}

- (NSMutableArray *)allModes{
    if (!_allModes) {
        _allModes = [[NSMutableArray alloc] init];
    }
    return _allModes;
}

- (NSMutableArray *)sortedModes{
    if (!_sortedModes) {
        _sortedModes = [[NSMutableArray alloc] init];
    }
    return _sortedModes;
}


- (ObjectPingSortHelper *)helper{
    if (!_helper) {
        _helper = [[ObjectPingSortHelper alloc] init];
    }
    return _helper;
}

- (NSMutableArray *)letterModes{
    if (!_letterModes) {
        _letterModes = [[NSMutableArray alloc] init];
    }
    return _letterModes;
}
#pragma mark - Private methods

- (void)intoPersonInfo{
    PersonalInfoViewController *vc =  [[PersonalInfoViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - Delegate and Datasource
//IOS8 解决左边线间距问题

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 63, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sortedModes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.sortedModes[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    NSArray *array = self.sortedModes[indexPath.section];
    Contact *contact = array[indexPath.row];
    [cell setupCellData:contact];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self intoPersonInfo];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.letterModes[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return  self.letterModes;
}

@end
