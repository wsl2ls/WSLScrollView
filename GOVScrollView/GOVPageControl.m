//
//  GOVPageControl.m
//  GovCn
//
//  Created by 王双龙 on 16/8/5.
//  Copyright © 2016年 cdi. All rights reserved.
//

#import "GOVPageControl.h"

@implementation GOVPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withNumberOfPages:(NSInteger)numberOfPages{
    if (self == [super initWithFrame:frame]) {
        _pageSize = CGSizeMake(4, 4);
        _currenPageSize = _pageSize;
        _space = 5.0;
        _currentPage = 0;
        _numberOfPages = numberOfPages;
        _currenStyle = Normal;
        return self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _pageSize = CGSizeMake(4, 4);
        _currenPageSize = _pageSize;
        _space = 5.0;
        _currenStyle = Normal;
        return self;
    }
    return self;
}

- (instancetype)init{
    
    if (self == [super init]) {
        _pageSize = CGSizeMake(4, 4);
        _currenPageSize = _pageSize;
        _space = 5.0;
        _currentPage = 0;
        _currenStyle = Normal;
        return self;
    }
    return self;
}
- (void)setUpDots{
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.space + self.numberOfPages * (self.pageSize.width + self.space) - self.pageSize.width + self.currenPageSize.width, self.pageSize.height);
    
    for (int i = 0; i < self.numberOfPages; i++) {
        
        if ([self.subviews count] < self.numberOfPages) {
            UIImageView * view = [[UIImageView alloc] init];
            [self addSubview:view];
        }
        
        UIImageView * imageView = self.subviews[i];
        
        if ( i < self.currentPage) {
            imageView.frame = CGRectMake(self.space + i * (self.space + self.pageSize.width), 0, self.pageSize.width, self.pageSize.height);
        }else if(i == self.currentPage){
            imageView.frame = CGRectMake(self.space + i * (self.space + self.pageSize.width), -(self.currenPageSize.height - self.pageSize.height)/2.0f, self.currenPageSize.width, self.currenPageSize.height);
        }else{
            imageView.frame = CGRectMake(self.space + i * (self.space + self.pageSize.width) - self.pageSize.width + self.currenPageSize.width, 0, self.pageSize.width, self.pageSize.height);
        }
        
        if (self.currenStyle == Special) {
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = self.currenPageSize.height/2.0; 
        }
        
        if (i == self.currentPage) {
            if (self.currenColor == nil) {
                imageView.image = self.currentImage;
            }else{
                imageView.backgroundColor = self.currenColor;
                imageView.image = nil;
            }
        }else{
            if (self.defaultColor == nil) {
                imageView.image = self.defaultImage;
            }else{
                imageView.backgroundColor = self.defaultColor;
                imageView.image = nil;
            }
        }
    }
}

- (CGSize)sizeForNumberOfPages:(NSInteger)numberOfPages{
    
    return CGSizeMake(self.space + numberOfPages * (self.pageSize.width + self.space) - self.pageSize.width + self.currenPageSize.width, self.pageSize.height);
}

#pragma mark --- Setter

- (void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    [self setUpDots];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    [self setUpDots];
}


@end
