//
//  UIMyNavigationController.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/15.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "UIMyNavigationController.h"

@interface UIMyNavigationController ()

@end

@implementation UIMyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(BOOL)shouldAutorotate{
    if (self.viewControllers){
        return [self.viewControllers.lastObject shouldAutorotate];
    }
    return YES;
}

@end
