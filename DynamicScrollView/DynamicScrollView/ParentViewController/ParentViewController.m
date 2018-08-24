//
//  ParentViewController.m
//  DynamicScrollView
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ParentViewController.h"
#import "UIView+Layout.h"
@interface ParentViewController ()
@property (nonatomic , strong) UISegmentedControl *segmentedControl;
@property (nonatomic , strong) UIScrollView *scrollView;
@end

@implementation ParentViewController

#pragma mark - lazyload
- (UISegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"vc1",@"vc2",@"vc3"]];
        _segmentedControl.frame = CGRectMake(0, 0, self.view.width, 35);
        [_segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, self.view.width, self.view.height - 35)];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self addObservers];
}

#pragma mark - UI
- (void)initUI{
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.scrollView];
    [self addChildrenControllers];
}

- (void)addChildrenControllers{
    self.scrollView.contentSize = CGSizeMake(self.view.width *_childrenControllers.count, 0);
    NSInteger idx = 0;
    for (UIViewController*vc in _childrenControllers) {
        vc.view.frame = CGRectMake(self.scrollView.width *idx,0,self.scrollView.width,self.view.height - [UIApplication sharedApplication].statusBarFrame.size.height - 35);
        [self.scrollView addSubview:vc.view];
        [self addChildViewController:vc];
        idx ++;
    }
}

- (void)addObservers{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.childrenControllers[0] action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - other
- (void)change:(UISegmentedControl *)seg{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * seg.selectedSegmentIndex, 0) animated:YES];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateChanged) {
        
    }
}


@end
