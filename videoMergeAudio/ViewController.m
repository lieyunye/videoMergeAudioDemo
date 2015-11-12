//
//  ViewController.m
//  videoMergeAudio
//
//  Created by lieyunye on 10/13/15.
//  Copyright © 2015 lieyunye. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self mergeVideos];

}

- (void)mergeVideoWithAudio
{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];
    NSString* videoName = @"export.mp4";
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]){
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    _assetExport.outputFileType = @"public.mpeg-4";
    NSLog(@"file type %@",_assetExport.outputFileType);
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^(void ) {
        // your completion code here
    }
     ];
}

- (void)mergeVideos
{
    NSString *videoPath1 = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp4"];
    NSURL *videoURL1 = [NSURL fileURLWithPath:videoPath1];
    NSString *videoPath2 = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"mp4"];
    NSURL *videoURL2 = [NSURL fileURLWithPath:videoPath2];
    
    AVURLAsset* videoAsset1 = [[AVURLAsset alloc]initWithURL:videoURL1 options:nil];
    AVURLAsset* videoAsset2 = [[AVURLAsset alloc]initWithURL:videoURL2 options:nil];

    AVMutableComposition* mixComposition = [AVMutableComposition composition];

    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *assetVideoTrack1 = [videoAsset1 tracksWithMediaType:AVMediaTypeVideo].lastObject;
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset1.duration)
                                   ofTrack:assetVideoTrack1
                                    atTime:kCMTimeInvalid error:nil];
    [compositionVideoTrack setPreferredTransform:assetVideoTrack1.preferredTransform];
    
    AVAssetTrack *assetVideoTrack2 = [videoAsset2 tracksWithMediaType:AVMediaTypeVideo].lastObject;

    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset2.duration)
                                   ofTrack:assetVideoTrack2
                                    atTime:kCMTimeInvalid error:nil];
    [compositionVideoTrack setPreferredTransform:assetVideoTrack2.preferredTransform];

    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];
    NSString* videoName = @"export.mp4";
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]){
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    _assetExport.outputFileType = @"public.mpeg-4";
    NSLog(@"file type %@",_assetExport.outputFileType);
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^(void ) {
        // your completion code here
    }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
