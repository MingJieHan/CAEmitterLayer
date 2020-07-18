//
//  UISnowSettingsTableView.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/17.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "UISnowSettingsView.h"

@interface UISnowSettingsView()<UITableViewDelegate,UITableViewDataSource>{
    UISlider *scale_slider;
    UISlider *number_slider;
    NSBundle *my_bundle;
}
@end

@implementation UISnowSettingsView
@synthesize delegate;
@synthesize scale;
@synthesize birthRate;

-(id)init{
    self = [super init];
    if (self){
        scale = 0.3;
        birthRate = 1;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.title = @"Snow Settings";
    }
    return self;
}

-(void)save{
    [self dismissViewControllerAnimated:YES completion:^{
        [self->delegate settingsClosed];
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    my_bundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"SnowViewController" ofType:@"bundle"]];
}

-(void)slider_action:(id)sender{
    UISlider *slider = (UISlider *)sender;
    if (slider == scale_slider){
        scale = scale_slider.value;
    }else if (slider == number_slider){
        birthRate = number_slider.value;
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"";
    switch (indexPath.row) {
        case 0:{
            cell.backgroundColor = [UIColor whiteColor];
            scale_slider = [[UISlider alloc] initWithFrame:CGRectMake(5.f, 0.f, cell.frame.size.width-10.f,cell.frame.size.height)];
            scale_slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            scale_slider.maximumValue = 0.9;
            scale_slider.minimumValue = 0.1;
            scale_slider.value = scale;
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:[my_bundle pathForResource:@"snow_gray" ofType:@"png"]];
            scale_slider.minimumValueImage = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width/2.f, image.size.height/2.f)];
            scale_slider.maximumValueImage = image;
            [scale_slider addTarget:self action:@selector(slider_action:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:scale_slider];
            break;}
        case 1:{
            cell.backgroundColor = [UIColor whiteColor];
            number_slider = [[UISlider alloc] initWithFrame:CGRectMake(5.f, 0.f, cell.frame.size.width-10.f,cell.frame.size.height)];
            number_slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            number_slider.maximumValue = 10;
            number_slider.minimumValue = 1;
            number_slider.value = birthRate;
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:[my_bundle pathForResource:@"snow_gray" ofType:@"png"]];
            number_slider.minimumValueImage = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width/2.f, image.size.height/2.f)];
            number_slider.maximumValueImage = image;
            [number_slider addTarget:self action:@selector(slider_action:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:number_slider];
            break;}
        default:
            break;
    }
    
    return cell;
}


@end
