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
#import "GPUImage.h"

@interface PhotoTweaksViewController ()

@property (strong, nonatomic) PhotoTweakView *photoView;

@end

@implementation PhotoTweaksViewController

- (instancetype)initWithImage:(UIImage *)image singleMode:(BOOL) mode
{
    self.singleMode=mode;
    if (self = [super init]) {
        _sourceImage = image;
        [self setupFilters];
        _image = [self transformImage:self.sourceImage withBnValue:0.5 withBnIntensity:0.];
        _autoSaveToLibray = YES;
    }
    return self;
}

-(void) setupFilters{
    self.gpuPicture=[[GPUImagePicture alloc] initWithImage:_sourceImage];
    self.monoFilter=[[GPUImageMonochromeFilter alloc] init];
    [self.gpuPicture addTarget:self.monoFilter];
    

    

}

- (UIImage*) transformImage:(UIImage*) sourceImage withBnValue:(CGFloat) bnValue withBnIntensity:(CGFloat) bnIntensity{
    GPUVector4 color;
    color.one=bnValue;color.two=bnValue;color.three=bnValue;color.four=1;
    self.monoFilter.color=color;
    self.monoFilter.intensity=bnIntensity;
    
    [self.monoFilter useNextFrameForImageCapture];
    [self.gpuPicture processImage];
    UIImage* processedImg = [self.monoFilter imageFromCurrentFramebuffer];
    processedImg = [UIImage imageWithCGImage:[processedImg CGImage] scale:1.0 orientation:self.sourceImage.imageOrientation];
    return processedImg;

}

-(void) setImage:(UIImage *)image{
    _image=image;
    self.photoView.photoContentView.image=image;
    self.photoView.photoContentView.imageView.image=image;
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

-(CGRect) getRectForButtonAtPos:(NSInteger) pos{
    return CGRectMake(CGRectGetWidth(self.view.frame)/7*(pos+0.5)-15, CGRectGetHeight(self.view.frame) - 35, 30, 30);
}

-(void) configureNormalBtn:(UIButton*) btn
                 withImage:(NSString*) image
              withSelector:(SEL) selector
                     atPos:(NSInteger) pos
{
    
    btn.frame = [self getRectForButtonAtPos:pos];
    btn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    btn.layer.cornerRadius=5;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void) configureSwitchBtn:(UIButton*) btn
        withImage:(NSString*) image
        withActiveImage:(NSString*) activeImage
        withSelector:(SEL) selector
        atPos:(NSInteger) pos
{
    
    [self configureNormalBtn:btn withImage:image withSelector:selector atPos:pos];
    [btn setImage:[UIImage imageNamed:activeImage] forState:UIControlStateSelected];

    [self.view addSubview:btn];
}

- (void)setupSubviews
{
    self.photoView = [[PhotoTweakView alloc] initWithFrame:self.view.bounds image:self.image singleMode:self.singleMode];
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.photoView];
    
    UIView* buttonBar=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame), 40 )];
    buttonBar.backgroundColor=[UIColor blackColor];
    buttonBar.alpha=0.85;
    [self.view addSubview:buttonBar];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureNormalBtn:self.cancelBtn
                   withImage:@"editCancelBtn"
                withSelector:@selector(cancelBtnTapped)
                       atPos:0];
    
    self.resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureNormalBtn:self.resetBtn
                   withImage:@"editResetBtn"
                withSelector:@selector(resetBtnTapped)
                       atPos:1];
    
    self.rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureNormalBtn:self.rotateBtn
                   withImage:@"editRotateBtn"
                withSelector:@selector(rotateBtnTapped)
                       atPos:2];

    self.lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureSwitchBtn:self.lightBtn
                   withImage:@"editLightBtn"
             withActiveImage:@"editLightBtnActive"
                withSelector:@selector(lightBtnTapped)
                       atPos:3];
    
    self.colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureSwitchBtn:self.colorBtn
                   withImage:@"editColorBtn"
             withActiveImage:@"editColorBtn"
                withSelector:@selector(colorBtnTapped)
                       atPos:4];
    
    self.bnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureSwitchBtn:self.bnBtn
                   withImage:@"editBnBtn"
             withActiveImage:@"editBnBtnActive"
                withSelector:@selector(bnBtnTapped)
                       atPos:5];
    
    self.cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureNormalBtn:self.cropBtn
                   withImage:@"editDoneBtn"
                withSelector:@selector(saveBtnTapped)
                       atPos:6];
    
    self.bnSlider=[[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-80, CGRectGetWidth(self.view.frame), 40 )];
    [self.bnSlider addTarget:self action:@selector(bnSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.bnSlider setBackgroundColor:[UIColor clearColor]];
    self.bnSlider.minimumValue = 0.0;
    self.bnSlider.maximumValue = 1.0;
    self.bnSlider.continuous = YES;
    self.bnSlider.value = 0.5;
    self.bnSlider.hidden=YES;
    [self.view addSubview:self.bnSlider];
    
    [self setupWheel];
}

- (void) bnSliderChanged:(id) sender{
    NSLog(@"BN slider changed:%f",self.bnSlider.value);
    self.image=[self transformImage:self.sourceImage withBnValue:self.bnSlider.value withBnIntensity:1.];
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

- (void)bnBtnTapped
{
    if ([self.bnBtn isSelected]){
        [self.bnBtn setSelected:NO];
        self.bnBtn.backgroundColor=[UIColor blackColor];
        self.bnSlider.hidden=YES;
    } else{
        [self.bnBtn setSelected:YES];
        self.bnBtn.backgroundColor=[UIColor whiteColor];
        self.bnSlider.hidden=NO;
    }
}

- (void)colorBtnTapped
{
    if ([self.colorBtn isSelected]){
        [self.colorBtn setSelected:NO];
        self.colorBtn.backgroundColor=[UIColor blackColor];
    } else{
        [self.colorBtn setSelected:YES];
        self.colorBtn.backgroundColor=[UIColor whiteColor];
    }
}

- (void)lightBtnTapped
{
    if ([self.lightBtn isSelected]){
        [self.lightBtn setSelected:NO];
        self.lightBtn.backgroundColor=[UIColor blackColor];
    } else{
        [self.lightBtn setSelected:YES];
        self.lightBtn.backgroundColor=[UIColor whiteColor];
    }
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
