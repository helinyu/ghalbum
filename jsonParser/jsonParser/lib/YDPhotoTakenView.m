//
//  YDPhotoTakenView.m
//  test_effective
//
//  Created by Aka on 2017/11/11.
//  Copyright © 2017年 forest. All rights reserved.
//

#import "YDPhotoTakenView.h"
#import <AVFoundation/AVFoundation.h>

@interface YDPhotoTakenView ()

@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation YDPhotoTakenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    {
        [self _deviceInit];
        [self _inputInit];
        [self _outputInit];
        [self _sessionInit];
        [self _previewLayerInit];
        [self _configure];
    }
    
}

- (void)_inputInit {
    _captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:nil];
}

- (void)_outputInit {
    _stillImageOutput = [AVCaptureStillImageOutput new];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
}

- (void)_sessionInit {
    _captureSession = [AVCaptureSession new];
}

- (void)_previewLayerInit {
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [self.layer addSublayer:_previewLayer];
    [self.layer setMasksToBounds:YES];
    [_previewLayer setFrame:self.bounds];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)_deviceInit {
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void)_configure {
    if ([_captureSession canAddInput:_captureInput]) {
        [_captureSession addInput:_captureInput];
    }
    else {
        NSLog(@"添加输入设备失败");
        return;
    }
    
    if ([_captureSession canAddOutput:_stillImageOutput]) {
        [_captureSession addOutput:_stillImageOutput];
    }
    else {
        NSLog(@"添加输出设备失败");
        return ;
    }
    
//    [_captureSession startRunning];
}

- (void)stopRunning {
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
}

- (void)startRunning {
    if (![_captureSession isRunning]) {
        [_captureSession startRunning];
    }
}

- (void)toggleRunning {
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }else {
        [_captureSession startRunning];
    }
}

- (void)takePhotoThen:(void(^)(NSData *imgData,UIImage *img))then {
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"拍照会话获取失败");
        return;
    }
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (!imageDataSampleBuffer) {
            NSLog(@"拍照失败");
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        !then? :then(imageData,image);
    }];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)toggleCamera {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDevicePosition position = [[_captureInput device] position];
        
        AVCaptureDeviceInput *newCaptureInput;
        if (position == AVCaptureDevicePositionBack) {
            newCaptureInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        } else if (position == AVCaptureDevicePositionFront) {
            newCaptureInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        } else {
            return;
        }
        
        if (newCaptureInput) {
            [_captureSession beginConfiguration];
            [_captureSession removeInput:_captureInput];
            if ([_captureSession canAddInput:newCaptureInput]) {
                [_captureSession addInput:newCaptureInput];
                _captureInput = newCaptureInput;
            } else {
                [_captureSession addInput:_captureInput];
            }
            [_captureSession commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

@end
