//
//  TableViewController.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/15.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "TableViewController.h"
#import "FireViewController.h"
#import "FireworksViewController.h"
#import "LikeViewController.h"
#import "SnowViewController.h"
#import "UISmallBallViewController.h"


#define CELL_NAME_FIRE @"Fire"
#define CELL_NAME_FIREWORKS @"Fireworks"
#define CELL_NAME_Like_Button @"Like Button"
#define CELL_NAME_SNOW @"Snow"
#define CELL_NAME_BALL @"Small Balls"

@interface TableViewController (){
    
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CAEmitterLayer Demo";
}


-(NSString *)cell_identifier_stringFor:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return CELL_NAME_FIRE;
        case 1:
            return CELL_NAME_FIREWORKS;
        case 2:
            return CELL_NAME_Like_Button;
        case 3:
            return CELL_NAME_SNOW;
        case 4:
            return CELL_NAME_BALL;
        default:
            break;
    }
    return @"";
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"identifier_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"Title";
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_FIRE]){
        cell.textLabel.text = CELL_NAME_FIRE;
    }
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_FIREWORKS]){
        cell.textLabel.text = CELL_NAME_FIREWORKS;
    }
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_Like_Button]){
        cell.textLabel.text = @"Like Button";
    }
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_SNOW]){
        cell.textLabel.text = CELL_NAME_SNOW;
    }
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_BALL]){
        cell.textLabel.text = CELL_NAME_BALL;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_FIRE]){
        FireViewController *view = [[FireViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_FIREWORKS]){
        FireworksViewController *view = [[FireworksViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_Like_Button]){
        LikeViewController *view = [[LikeViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_SNOW]){
        SnowViewController *view = [[SnowViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    }
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_BALL]){
        UISmallBallViewController *view = [[UISmallBallViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    }
    return;
}

@end
