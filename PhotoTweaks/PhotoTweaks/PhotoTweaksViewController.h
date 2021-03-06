//
//  PhotoTweaksViewController.h
//  PhotoTweaks
//
//  Created by Tu You on 14/12/5.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRotatoryWheel.h"
#import "GPUImage.h"

@protocol PhotoTweaksViewControllerDelegate;

/**
 The photo tweaks controller.
 */
@interface PhotoTweaksViewController : UIViewController<SMRotatoryProtocol>

@property (nonatomic, strong) SMRotatoryWheel* wheel;

@property BOOL singleMode;

@property UISlider* sliderLight;
@property UISlider* sliderColor;
@property UISlider* sliderBn;
@property UIButton* lightBtn;
@property UIButton* colorBtn;
@property UIButton* bnBtn;
@property UIButton* cancelBtn;
@property UIButton* resetBtn;
@property UIButton* rotateBtn;
@property UIButton* cropBtn;
@property UISlider* lightSlider;
@property UISlider* colorSlider;
@property UISlider* bnSlider;

@property GPUImageMonochromeFilter* monoFilter;
@property GPUImageBrightnessFilter* lightFilter;
@property GPUImageContrastFilter* contrastFilter;
@property GPUImageSaturationFilter* saturationFilter;
@property GPUImagePicture* gpuPicture;










/**
 Image to process. Post GPUImageFilter
 */
@property (nonatomic, strong, readonly) UIImage *sourceImage;

/**
 Source image to process. Pre GPUImageFilter
 */
@property (nonatomic, strong, readonly) UIImage *image;


/**
 Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
 */
@property (nonatomic, assign) BOOL autoSaveToLibray;

/**
 The optional photo tweaks controller delegate.
 */
@property (nonatomic, weak) id<PhotoTweaksViewControllerDelegate> delegate;

/**
 Save action button's default title color
 */
@property (nonatomic, strong) UIColor *saveButtonTitleColor;

/**
 Save action button's highlight title color
 */
@property (nonatomic, strong) UIColor *saveButtonHighlightTitleColor;

/**
 Cancel action button's default title color
 */
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;

/**
 Cancel action button's highlight title color
 */
@property (nonatomic, strong) UIColor *cancelButtonHighlightTitleColor;

/**
 Reset action button's default title color
 */
@property (nonatomic, strong) UIColor *resetButtonTitleColor;

/**
 Reset action button's highlight title color
 */
@property (nonatomic, strong) UIColor *resetButtonHighlightTitleColor;

/**
 Slider tint color
 */
@property (nonatomic, strong) UIColor *sliderTintColor;

/**
 Creates a photo tweaks view controller with the image to process.
 */
- (instancetype)initWithImage:(UIImage *)image singleMode:(BOOL) mode;

@end

/**
 The photo tweaks controller delegate
 */
@protocol PhotoTweaksViewControllerDelegate <NSObject>

/**
 Called on image cropped.
 */
- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage;

/**
 Called on cropping image canceled
 */
- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller;

@end
