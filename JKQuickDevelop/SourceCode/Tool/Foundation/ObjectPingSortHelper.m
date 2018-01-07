//
//  ObjectPingSortHelper.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ObjectPingSortHelper.h"
#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"
#import "SortBaseObject.h"

@implementation ObjectPingSortHelper

- (NSMutableArray *)sortObjects:(NSMutableArray<SortBaseObject *> *)objects key:(NSString *)keyPath{
    self.objectsToSort = [objects copy];
    self.sortedLetters = nil;
    self.sortedObjects = nil;
    
    HanyuPinyinOutputFormat *formatter = [[HanyuPinyinOutputFormat alloc] init];
    formatter.caseType = CaseTypeLowercase;
    formatter.vCharType = VCharTypeWithV;
    formatter.toneType = ToneTypeWithoutTone;
    
    BOOL hasSpecial = NO;
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    for(SortBaseObject * obj in objects){
        NSString *key = [obj valueForKeyPath:keyPath];
        NSString *outputPing = [PinyinHelper toHanyuPinyinStringWithNSString:key withHanyuPinyinOutputFormat:formatter withNSString:@""];
        NSString *letter = [[outputPing substringToIndex:1] uppercaseString];
        [obj setLetter:letter];
        if ([letter characterAtIndex:0] >= 'A' && [letter characterAtIndex:0] <= 'Z') {
            [obj setLetterShow:letter];
            [tempDic setObject:obj forKey:letter];
        }else{
            [obj setLetterShow:@"#"];
            hasSpecial = YES;
        }
    }
    
    NSArray *allKeys = tempDic.allKeys;
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 characterAtIndex:0] > [obj2 characterAtIndex:0]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 characterAtIndex:0] < [obj2 characterAtIndex:0]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    self.sortedLetters = [NSMutableArray arrayWithArray:allKeys];
    if (hasSpecial) {
        [self.sortedLetters addObject:@"#"];
    }
    
    for (NSString *letter in self.sortedLetters) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.objectsToSort.count; i++) {
            SortBaseObject *obj = self.objectsToSort[i];
            if ([obj.letterShow isEqualToString:letter]) {
                [tempArray addObject:obj];
            }
        }
        [self.sortedObjects addObject:tempArray];
    }
    return self.sortedObjects;
}

#pragma mark - Getter and Setter
- (NSMutableArray *)sortedLetters{
    if (!_sortedLetters) {
        _sortedLetters = [[NSMutableArray alloc] init];
    }
    return _sortedLetters;
}

- (NSMutableArray *)sortedObjects{
    if (!_sortedObjects) {
        _sortedObjects = [[NSMutableArray alloc] init];
    }
    return _sortedObjects;
}

@end
