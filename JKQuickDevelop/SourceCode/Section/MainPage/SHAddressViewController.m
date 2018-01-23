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
#import "NSString+Commen.h"
#import "ObjectPingSortHelper.h"
#import "PersonalInfoViewController.h"
#import "APIServerSdk.h"


@interface SHAddressViewController ()
@property (nonatomic, strong) AddressTableViewHeader *header;
@property (nonatomic, strong) NSMutableArray *allModes;
@property (nonatomic, strong) NSMutableArray *sortedModes;
@property (nonatomic, strong) NSMutableArray *letterModes;
@property (nonatomic, strong) NSMutableArray *filterModes;
@property (nonatomic, strong) ObjectPingSortHelper *helper;
@property (nonatomic, assign) BOOL filter;

//{@"letter":@"A",array:{}}
@property (nonatomic, strong) NSMutableArray *sortedLetterArray;
@end

@implementation SHAddressViewController


#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.tableView.tableHeaderView = self.header;
    self.tableView.separatorColor = kMainBottomLayerColor;
    self.tableView.sectionIndexBackgroundColor = kMainBottomLayerColor;
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}

- (void)configData{
    [super configData];
    [self loadContacts];
}

- (void)configEvent{
    [super configEvent];
    @weakify(self);
    RAC(self,filter) = [[RACSignal merge:@[RACObserve(self.header.inputFilterKey, text),self.header.inputFilterKey.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        NSString *key = value;
        if ([NSString isEmpty:key]) {
            return [NSNumber numberWithBool:NO];
        }else{
            return [NSNumber numberWithBool:YES];
        }
    }];
    
    [[[self.header.inputFilterKey rac_textSignal] distinctUntilChanged] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self filerKey:x];
    }];
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

- (NSMutableArray *)filterModes{
    if (!_filterModes) {
        _filterModes = [[NSMutableArray alloc] init];
    }
    return _filterModes;
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

#pragma mark - APIServer

- (void)loadContacts{
    @weakify(self);
    [APIServerSdk doGetUserContact:^(id obj) {
        @strongify(self);
        self.allModes = [Contact mj_objectArrayWithKeyValuesArray:obj];
        [self sortModels];
    } needCache:YES cacheSucceed:^(id obj) {
        @strongify(self);
        self.allModes = [Contact mj_objectArrayWithKeyValuesArray:obj];
        [self sortModels];
    } failed:^(NSString *error) {
    }];
}


#pragma mark - Private methods
- (void)sortModels{
    self.sortedModes = [self.helper sortObjects:self.allModes key:@"userName"];
    self.letterModes = self.helper.sortedLetters;
    [self.tableView reloadData];
}

- (void)intoPersonInfo{
    PersonalInfoViewController *vc =  [[PersonalInfoViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)filerKey:(NSString *)key{
    /// 用户名 拼音 电话 企业名称 对比
    [self.filterModes removeAllObjects];
    for (int i = 0; i < self.sortedModes.count; i++) {
        NSMutableArray *array = self.sortedModes[i];
        for (int j = 0; j < array.count; j++) {
            Contact *contact = array[j];
            NSString *keyUpper =  [key uppercaseString];
            if ([contact.userName containsString:key]) {
                [self.filterModes addObject:contact];
                continue;
            }
            if ([contact.pingyin containsString:key]) {
                [self.filterModes addObject:contact];
                continue;
            }
            if ([contact.mobile containsString:keyUpper]) {
                [self.filterModes addObject:contact];
                continue;
            }
            if ([contact.enterprise containsString:keyUpper]) {
                [self.filterModes addObject:contact];
                continue;
            }
        }
    }
    [self.tableView reloadData];
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
    if (self.filter) {
        return 1;
    }
    return self.sortedModes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.filter) {
        return self.filterModes.count;
    }
    
    NSArray *array = self.sortedModes[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    Contact *contact;
    if (self.filter) {
        contact = self.filterModes[indexPath.row];
    }else{
        NSArray *array = self.sortedModes[indexPath.section];
        contact = array[indexPath.row];
    }
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
    if (self.filter) {
        return nil;
    }
    return  self.letterModes;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.filter) {
        return 0;
    }
    return 29;
}

@end
