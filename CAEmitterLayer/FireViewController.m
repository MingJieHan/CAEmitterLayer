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
}
@end

@implementation FireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Fire";
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (nil == fireLayer){
        [self setupEmitter];
    }
}

- (void)setupEmitter{
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    [self.view addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.text = @"Drag for fire height.";
    label.textAlignment = NSTextAlignmentCenter;
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setFireAndSmokeHight:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setFireAndSmokeHight:event];
}



- (void)setFireAndSmokeHight:(UIEvent *)event{
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGFloat distanceToBottom = self.view.bounds.size.height - touchPoint.y;
    CGFloat per = distanceToBottom / self.view.bounds.size.height;
    
    [self setFireAndSmokeCount:2 * per];
}

- (void)setFireAndSmokeCount:(float)ratio{
    
    [fireLayer setValue:@(ratio * 500.0) forKeyPath:@"emitterCells.fireCell.birthRate"]; // 产生数量
    [fireLayer setValue:[NSNumber numberWithFloat:ratio] forKeyPath:@"emitterCells.fireCell.lifetime"]; // 生命周期
    [fireLayer setValue:@(ratio * 0.35) forKeyPath:@"emitterCells.fireCell.lifetimeRange"]; // 生命周期变化范围
    [fireLayer setValue:[NSValue valueWithCGPoint:CGPointMake(ratio * 50, 0)] forKeyPath:@"emitterSize"]; // 发射源大小
    
    [smokeLayer setValue:@(ratio * 4) forKeyPath:@"emitterCells.smokeCell.lifetime"]; // 生命周期
    [smokeLayer setValue:(id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:ratio * 0.3] CGColor] forKeyPath:@"emitterCells.smokeCell.color"]; // 透明度
    
}

@end
