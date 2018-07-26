//
//  TagView.h
//  CustomTag
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TagView;

@protocol TagViewDelegate <NSObject>

@optional

-(void)tagView:(TagView *)tagView didSelectedTag:(NSInteger )tag;

@end


@interface TagView : UIView


@property (nonatomic ,weak)id <TagViewDelegate>delegate;

@property (nonatomic ,strong) NSArray *titlesArr;


@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *openBtn;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,strong) UIButton *selectedBtn;

@property (nonatomic,assign) NSInteger selectedIndex;

///半透明遮罩
@property (nonatomic,strong) UIView *maskView;


@end
