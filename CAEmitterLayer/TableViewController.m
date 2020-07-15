//
//  TableViewController.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/15.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "TableViewController.h"
#import "FireViewController.h"


#define CELL_NAME_FIRE @"Fire"
@interface TableViewController (){
    
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CAEmitterLayer Demo";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(NSString *)cell_identifier_stringFor:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return CELL_NAME_FIRE;
            break;
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
    return 1;
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
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self cell_identifier_stringFor:indexPath] isEqualToString:CELL_NAME_FIRE]){
        FireViewController *view = [[FireViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    return;
}

@end
