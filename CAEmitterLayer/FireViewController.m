//
//  FireViewController.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/15.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "FireViewController.h"

@interface FireViewController (){
    CAEmitterLayer * fireLayer;
    CAEmitterLayer * smokeLayer;
    float current_width;
    UISlider *fire_height_slider;
}
@end

@implementation FireViewController

-(BOOL)shouldAutorotate{
    if ([UIScreen mainScreen].bounds.size.width != current_width){
        current_width = [UIScreen mainScreen].bounds.size.width;
        smokeLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 60);
        fireLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 60);
    }
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Fire";
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)fire_height_slider_changed:(id)sender{
    [self setFireAndSmokeCount:2.f * fire_height_slider.value];
    return;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (nil == fireLayer){
        [self setupEmitter];
    }
    if (nil == fire_height_slider){
        fire_height_slider = [[UISlider alloc] initWithFrame:CGRectMake(100.f, self.view.frame.size.height-80.f, self.view.frame.size.width-200.f, 20.f)];
        fire_height_slider.minimumValue = 0.1f;
        fire_height_slider.maximumValue = 1.f;
        fire_height_slider.value = 0.2f;
        [fire_height_slider addTarget:self action:@selector(fire_height_slider_changed:) forControlEvents:UIControlEventValueChanged];
        fire_height_slider.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:fire_height_slider];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5.f, fire_height_slider.frame.origin.y, 90.f, 20)];
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        label.textColor = [UIColor whiteColor];
        label.text = @"Small";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];


        UILabel * right_label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-95.f, fire_height_slider.frame.origin.y, 90.f, 20)];
        right_label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        right_label.textColor = [UIColor whiteColor];
        right_label.text = @"Large";
        right_label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:right_label];
    }
}

- (void)setupEmitter{
    smokeLayer = [CAEmitterLayer layer];
    smokeLayer.renderMode = kCAEmitterLayerAdditive;
    smokeLayer.emitterMode = kCAEmitterLayerPoints;
    smokeLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 60); // 中间下部
    
    CAEmitterCell * smokeCell = [CAEmitterCell emitterCell];
    smokeCell.name = @"smokeCell";
    
    smokeCell.birthRate = 11.f;
    smokeCell.scale = 0.1;
    smokeCell.scaleSpeed = 0.7;
    smokeCell.lifetime = 3.6;
    
    smokeCell.velocity = -40.f;
    smokeCell.velocityRange = 20;
    smokeCell.yAcceleration = -160;             // 向上
    
    smokeCell.emissionLongitude = -M_PI * 0.5;  // 向上
    smokeCell.emissionRange = M_PI * 0.25;      // 围绕x轴上方向成90度
    
    smokeCell.spin = 1;
    smokeCell.spinRange = 6;
    
    smokeCell.alphaSpeed = -0.12;
    smokeCell.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.27] CGColor];
    smokeCell.contents = (id)[[UIImage imageNamed:@"smoke_white"] CGImage];
    smokeLayer.emitterCells = @[smokeCell];
    [self.view.layer addSublayer:smokeLayer];
    
    
    
    fireLayer = [CAEmitterLayer layer];
    fireLayer.emitterSize = CGSizeMake(100.f, 0);
    fireLayer.emitterMode = kCAEmitterLayerOutline;
    fireLayer.emitterShape = kCAEmitterLayerLine;
    fireLayer.renderMode = kCAEmitterLayerAdditive;
    fireLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 60); // 中间下部
    
    CAEmitterCell * fireCell = [CAEmitterCell emitterCell];
    fireCell.name = @"fireCell";
    
    fireCell.birthRate = 450.f;
    fireCell.scaleSpeed = 0.5;
    fireCell.lifetime = 0.9f;
    fireCell.lifetimeRange = 0.315;
    
    fireCell.velocity = -80.f;
    fireCell.velocityRange = 30;
    fireCell.yAcceleration = -200;
    
    fireCell.emissionLongitude = M_PI;
    fireCell.emissionRange = 1.1;
    
    fireCell.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
    fireCell.contents = (id)[[UIImage imageNamed:@"fire_white"] CGImage];
    fireLayer.emitterCells = @[fireCell];
    
    [self.view.layer addSublayer:fireLayer];
}

- (void)setFireAndSmokeCount:(float)ratio{
    [fireLayer setValue:@(ratio * 500.0) forKeyPath:@"emitterCells.fireCell.birthRate"];    // 产生数量
    [fireLayer setValue:[NSNumber numberWithFloat:ratio] forKeyPath:@"emitterCells.fireCell.lifetime"]; // 生命周期
    [fireLayer setValue:@(ratio * 0.35) forKeyPath:@"emitterCells.fireCell.lifetimeRange"]; // 生命周期变化范围
    [fireLayer setValue:[NSValue valueWithCGPoint:CGPointMake(ratio * 50, 0)] forKeyPath:@"emitterSize"]; // 发射源大小
    
    [smokeLayer setValue:@(ratio * 4) forKeyPath:@"emitterCells.smokeCell.lifetime"];       // 生命周期
    [smokeLayer setValue:(id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:ratio * 0.3] CGColor] forKeyPath:@"emitterCells.smokeCell.color"];               // 透明度
    
}

@end
