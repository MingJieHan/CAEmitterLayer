//
//  UILikeButton.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/16.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "UILikeButton.h"
@interface UILikeButton(){
    NSBundle *my_bundle;
    CAEmitterLayer * explosionLayer;
}
@end

@implementation UILikeButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        my_bundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"UILikeButton" ofType:@"bundle"]];
        [self setupExplosion];
    }
    return self;
}

- (void)setupExplosion{
    CAEmitterCell * explosionCell = [CAEmitterCell emitterCell];
    explosionCell.name = @"explosionCell";
    explosionCell.alphaSpeed = -1.f;
    explosionCell.alphaRange = 0.10;
    explosionCell.lifetime = 1;
    explosionCell.lifetimeRange = 0.1;
    explosionCell.velocity = 40.f;
    explosionCell.velocityRange = 10.f;
    explosionCell.scale = 0.08;
    explosionCell.scaleRange = 0.02;
    explosionCell.contents = (id)[[UIImage alloc] initWithContentsOfFile:[my_bundle pathForResource:@"spark_red" ofType:@"png"]].CGImage;

    explosionLayer = [CAEmitterLayer layer];
    [self.layer addSublayer:explosionLayer];
    explosionLayer.emitterSize = CGSizeMake(self.bounds.size.width + 40, self.bounds.size.height + 40);
    explosionLayer.emitterShape = kCAEmitterLayerCircle;
    explosionLayer.emitterMode = kCAEmitterLayerOutline;
    explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
    explosionLayer.emitterCells = @[explosionCell];
}


-(void)layoutSubviews{
    explosionLayer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    if (selected) {
        animation.values = @[@1.5,@2.0, @0.8, @1.0];
        animation.duration = 0.5;
        animation.calculationMode = kCAAnimationCubic;
        [self.layer addAnimation:animation forKey:nil];
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.25];
    }else{
        [self stopAnimation];
    }
}

- (void)startAnimation{
    [explosionLayer setValue:@1000 forKeyPath:@"emitterCells.explosionCell.birthRate"];
    explosionLayer.beginTime = CACurrentMediaTime();
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.15];
}

- (void)stopAnimation{
    [explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosionCell.birthRate"];
    [explosionLayer removeAllAnimations];
}


@end
