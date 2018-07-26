//
//  TagView.m
//  CustomTag
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import "TagView.h"
#import <Masonry.h>

#define kScreenWidth      self.bounds.size.width

#define kTagBtnTag      9583049

@implementation TagView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        
        [self addSubview:self.scrollView];
        
        [self addSubview:self.openBtn];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
        [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.width.and.height.mas_equalTo(50);
        }];
        
        
    }
    return self;
}

///根据数据 创建标签
-(void)setTitlesArr:(NSArray *)titlesArr{
    _titlesArr = titlesArr;
    
    if (self.isOpen) {
        [self.superview addSubview:self.maskView];
        [self.superview insertSubview:self aboveSubview:self.maskView];
    }
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        self.selectedBtn = nil;
    }];
    
    CGFloat marginX = 15;
    CGFloat marginY = 10;
    CGFloat height = 30;
    UIButton * markBtn;
    CGFloat totalW = 0.0;
    
    for (int i = 0; i < _titlesArr.count; i++) {
        CGFloat width =  [self calculateString:_titlesArr[i] Width:14] + 20;
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        totalW += (width + marginX);
        tagBtn.tag = kTagBtnTag + i;
        [tagBtn setTitle:_titlesArr[i] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self makeCornerRadius:15 borderColor:[UIColor blackColor] layer:tagBtn.layer borderWidth:0.0];
        tagBtn.backgroundColor = [UIColor grayColor];
        
        if (self.isOpen) {
            if (!markBtn) {
                tagBtn.frame = CGRectMake(marginX, marginY, width, height);
                
            }else{
                if (markBtn.frame.origin.x + markBtn.frame.size.width + marginX + width + marginX > kScreenWidth) {
                    tagBtn.frame = CGRectMake(marginX, markBtn.frame.origin.y + markBtn.frame.size.height + marginY, width, height);
                }else{
                    tagBtn.frame = CGRectMake(markBtn.frame.origin.x + markBtn.frame.size.width + marginX, markBtn.frame.origin.y, width, height);
                }
            }
          
        }else{
            if (!markBtn) {
                tagBtn.frame = CGRectMake(marginX, marginY, width, height);
                
            }else{
                tagBtn.frame = CGRectMake(markBtn.frame.origin.x + markBtn.frame.size.width + marginX, markBtn.frame.origin.y, width, height);
            }
        }
        
        markBtn = tagBtn;
        
        if (i == self.selectedIndex) {
            [self updateSelectedBtn:tagBtn];
        }
        
        [tagBtn addTarget:self action:@selector(clickTo:) forControlEvents:UIControlEventTouchUpInside];

        [self.scrollView addSubview:markBtn];
    }
   
    CGRect rect = self.frame;
    
    if (self.isOpen) {
        CGFloat tH = markBtn.frame.origin.y + markBtn.frame.size.height + marginY;  ///实际总高度
        rect.size.height = tH > 210 ? 210 : tH; ///限制最大高度为210
        self.frame = rect;
       self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), tH + 1.0);
        
    }else{
        rect.size.height = 50;
        self.frame = rect;
        self.scrollView.contentSize = CGSizeMake(totalW + marginX, 50);
    }
    
}

#pragma mark - <Button Clicked>

///标签按钮点击事件
-(void)clickTo:(UIButton *)sender{
    NSInteger tag = sender.tag - kTagBtnTag;
    
    if ([self.delegate respondsToSelector:@selector(tagView:didSelectedTag:)]) {
        [self.delegate tagView:self didSelectedTag:tag];
    }
    
    [self updateSelectedBtn:sender];
    
    if (self.isOpen) {
        
        [self hiddenTagView];
        
    }else{
        [self resetTabScrollViewContentOffset:sender];
    }
}

///折叠按钮点击事件
- (void)openBtnAction:(UIButton *)sender{
    self.isOpen = !self.isOpen;
    
    if (self.isOpen) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, CGRectGetMinY(self.frame), self.bounds.size.width, 0.0);
            self.maskView.alpha = 0.5;
        }];
        ///重新布局
        self.titlesArr = _titlesArr;
        
    }else{
        
        [self hiddenTagView];
    }
}

- (void)hiddenTap:(UITapGestureRecognizer *)sender{
 
    [self hiddenTagView];
}

- (void)hiddenTagView{
    
    self.isOpen = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, CGRectGetMinY(self.frame), self.bounds.size.width, 50.0);
        self.maskView.alpha = 0.0;
        
    }completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
    
    ///重新布局
    self.titlesArr = _titlesArr;
    
    ///选中的标签滚动到中心
    UIButton *selectedBtn = (UIButton *)[self.scrollView viewWithTag:kTagBtnTag + self.selectedIndex];
    [self resetTabScrollViewContentOffset:selectedBtn];
}

#pragma mark - < Private >

///点击item 修改tabScrollView的偏移量 滚动到中心
- (void)resetTabScrollViewContentOffset:(UIButton *)sender{
    
    //计算中间位置的偏移量
    CGFloat offSetX = sender.center.x - self.scrollView.bounds.size.width * 0.5;
    if (offSetX < 0) {
        offSetX = 0;
    }
    
    CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    if (offSetX > maxOffset) {
        offSetX = maxOffset;
    }
    
    //滚动ScrollView
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

///更新选中的标签
- (void)updateSelectedBtn:(UIButton *)sender{
    if (sender == self.selectedBtn) {
        return;
    }
    
    self.selectedBtn.selected = NO;
    self.selectedBtn.backgroundColor = [UIColor grayColor];
    
    sender.selected = YES;
    sender.backgroundColor = [UIColor orangeColor];
    
    self.selectedBtn = sender;
    
    NSInteger tag = sender.tag - kTagBtnTag;
    self.selectedIndex = tag;
}

///设置圆角
-(void)makeCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor layer:(CALayer *)layer borderWidth:(CGFloat)borderWidth{
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = borderWidth;
}

///计算标题宽度
-(CGFloat)calculateString:(NSString *)str Width:(NSInteger)font{
    CGSize size = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

#pragma mark - <Lazy>

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIButton *)openBtn{
    if (_openBtn == nil) {
        _openBtn = [[UIButton alloc] init];
        _openBtn.backgroundColor = [UIColor orangeColor];
        [_openBtn addTarget:self action:@selector(openBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), [UIScreen mainScreen].bounds.size.height)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTap:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

@end
