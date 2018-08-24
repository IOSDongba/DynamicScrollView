//
//  ViewController1.m
//  DynamicScrollView
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController1.h"
#import "UIView+Layout.h"
#import "DynamicItem.h"

@interface ViewController1 ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat _oldOffset;
}

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIDynamicAnimator *animator;

@end

@implementation ViewController1

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

-(UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
    }
    return _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor orangeColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.animator removeAllBehaviors];
            _oldOffset = self.tableView.contentOffset.y;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
            NSLog(@"%lf",translation.y);
            [self.tableView setContentOffset:CGPointMake(0, _oldOffset - translation.y) animated:NO];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //手势结束后的x，y方向上的速度，用来模拟惯性效果.
            //当前的点
            CGPoint currentTranslation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
            CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
            CGFloat maxTableViewContentOffSet = self.tableView.contentSize.height - self.view.height + 35;
            NSLog(@"velocity: %lf",velocity.y);
            NSLog(@"contentOffSet: %lf",_oldOffset - currentTranslation.y);
            
            DynamicItem *item = [ DynamicItem new];
            item.center = CGPointMake(0, _oldOffset - currentTranslation.y);
            
            if (item.center.y < 0){
                UIAttachmentBehavior * bouncesBehavior = [[UIAttachmentBehavior alloc] initWithItem: item attachedToAnchor : CGPointZero];
                bouncesBehavior.length = 0;
                bouncesBehavior.damping = 1;
                bouncesBehavior.frequency = 1.6;
                bouncesBehavior.action = ^{
                    CGFloat itemTop = item.center.y;
                    self.tableView.contentOffset = CGPointMake(0,itemTop);
                };
                [self.animator addBehavior:bouncesBehavior];
            }else if (item.center.y > maxTableViewContentOffSet){
                UIAttachmentBehavior * bouncesBehavior = [[UIAttachmentBehavior alloc] initWithItem: item attachedToAnchor : CGPointMake(0,maxTableViewContentOffSet)];
                bouncesBehavior.length = 0;
                bouncesBehavior.damping = 1;
                bouncesBehavior.frequency = 1.6;
                bouncesBehavior.action = ^{
                    CGFloat itemTop = item.center.y;
                    self.tableView.contentOffset = CGPointMake(0,itemTop);
                };
                [self.animator addBehavior:bouncesBehavior];
            }else{
                UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ item ]];
                [inertialBehavior addLinearVelocity:CGPointMake(0, -velocity.y) forItem:item];
                inertialBehavior.resistance = 2.0;
                inertialBehavior.action = ^{
                    CGFloat itemTop = item.center.y;
                    if (velocity.y > 0){
                        self.tableView.contentOffset = CGPointMake(0,MAX(itemTop,0));
                    }else{
                        self.tableView.contentOffset = CGPointMake(0, MIN(itemTop,maxTableViewContentOffSet));
                    }
                };
                [self.animator addBehavior:inertialBehavior];
            }
        }
            break;
            
        default:
            break;
    }
}


@end
