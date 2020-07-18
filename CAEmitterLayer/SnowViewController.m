//
//  SnowViewController.m
//  CAEmitterLayer
//
//  Created by Han Mingjie on 2020/7/16.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "SnowViewController.h"
#import "UISnowSettingsView.h"
#import <ReplayKit/ReplayKit.h>

@interface SnowViewController ()<RPPreviewViewControllerDelegate,UISnowSettingsViewDelegate>{
    NSBundle *my_bundle;
    UIImageView * background_imageView;
    CAEmitterLayer * snowLayer;
    
    
    RPScreenRecorder *screenRecorder;
    AVAssetWriter *assetWriter;
    AVAssetWriterInput *assetWriterInput;
    
    UISnowSettingsView *settings_viewcontroller;
    
    UILabel *ad_label;
}
@end

@implementation SnowViewController

#pragma mark - UISnowSettingsViewDelegate

-(void)settingsClosed{
    [snowLayer setValue:@(settings_viewcontroller.birthRate) forKeyPath:@"emitterCells.snowCell.birthRate"];
    [snowLayer setValue:@(settings_viewcontroller.scale-0.1f) forKeyPath:@"emitterCells.snowCell.scale"];
    [snowLayer setValue:@(settings_viewcontroller.scale+0.1f) forKeyPath:@"emitterCells.snowCell.scaleRange"];
}

-(void)share_file:(NSURL *)share_url{
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[share_url] applicationActivities:nil];
    controller.excludedActivityTypes = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        controller.modalPresentationStyle = UIModalPresentationPopover;
        controller.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)setStopAction{
    [NSTimer scheduledTimerWithTimeInterval:13.f repeats:NO block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationController.navigationBarHidden = NO;
            [[RPScreenRecorder sharedRecorder] stopCaptureWithHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"Recording stopped successfully. Cleaning up...");
                    [self->assetWriterInput markAsFinished];
                    [self->assetWriter finishWritingWithCompletionHandler:^{
                        NSLog(@"File Url:  %@",self->assetWriter.outputURL);
                        self->assetWriterInput = nil;
                        NSURL *file_url = self->assetWriter.outputURL;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self share_file:file_url];
                        });
                        self->assetWriter = nil;
                        self->screenRecorder = nil;
                    }];
                }else{
                    NSLog(@"failed.");
                }
            }];
        });
    }];
}


-(void)start_record_video{
    [self->screenRecorder setMicrophoneEnabled:NO];
    [self setStopAction];
    [self->screenRecorder startCaptureWithHandler:^(CMSampleBufferRef  _Nonnull sampleBuffer, RPSampleBufferType bufferType, NSError * _Nullable error) {
        if (CMSampleBufferDataIsReady(sampleBuffer)) {
            if (self->assetWriter.status == AVAssetWriterStatusUnknown && bufferType == RPSampleBufferTypeVideo) {
                [self->assetWriter startWriting];
                [self->assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
            }
            if (self->assetWriter.status == AVAssetWriterStatusFailed) {
                NSLog(@"An error occured.");
                //show alert
                [[RPScreenRecorder sharedRecorder] stopCaptureWithHandler:^(NSError * _Nullable error) {}];
                return;
            }
            if (bufferType == RPSampleBufferTypeVideo) {
                if (self->assetWriterInput.isReadyForMoreMediaData) {
                    [self->assetWriterInput appendSampleBuffer:sampleBuffer];
                }else{
                    NSLog(@"TODO: Sometime here Not ready for video");
                }
            }
        }
    } completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
            // Start recording
            NSLog(@"Recording started successfully.");
        }else{
            //show alert
        }
    }];
}

-(void)build_video:(id)sender{
    screenRecorder = [RPScreenRecorder sharedRecorder];
    [screenRecorder setMicrophoneEnabled:NO];
    self.navigationController.navigationBarHidden = YES;
    
    NSError *error = nil;
    NSArray *pathDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputURL = pathDocuments[0];

    NSString *videoOutPath = [[outputURL stringByAppendingPathComponent:[NSString stringWithFormat:@"Snow_test_%u", arc4random() % 1000]] stringByAppendingPathExtension:@"mp4"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoOutPath]){
        [[NSFileManager defaultManager] removeItemAtPath:videoOutPath error:nil];
    }
    
    assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:videoOutPath] fileType:AVFileTypeMPEG4 error:&error];
    NSDictionary *compressionProperties = @{AVVideoProfileLevelKey         : AVVideoProfileLevelH264HighAutoLevel,
                                            AVVideoH264EntropyModeKey      : AVVideoH264EntropyModeCABAC,
                                            AVVideoAverageBitRateKey       : @(1920 * 1080 * 11.4),
                                            AVVideoMaxKeyFrameIntervalKey  : @60,
                                            AVVideoAllowFrameReorderingKey : @NO};
    NSNumber* width= [NSNumber numberWithFloat:self.view.frame.size.width];
    NSNumber* height = [NSNumber numberWithFloat:self.view.frame.size.height];

    
    NSDictionary *videoSettings = @{AVVideoCompressionPropertiesKey : compressionProperties,
                                    AVVideoCodecKey                 : AVVideoCodecTypeH264,
                                    AVVideoWidthKey                 : width,
                                    AVVideoHeightKey                : height};
    assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    [assetWriter addInput:assetWriterInput];
    [assetWriterInput setMediaTimeScale:60];
    [assetWriter setMovieTimeScale:60];
    [assetWriterInput setExpectsMediaDataInRealTime:YES];

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted){
                [self start_record_video];
            }else{
                //No granted
            }
        });
    }];

}



-(void)settings:(id)sender{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settings_viewcontroller];
    [self presentViewController:nav animated:YES completion:nil];
    return;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    my_bundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"SnowViewController" ofType:@"bundle"]];
    self.title = @"Snow Demo";
    self.view.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *edit_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(settings:)];
    UIBarButtonItem *build_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(build_video:)];
    self.navigationItem.rightBarButtonItems = @[edit_item,build_item];
    
    settings_viewcontroller = [[UISnowSettingsView alloc] init];
    settings_viewcontroller.delegate = self;
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
    if (nil == ad_label){
        ad_label = [[UILabel alloc] initWithFrame:CGRectMake(5.f, self.view.frame.size.height-50.f, self.view.frame.size.width-10.f, 20.f)];
        ad_label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        ad_label.textColor = [UIColor whiteColor];
        ad_label.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.6];
        ad_label.font = [UIFont boldSystemFontOfSize:24.f];
        ad_label.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:ad_label];
    }
    ad_label.text = @"Make in Hans";
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
    snowCell.birthRate = settings_viewcontroller.birthRate;
    snowCell.lifetime = 20.f;
    
    snowCell.speed = 1.f;

    snowCell.velocity = 2.f;
    snowCell.velocityRange = 10.f;
    
    snowCell.yAcceleration = 10.f;
    
    snowCell.scale = settings_viewcontroller.scale - 0.1;
    snowCell.scaleRange = settings_viewcontroller.scale + 0.1;
    
    snowCell.emissionLongitude = M_PI_2;
    snowCell.emissionRange = M_PI_4;
    
    snowCell.spin = 0.f;
    snowCell.spinRange = M_PI * 2;
    
    snowLayer.emitterCells = @[snowCell];
}


#pragma mark - RPPreviewViewControllerDelegate
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController{
    return;
}
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes{
    return;
}

@end
