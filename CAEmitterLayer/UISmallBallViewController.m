//
//  UISmallBallViewController.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/23.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "UISmallBallViewController.h"

@interface UISmallBallViewController (){
    CAEmitterLayer * colorBallLayer;
    NSBundle *my_bundle;
}

@end

@implementation UISmallBallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    my_bundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"UISmallBallViewController" ofType:@"bundle"]];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupEmitter];
}


- (void)setupEmitter{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    [self.view addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.text = @"Touch or Drag for ball source.";
    label.textAlignment = NSTextAlignmentCenter;
    
    colorBallLayer = [CAEmitterLayer layer];
    [self.view.layer addSublayer:colorBallLayer];
    
    colorBallLayer.emitterSize = self.view.frame.size;
    colorBallLayer.emitterShape = kCAEmitterLayerPoint;
    colorBallLayer.emitterMode = kCAEmitterLayerPoints;
    colorBallLayer.emitterPosition = CGPointMake(self.view.layer.bounds.size.width, 0.f);
    
    CAEmitterCell * colorBallCell = [CAEmitterCell emitterCell];
    colorBallCell.name = @"colorBallCell";
    
    colorBallCell.birthRate = 20.f;
    colorBallCell.lifetime = 10.f;
    
    colorBallCell.velocity = 40.f;
    colorBallCell.velocityRange = 100.f;
    colorBallCell.yAcceleration = 15.f;
    
    colorBallCell.emissionLongitude = M_PI; // 向左
    colorBallCell.emissionRange = M_PI_4; // 围绕X轴向左90度
    
    colorBallCell.scale = 0.2;
    colorBallCell.scaleRange = 0.1;
    colorBallCell.scaleSpeed = 0.02;
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[my_bundle pathForResource:@"circle_white" ofType:@"png"]];
    colorBallCell.contents = (id)[image CGImage];
    colorBallCell.color = [[UIColor colorWithRed:0.5 green:0.f blue:0.5 alpha:1.f] CGColor];
    colorBallCell.redRange = 1.f;
    colorBallCell.greenRange = 1.f;
    colorBallCell.blueSpeed = 1.f;
    colorBallCell.alphaRange = 0.8;
    colorBallCell.alphaSpeed = -0.1f;
    
    // 添加
    colorBallLayer.emitterCells = @[colorBallCell];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self locationFromTouchEvent:event];
    [self setBallInPsition:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self locationFromTouchEvent:event];
    [self setBallInPsition:point];
}

- (CGPoint)locationFromTouchEvent:(UIEvent *)event{
    UITouch * touch = [[event allTouches] anyObject];
    return [touch locationInView:self.view];
}

- (void)setBallInPsition:(CGPoint)position{
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"emitterCells.colorBallCell.scale"];
    anim.fromValue = @0.2f;
    anim.toValue = @0.5f;
    anim.duration = 1.f;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [colorBallLayer addAnimation:anim forKey:nil];
    [colorBallLayer setValue:[NSValue valueWithCGPoint:position] forKeyPath:@"emitterPosition"];
    [CATransaction commit];
}

@end
