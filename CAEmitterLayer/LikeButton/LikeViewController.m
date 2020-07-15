//
//  LikeViewController.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/15.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "LikeViewController.h"
#import "UILikeButton.h"
@interface LikeViewController (){
    NSBundle *my_bundle;
    UILikeButton * btn;
}

@end

@implementation LikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    my_bundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"LikeViewController" ofType:@"bundle"]];
    self.title = @"Like Button";
    self.view.backgroundColor = [UIColor whiteColor];
    
    btn = [UILikeButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 30, 130);
    [self.view addSubview:btn];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[my_bundle pathForResource:@"dislike" ofType:@"png"]];
    [btn setImage:image forState:UIControlStateNormal];
    image = [[UIImage alloc] initWithContentsOfFile:[my_bundle pathForResource:@"like_orange" ofType:@"png"]];
    [btn setImage:image forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    btn.center = self.view.center;
}

- (void)btnClick:(UIButton *)button{
    if (!button.selected) {
        button.selected = !button.selected;
    }else{
        button.selected = !button.selected;
    }
}

@end
