//
//  SHEnterpriseViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/26.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHEnterpriseViewController.h"
#import "SHAddressViewController.h"
#import "AddressTableViewHeader.h"
#import "AddressTableViewCell.h"
#import <ReactiveObjC.h>
#import <MJExtension.h>
#import <JKCategories.h>
#import "EnterpriseModelExt.h"
#import "NSString+Commen.h"
#import "ObjectPingSortHelper.h"
#import "PersonalInfoViewController.h"
#import "MyCompanyInfoViewController.h"
#import "APIServerSdk.h"
#import "MyCompanyInfoViewController.h"

@interface SHEnterpriseViewController ()
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

@implementation SHEnterpriseViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.title = @"企业库";
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
    [APIServerSdk doGetUserEnterprise:^(id obj) {
        @strongify(self);
        self.allModes = [EnterpriseModelExt mj_objectArrayWithKeyValuesArray:obj];
        [self sortModels];
    } needCache:YES cacheSucceed:^(id obj) {
        @strongify(self);
        self.allModes = [EnterpriseModelExt mj_objectArrayWithKeyValuesArray:obj];
        [self sortModels];
    } failed:^(NSString *error) {
    }];
}


#pragma mark - Private methods
- (void)sortModels{
    self.sortedModes = [self.helper sortObjects:self.allModes key:@"name"];
    self.letterModes = self.helper.sortedLetters;
    [self.tableView reloadData];
}

- (void)intoEnterpriseInfo:(NSIndexPath *)indexPath{
    EnterpriseModelExt *modelExt;
    if (self.filter) {
        modelExt  = self.filterModes[indexPath.row];
    }else{
        modelExt = self.sortedModes[indexPath.section][indexPath.row];
    }
    EnterpriseModel *model = [EnterpriseModel mj_objectWithKeyValues:modelExt.mj_keyValues];
    MyCompanyInfoViewController *vc =  [[MyCompanyInfoViewController alloc] initWithEnterpriseModel:model isSelf:NO];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)filerKey:(NSString *)key{
    /// 企业名 拼音 电话 用户名 对比
    [self.filterModes removeAllObjects];
    for (int i = 0; i < self.sortedModes.count; i++) {
        NSMutableArray *array = self.sortedModes[i];
        for (int j = 0; j < array.count; j++) {
            EnterpriseModelExt *contact = array[j];
            NSString *keyUpper =  [key uppercaseString];
            if ([contact.name containsString:key]) {
                [self.filterModes addObject:contact];
                continue;
            }
            if ([contact.pingyin containsString:key]) {
                [self.filterModes addObject:contact];
                continue;
            }
            if ([contact.userMobile containsString:keyUpper]) {
                [self.filterModes addObject:contact];
                continue;
            }
            if ([contact.username containsString:keyUpper]) {
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
    EnterpriseModelExt *enterprise;
    if (self.filter) {
        enterprise = self.filterModes[indexPath.row];
    }else{
        NSArray *array = self.sortedModes[indexPath.section];
        enterprise = array[indexPath.row];
    }
    [cell setupCellDataEnterprise:enterprise];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self intoEnterpriseInfo:indexPath];
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
