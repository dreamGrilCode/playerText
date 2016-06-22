//
//  ViewController.m
//  YANPlayerTextScrollView
//
//  Created by yan on 16/6/22.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "ViewController.h"
#import "PlayerTextScrollerView.h"

@interface ViewController ()<PlayerTextScrollerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PlayerTextScrollerView *playerView = [[PlayerTextScrollerView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 30)];
    playerView.contentArr = @[@"2345678",@"zxcvbnm",@"wdfghj",@"234567"];
    playerView.delegate_ = self;
    playerView.scrollDirectionPortrait = YES;
    [self.view addSubview:playerView];
}
#pragma mark - PlayerTextScrollerViewDelegate
- (void)playerTextScrollerView:(PlayerTextScrollerView *)playerTextView showInfo:(NSString *)info{

    
}
@end
