//
//  WSLScrollView.h
//  GOVScrollView
//
//  Created by 王双龙 on 16/12/26.
//  Copyright © 2016年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^SelectedBlock)(NSInteger currentPage);

typedef  void(^ScrollEndBlock)(NSInteger currentPage);

@interface WSLScrollView : UIView

@property (nonatomic, strong) NSArray *images;

//当前显示视图的宽 = 图片的大小 + 2 * 图片间距1/2
@property (nonatomic, assign) CGSize currentPageSize;

@property (nonatomic, assign) NSInteger currentPageIndex;

//图片间距的1/2  默认为8
@property (nonatomic, assign) NSInteger space;

@property (nonatomic, strong) NSTimer * timer;
//是否开启定时循环功能 默认不开启
@property (nonatomic, assign) BOOL isTimer;
//时间间隔 默认3s
@property (nonatomic,assign) CGFloat second;

//点击回调用
@property (nonatomic, copy) SelectedBlock  selectedBlock;
//翻页后回调用
@property (nonatomic, copy) ScrollEndBlock  scrollEndBlock;

//要求必须调用
- (void)reloadData;
@end
