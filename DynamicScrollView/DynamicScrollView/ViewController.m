//
//  ViewController.m
//  DynamicScrollView
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ParentViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "UIView+Layout.h"

@interface ViewController ()

@property (nonatomic , strong) ParentViewController *parentVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}



- (void)initUI{
    _parentVc = [[ParentViewController alloc] init];
    _parentVc.childrenControllers = @[[ViewController1 new],[ViewController2 new],[ViewController3 new]];
    [self addChildViewController:_parentVc];
    _parentVc.view.y = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.view addSubview:_parentVc.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
