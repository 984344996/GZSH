//
//  CustomAniamtionViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/15.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "CustomAniamtionViewController.h"

@interface CustomAniamtionViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIButton *btnBack;
@end

@implementation CustomAniamtionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)configView{
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 40)];
    [_btnBack addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack setTitle:@"BACK" forState:UIControlStateNormal];
    [self.view addSubview:_btnBack];
}

-(void)btnTapped:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
