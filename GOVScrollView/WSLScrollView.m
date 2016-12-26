//
//  WSLScrollView.m
//  GOVScrollView
//
//  Created by 王双龙 on 16/12/26.
//  Copyright © 2016年 王双龙. All rights reserved.
//

#import "WSLScrollView.h"

@interface WSLScrollView ()<UIScrollViewDelegate>

#define SELF_WIDTH (self.bounds.size.width)
#define SELF_HEIGHT (self.bounds.size.height)

//采用 5 1 2 3 4 5 1 之后的数组
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIScrollView *scrollerView;

//是为了解决循环滚动的连贯性问题
@property (nonatomic, strong) UIView * firstView;
@property (nonatomic, strong) UIView * lastView;

@end

@implementation WSLScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self createUI];
        _currentPageIndex = 0;
        _space = 8;
        _isTimer = NO;
        _second = 3.0;
        _currentPageSize = CGSizeMake(SELF_WIDTH, SELF_HEIGHT);
    }
    return self;
}

- (void)createUI{
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.delegate = self;
    _scrollerView.pagingEnabled = YES;
    _scrollerView.clipsToBounds = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollerView];
}

- (void)reloadData{
    
    if (_isTimer) {
        [self statrScroll:_second];
    }
    
    for (UIView * View in self.scrollerView.subviews) {
        [View removeFromSuperview];
    }
    
    if (_images.count <= 0) {
        return;
    }
    
    //   5 1 2 3 4 5 1
    self.imageArray = [NSMutableArray arrayWithArray:_images];
    [self.imageArray addObject:_images[0]];
    [self.imageArray insertObject:_images.lastObject atIndex:0];
    
    _scrollerView.frame = CGRectMake((SELF_WIDTH - _currentPageSize.width) / 2, 0, _currentPageSize.width, _currentPageSize.height);
    _scrollerView.contentSize = CGSizeMake(_currentPageSize.width * self.imageArray.count, _currentPageSize.height);
    
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(i * _currentPageSize.width, 0, _currentPageSize.width, _currentPageSize.height)];
        view.backgroundColor = [UIColor grayColor];
        view.tag = 10 + i;
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_space, 0, (_currentPageSize.width - 2 * _space), _currentPageSize.height)];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [view addGestureRecognizer:tap];
        NSString * imageName = self.imageArray[i];
        imageView.image = [UIImage imageNamed:imageName];
        [view addSubview:imageView];
        [_scrollerView addSubview:view];
    }
    
    _scrollerView.contentOffset = CGPointMake(_currentPageSize.width * (self.currentPageIndex + 1), 0);
}

#pragma mark -- Events Handle

- (void)tap:(UITapGestureRecognizer *)tap{
    UIView * View  = (UIView *)tap.view;
    //处理点击当前页两边的事件
    if(View.tag - 10 - 1 != _currentPageIndex){
        return;
    }
    if (self.selectedBlock != nil) {
        self.selectedBlock(View.tag - 10 - 1);
    }
}

- (void)statrScroll:(CGFloat)second{
    if (_timer == nil && _isTimer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(autoNextPage) userInfo:nil repeats:YES];
    }
}

- (void)autoNextPage{
    
    [_scrollerView setContentOffset:CGPointMake( _currentPageSize.width * (_currentPageIndex + 1 + 1), 0) animated:YES];
    
    if (_currentPageIndex + 2 == self.imageArray.count - 1) {
        //是为了解决自动滑动到最后一页再从头开始的连贯性问题
        [_scrollerView addSubview:self.firstView];
    }
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat index = scrollView.contentOffset.x/_currentPageSize.width;
    if (index == 0 ) {
        _currentPageIndex = self.imageArray.count - 1- 2;
    }else if(index < 1){
        
    }else if(index == self.imageArray.count - 1 || index == 1){
        _currentPageIndex = 0;
        //是为了解决自动滑动到最后一页再从头开始的连贯性问题
        [_scrollerView setContentOffset:CGPointMake( _currentPageSize.width , 0) animated:NO];
        
    }else if(index == ceil(index)){
        _currentPageIndex = index - 1 ;
    }
    if (self.scrollEndBlock != nil) {
        self.scrollEndBlock(_currentPageIndex);
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/_currentPageSize.width;
    
    if (_isTimer) {
        [self statrScroll:_second];
    }
    //是为了解决循环滚动的连贯性问题
    if (index == 0) {
        scrollView.contentOffset = CGPointMake(_currentPageSize.width * (self.imageArray.count - 2) , 0);
    }
    if (index == self.imageArray.count - 1) {
        scrollView.contentOffset = CGPointMake(_currentPageSize.width  , 0);
    }
    
    if (self.lastView != nil || self.firstView != nil) {
        [self.lastView removeFromSuperview];
        [self.firstView removeFromSuperview];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.timer invalidate];
    self.timer = nil;
    
    //  4 5 1 2 3 4 5 1 2
    
    NSInteger index = scrollView.contentOffset.x/_currentPageSize.width;
    
    //是为了解决循环滚动的连贯性问题
    if (index == 1) {
        [self.scrollerView addSubview:self.lastView];
    }
    if (index == self.imageArray.count - 2) {
        [self.scrollerView addSubview:self.firstView];
    }
}

#pragma mark - hitTest

//处理超过父视图部分不能点击的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        CGPoint newPoint = [_scrollerView convertPoint:point fromView:self];
        for (UIImageView * imageView in _scrollerView.subviews) {
            if (CGRectContainsPoint(imageView.frame, newPoint)) {
                CGPoint newSubViewPoint = [imageView convertPoint:point fromView:self];
                return [imageView hitTest:newSubViewPoint withEvent:event];
            }
        }
    }
    return nil;
}

#pragma mark -- Getter

- (UIView *)firstView{
    
    if (_firstView == nil) {
        
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(_currentPageSize.width * (self.imageArray.count), 0, _currentPageSize.width, _currentPageSize.height)];
        _firstView.backgroundColor = [UIColor grayColor];
        
        UIImageView * _firstImageview = [[UIImageView alloc] initWithFrame:CGRectMake(_space, 0, (_currentPageSize.width - 2 * _space), _currentPageSize.height)];
        NSString * imageName = self.imageArray[2];
        _firstImageview.image = [UIImage imageNamed:imageName];
        [_firstView addSubview:_firstImageview];
    }
    return _firstView;
}

- (UIView *)lastView{
    
    if (_lastView == nil) {
        
        _lastView = [[UIView alloc] initWithFrame:CGRectMake(-_currentPageSize.width, 0, _currentPageSize.width, _currentPageSize.height)];
        _lastView.backgroundColor = [UIColor grayColor];
        
        UIImageView * _lastImageview = [[UIImageView alloc] initWithFrame:CGRectMake(_space, 0, (_currentPageSize.width - 2 * _space), _currentPageSize.height)];
        NSString * imageName = self.imageArray[self.imageArray.count - 3];
        _lastImageview.image = [UIImage imageNamed:imageName];
        [_lastView addSubview:_lastImageview];
    }
    return _lastView;
}

@end
