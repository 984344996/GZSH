//
//  HomeViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/24.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "HomeViewController.h"
#import "JKTextField_Padding.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JKTextField_Padding *text = [[JKTextField_Padding alloc] initWithFrame:CGRectMake(10, 100, 100, 40) andLeftPadding:10 andRightPadding:20];
    text.placeholder = @"测试测试";
    //text.layer.borderWidth = 0.5;
    //text.layer.borderColor = [UIColor redColor].CGColor;
    text.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:text];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
