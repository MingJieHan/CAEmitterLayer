//
//  SnowViewController.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/16.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "SnowViewController.h"

@interface SnowViewController (){
    NSBundle *my_bundle;
    UIImageView * background_imageView;
    CAEmitterLayer * snowLayer;
}
@end

@implementation SnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    my_bundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"SnowViewController" ofType:@"bundle"]];
    self.title = @"Snow Demo";
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (nil == background_imageView){
        background_imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        background_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        background_imageView.image = [UIImage imageWithContentsOfFile:[my_bundle pathForResource:@"tree" ofType:@"jpg"]];
        background_imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:background_imageView];
        
        [self setupEmitter];
    }
}

- (void)setupEmitter{
    snowLayer = [CAEmitterLayer layer];
    snowLayer.emitterShape = kCAEmitterLayerLine;
    snowLayer.emitterMode = kCAEmitterLayerSurface;
    snowLayer.emitterSize = self.view.frame.size;
    snowLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    [self.view.layer addSublayer:snowLayer];
    
    
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    snowCell.name = @"snowCell";
    snowCell.contents = (id)[UIImage imageWithContentsOfFile:[my_bundle pathForResource:@"snow_white" ofType:@"png"]].CGImage;
    snowCell.birthRate = 5.f;
    snowCell.lifetime = 20.f;
    
    snowCell.speed = 1.f;

    snowCell.velocity = 2.f;
    snowCell.velocityRange = 10.f;
    
    snowCell.yAcceleration = 10.f;
    
    snowCell.scale = 0.2;
    snowCell.scaleRange = 0.4f;
    
    snowCell.emissionLongitude = M_PI_2;    // 向下
    snowCell.emissionRange = M_PI_4;        // 向下
    
    snowLayer.emitterCells = @[snowCell];
}
@end
