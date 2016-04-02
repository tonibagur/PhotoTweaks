//
//  PhotoTweaksViewController.m
//  PhotoTweaks
//
//  Created by Tu You on 14/12/5.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "PhotoTweaksViewController.h"
#import "PhotoTweakView.h"
#import "UIColor+Tweak.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoTweaksViewController ()

@property (strong, nonatomic) PhotoTweakView *photoView;

@end

@implementation PhotoTweaksViewController

- (instancetype)initWithImage:(UIImage *)image singleMode:(BOOL) mode
{
    self.singleMode=mode;
    if (self = [super init]) {
        _image = image;
        _autoSaveToLibray = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor photoTweakCanvasBackgroundColor];

    [self setupSubviews];
}

- (void)setupSubviews
{
    self.photoView = [[PhotoTweakView alloc] initWithFrame:self.view.bounds image:self.image singleMode:self.singleMode];
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.photoView];
    
    UIView* buttonBar=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)*0.93, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*0.07 )];
    buttonBar.backgroundColor=[UIColor blackColor];
    buttonBar.alpha=0.85;
    [self.view addSubview:buttonBar];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/7*0.5-10, CGRectGetHeight(self.view.frame) - 30, 20, 20);
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"editCancelBtn"] forState:UIControlStateNormal];
    UIColor *cancelTitleColor = !self.cancelButtonTitleColor ?
    [UIColor cancelButtonColor] : self.cancelButtonTitleColor;
    [cancelBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    UIColor *cancelHighlightTitleColor = !self.cancelButtonHighlightTitleColor ?
    [UIColor cancelButtonHighlightedColor] : self.cancelButtonHighlightTitleColor;
    [cancelBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/7*1.5-10, CGRectGetHeight(self.view.frame) - 30, 20, 20);
    resetBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [resetBtn setTitle:NSLocalizedStringFromTable(@"Reset", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [resetBtn setImage:[UIImage imageNamed:@"editResetBtn"] forState:UIControlStateNormal];
    [resetBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    [resetBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [resetBtn addTarget:self action:@selector(resetBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
    
    UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rotateBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/7*2.5-10, CGRectGetHeight(self.view.frame) - 30, 20, 20);
    rotateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[rotateBtn setTitle:NSLocalizedStringFromTable(@"Rotate", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [rotateBtn setImage:[UIImage imageNamed:@"editRotateBtn"] forState:UIControlStateNormal];
    [rotateBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    [rotateBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
    rotateBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rotateBtn addTarget:self action:@selector(rotateBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateBtn];

    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lightBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/7*3.5-10, CGRectGetHeight(self.view.frame) - 30, 20, 20);
    lightBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[rotateBtn setTitle:NSLocalizedStringFromTable(@"Rotate", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [lightBtn setImage:[UIImage imageNamed:@"editLightBtn"] forState:UIControlStateNormal];
    [lightBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    [lightBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
    lightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [lightBtn addTarget:self action:@selector(rotateBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    
    UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    colorBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/7*4.5-10, CGRectGetHeight(self.view.frame) - 30, 20, 20);
    colorBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[rotateBtn setTitle:NSLocalizedStringFromTable(@"Rotate", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [colorBtn setImage:[UIImage imageNamed:@"editColorBtn"] forState:UIControlStateNormal];
    [colorBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    [colorBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
    colorBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [colorBtn addTarget:self action:@selector(rotateBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:colorBtn];

    UIButton *bnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bnBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/7*5.5-10, CGRectGetHeight(self.view.frame) - 30, 20, 20);
    bnBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[rotateBtn setTitle:NSLocalizedStringFromTable(@"Rotate", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [bnBtn setImage:[UIImage imageNamed:@"editBnBtn"] forState:UIControlStateNormal];
    [bnBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    [bnBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
    bnBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bnBtn addTarget:self action:@selector(rotateBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bnBtn];
    
    UIButton *cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cropBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    cropBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/7*6.5-10, CGRectGetHeight(self.view.frame) - 30, 20, 20);
    //[cropBtn setTitle:NSLocalizedStringFromTable(@"Done", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [cropBtn setImage:[UIImage imageNamed:@"editDoneBtn"] forState:UIControlStateNormal];
    UIColor *saveButtonTitleColor = !self.saveButtonTitleColor ?
    [UIColor saveButtonColor] : self.saveButtonTitleColor;
    [cropBtn setTitleColor:saveButtonTitleColor forState:UIControlStateNormal];
    
    UIColor *saveButtonHighlightTitleColor = !self.saveButtonHighlightTitleColor ?
    [UIColor saveButtonHighlightedColor] : self.saveButtonHighlightTitleColor;
    [cropBtn setTitleColor:saveButtonHighlightTitleColor forState:UIControlStateHighlighted];
    cropBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cropBtn addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cropBtn];
    [self setupWheel];
}

- (void) wheelDidChangeValue:(CGFloat)newValue{
    NSLog(@"wheelDidChangeValue%f",newValue);
    [self.photoView setAngle:-newValue];
}

-(void) wheelUp{
    [self.photoView dismissGridLines];
}

-(void) setupWheel{
    if (_singleMode){
        CGRect frame=CGRectMake(0, CGRectGetHeight(self.view.frame)/2.-CGRectGetWidth(self.view.frame)/2+CGRectGetWidth(self.view.frame)*0.15, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
        self.wheel = [[SMRotatoryWheel alloc] initWithFrame:frame
                                                andDelegate:self
                                               withSections:180 withHiddenMask:CGRectMake(0, frame.size.height-frame.size.width*0.17, frame.size.width, frame.size.width*0.17) withInitialRotation:M_PI/2.];
    } else{
        CGRect frame=CGRectMake(0, CGRectGetHeight(self.view.frame)/2.-CGRectGetWidth(self.view.frame)/2+CGRectGetWidth(self.view.frame)*0.15, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
        self.wheel = [[SMRotatoryWheel alloc] initWithFrame:frame
                                                andDelegate:self
                                               withSections:180 withHiddenMask:CGRectMake(frame.size.width*0.88, 0, frame.size.width*0.12, frame.size.width) withInitialRotation:0];
    }

    //wheel.backgroundColor=[UIColor greenColor];
    self.wheel.userInteractionEnabled=YES;
    // 3 - Add wheel to view
    [self.view addSubview:self.wheel];
}

- (void)cancelBtnTapped
{
    [self.delegate photoTweaksControllerDidCancel:self];
}

- (void)resetBtnTapped
{
    [self.photoView reset];
    [self.photoView dismissGridLines];
    [self.wheel resetRotation];
}

- (void)rotateBtnTapped
{
    [self.photoView rotate];
    [self.photoView dismissGridLines];
    [self.wheel resetRotation];
    
    
}



- (void)saveBtnTapped
{
    CGAffineTransform transform = CGAffineTransformIdentity;

    // translate
    CGPoint translation = [self.photoView photoTranslation];
    transform = CGAffineTransformTranslate(transform, translation.x, translation.y);

    // rotate
    transform = CGAffineTransformRotate(transform, self.photoView.angle);

    // scale
    CGAffineTransform t = self.photoView.photoContentView.transform;
    CGFloat xScale =  sqrt(t.a * t.a + t.c * t.c);
    CGFloat yScale = sqrt(t.b * t.b + t.d * t.d);
    transform = CGAffineTransformScale(transform, xScale, yScale);

    CGImageRef imageRef = [self newTransformedImage:transform
                                        sourceImage:self.image.CGImage
                                         sourceSize:self.image.size
                                  sourceOrientation:self.image.imageOrientation
                                        outputWidth:self.image.size.width
                                           cropSize:self.photoView.cropView.frame.size
                                      imageViewSize:self.photoView.photoContentView.bounds.size];

    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    if (self.autoSaveToLibray) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
            }
        }];
    }

    [self.delegate photoTweaksController:self didFinishWithCroppedImage:image];
}

- (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality
{
    CGSize srcSize = size;
    CGFloat rotation = 0.0;

    switch(orientation)
    {
        case UIImageOrientationUp: {
            rotation = 0;
        } break;
        case UIImageOrientationDown: {
            rotation = M_PI;
        } break;
        case UIImageOrientationLeft:{
            rotation = M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        case UIImageOrientationRight: {
            rotation = -M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        default:
            break;
    }

    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8,  //CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst  //CGImageGetBitmapInfo(source)
                                                 );

    CGContextSetInterpolationQuality(context, quality);
    CGContextTranslateCTM(context,  size.width/2,  size.height/2);
    CGContextRotateCTM(context,rotation);

    CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                           -srcSize.height/2,
                                           srcSize.width,
                                           srcSize.height),
                       source);

    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    return resultRef;
}

- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize
{
    CGImageRef source = [self newScaledImage:sourceImage
                             withOrientation:sourceOrientation
                                      toSize:sourceSize
                                 withQuality:kCGInterpolationNone];

    CGFloat aspect = cropSize.height/cropSize.width;
    CGSize outputSize = CGSizeMake(outputWidth, outputWidth*aspect);

    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 outputSize.width,
                                                 outputSize.height,
                                                 CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 CGImageGetBitmapInfo(source));
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));

    CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width,
                                                            outputSize.height / cropSize.height);
    uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width/2.0, cropSize.height / 2.0);
    uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
    CGContextConcatCTM(context, uiCoords);

    CGContextConcatCTM(context, transform);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, CGRectMake(-imageViewSize.width/2.0,
                                           -imageViewSize.height/2.0,
                                           imageViewSize.width,
                                           imageViewSize.height)
                       , source);

    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(source);
    return resultRef;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
