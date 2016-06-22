//
//  PlayerTextScrollerView.m
//  ICAHomePhoneInternational
//
//  Created by yan on 16/6/21.
//  Copyright © 2016年 ICA. All rights reserved.
//

#import "PlayerTextScrollerView.h"

static int const textViewCount = 3;
@interface PlayerTextScrollerView()<UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *scrollView;
@property(nonatomic,assign)NSInteger currentPage;
@property (weak, nonatomic) NSTimer *timer;
@property(weak,nonatomic)UIImageView *imageView;
@end

@implementation PlayerTextScrollerView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 28, 24)];
        imageView.image = [UIImage imageNamed:@"trumpet"];
        CGPoint center = imageView.center;
        center.y = frame.size.height/2;
        imageView.center = center;
        [self addSubview:imageView];
        self.imageView = imageView;
        self.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
//        self.scrollView.backgroundColor = [UIColor yellowColor];
        
        for (int i = 0; i < textViewCount; i ++) {
            UILabel *contentLab = [[UILabel alloc] init];
            contentLab.font = [UIFont systemFontOfSize:16];
            contentLab.textColor = [UIColor blackColor];
            contentLab.numberOfLines = 0;
            [self.scrollView addSubview:contentLab];
//            contentLab.backgroundColor = [UIColor redColor];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToInfo:)];
        [scrollView addGestureRecognizer:tap];
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
- (void)tapToInfo:(UITapGestureRecognizer *)tap{
    
    NSInteger index = self.currentPage;
    NSString *info = self.contentArr[index];
    if (info.length > 0) {
        if ([self.delegate_ respondsToSelector:@selector(playerTextScrollerView:showInfo:)]) {
            [self.delegate_ playerTextScrollerView:self showInfo:info];
        }
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 5, 0, [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.imageView.frame) - 5, self.frame.size.height);
    CGFloat labW = self.scrollView.frame.size.width * 4/5;
    for (int i = 0; i < textViewCount; i++) {
        UILabel *lab = self.scrollView.subviews[i];
        
        if (self.isScrollDirectionPortrait) {
            lab.frame = CGRectMake(0, i * self.scrollView.frame.size.height, labW, self.scrollView.frame.size.height);
            
        } else {
            lab.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, labW, self.scrollView.frame.size.height);
        }
        
    }
    if (self.isScrollDirectionPortrait) {
        self.scrollView.contentSize = CGSizeMake(0, textViewCount * self.bounds.size.height);
    } else {
        self.scrollView.contentSize = CGSizeMake(textViewCount * self.bounds.size.width, 0);
    }
    

    
    [self updateContent];
    
    
}
- (void)setContentArr:(NSArray *)contentArr{

    _contentArr = contentArr;
    if (contentArr.count > 1) {
        
        self.currentPage = 0;
        // 开始定时器
        [self startTimer];
    }

    [self updateContent];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 找出最中间的那个图片控件
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UILabel *lab = self.scrollView.subviews[i];
        CGFloat distance = 0;
        if (self.isScrollDirectionPortrait) {
            distance = ABS(lab.frame.origin.y - scrollView.contentOffset.y);
        } else {
            distance = ABS(lab.frame.origin.x - scrollView.contentOffset.x);
        }
        if (distance < minDistance) {
            minDistance = distance;
            page = lab.tag;
        }
    }
    self.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateContent];
}


#pragma mark - 内容更新
- (void)updateContent
{
    // 设置图片
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        
        UILabel *textLab = self.scrollView.subviews[i];
        NSInteger index = self.currentPage;
        if (i == 0) {
            index--;
        } else if (i == 2) {
            index++;
            
        }
        if (index < 0) {
            index = self.contentArr.count - 1;
        } else if (index >= self.contentArr.count) {
            index = 0;
        }
        textLab.tag = index;
       
        textLab.text = self.contentArr[index];

    }
    
    // 设置偏移量在中间
    if (self.isScrollDirectionPortrait) {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    } else {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
}

#pragma mark - 定时器处理
- (void)startTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)next
{
    if (self.isScrollDirectionPortrait) {
        [self.scrollView setContentOffset:CGPointMake(0, 2 * self.scrollView.frame.size.height) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
    }
}
@end
