//
//  WheelIndicator.h
//  RotatoryWheelProject
//
//  Created by Toni Bagur on 28/3/16.
//  Copyright © 2016 Toni Bagur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WheelIndicator : UIControl
@property CGRect labelFrame;
@property CGFloat labelRotation;
@property NSString*  labelText;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) UIView* circleView;


- (id) initWithFrame:(CGRect)frame withLabelFrame:(CGRect)labelFrame withCircleFrame:(CGRect)circleFrame withLabelRotation:(CGFloat)labelRotation withLabelText:(NSString*)labelText showLabel:(BOOL) showLabel;
@end
