//
//  ViewController.m
//  GOVScrollView
//
//  Created by 王双龙 on 16/12/20.
//  Copyright © 2016年 王双龙. All rights reserved.
//

#import "ViewController.h"

#import "WSLScrollView.h"
#import "GOVPageControl.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UIScrollViewDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GOVPageControl * pageControl  = [[GOVPageControl alloc] init];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 30 + 30);
    [self.view addSubview:label];
    
    WSLScrollView * scrollView = [[WSLScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    scrollView.selectedBlock = ^(NSInteger currentPage){
      label.text = [NSString stringWithFormat:@"点击当前第%d页",currentPage];
    };
    scrollView.isTimer = YES;
    scrollView.scrollEndBlock = ^(NSInteger currentPage){
       label.text = [NSString stringWithFormat:@"滑动到第%d页",currentPage];
        pageControl.currentPage = currentPage;
    };
    scrollView.second = 3.0;
    scrollView.space = 4;
    scrollView.currentPageSize = CGSizeMake(SCREEN_WIDTH * 0.75, SCREEN_HEIGHT/2);
    scrollView.currentPageIndex = 0;
    scrollView.images = @[@"dlrb.jpeg",@"mr.jpeg",@"ct.jpeg",@"kkx.jpeg",@"kobe.jpeg"];
    //,@"mr.jpeg",@"ct.jpeg",@"kkx.jpeg",@"kobe.jpeg"
    [scrollView reloadData];
    [self.view addSubview:scrollView];
    
    label.text = [NSString stringWithFormat:@"第%d页",scrollView.currentPageIndex];
    
    pageControl.currenStyle = Special;
    pageControl.pageSize = CGSizeMake(10, 10);
    pageControl.currenPageSize = CGSizeMake(20, 10);
    pageControl.currenColor = [UIColor grayColor];
    pageControl.defaultColor = [UIColor blackColor];
    pageControl.currentPage = scrollView.currentPageIndex;
    pageControl.numberOfPages = scrollView.images.count;
    [pageControl setUpDots];
    pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 15 + 20);
    [self.view addSubview:pageControl];
    
    
    WSLScrollView * scrollView2 = [[WSLScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2 + 30 + 64, SCREEN_WIDTH, SCREEN_HEIGHT/2 - 60 - 64)];
    scrollView2.isTimer = YES;
    scrollView2.second = 1.0;
    scrollView2.space = 0;
    scrollView2.currentPageSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT/2);
    scrollView2.currentPageIndex = 0;
    scrollView2.images = @[@"dlrb.jpeg",@"mr.jpeg"];
    [scrollView2 reloadData];
    [self.view addSubview:scrollView2];
    
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
