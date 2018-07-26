//
//  TagViewViewController.m
//  FF_TagMenuView
//
//  Created by mac on 2018/7/26.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "TagViewViewController.h"
#import "TagView.h"

@interface TagViewViewController ()<TagViewDelegate>


@property (nonatomic,strong) TagView *tagView;


@end

@implementation TagViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *orangeV = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    orangeV.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:orangeV];
    
    
    [self.view addSubview:self.tagView];
    self.tagView.titlesArr = @[@"锤子",@"见过",@"膜拜单车",@"微信支付",@"Q",@"王者荣耀",@"蓝淋网",@"阿珂",@"半生",@"猎场",@"QQ空间",@"王者荣耀助手",@"斯卡哈复健科",@"安抚",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味"];
}

-(TagView *)tagView{
    if (!_tagView) {
        _tagView = [[TagView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 50)];
        _tagView.backgroundColor = [UIColor cyanColor];
        _tagView.delegate = self;
    }
    return _tagView;
}

#pragma mark - CCTagViewDelegate

- (void)tagView:(TagView *)tagView didSelectedTag:(NSInteger)tag{
    
    NSLog(@"tag ---- %ld --",tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
