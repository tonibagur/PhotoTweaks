//
//  SMRotatoryWheel.h
//  RotatoryWheelProject
//
//  Created by Toni Bagur on 28/3/16.
//  Copyright © 2016 Toni Bagur. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SMRotatoryProtocol.h"

@interface SMRotatoryWheel : UIView

@property (weak) id <SMRotatoryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property CGFloat initialAngle;
@property CGFloat currentAngle;
@property CGRect maskRect;
@property CGFloat initialRotation;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber withHiddenMask:(CGRect) hiddenMask withInitialRotation:(CGFloat) initialRotation;

- (void) resetRotation;

@end
