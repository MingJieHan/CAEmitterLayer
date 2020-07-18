//
//  UISnowSettingsTableView.h
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/17.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UISnowSettingsViewDelegate;
@interface UISnowSettingsView : UITableViewController{
    id <UISnowSettingsViewDelegate> delegate;
    NSInteger birthRate;
    float scale;
}
@property (nonatomic) id <UISnowSettingsViewDelegate> delegate;
@property (nonatomic) NSInteger birthRate;
@property (nonatomic) float scale;
@end
@protocol UISnowSettingsViewDelegate <NSObject>
@required
-(void)settingsClosed;
@end
NS_ASSUME_NONNULL_END
