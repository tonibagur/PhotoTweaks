//
//  WheelIndicator.m
//  RotatoryWheelProject
//
//  Created by Toni Bagur on 28/3/16.
//  Copyright © 2016 Toni Bagur. All rights reserved.
//

#import "WheelIndicator.h"

#import <QuartzCore/QuartzCore.h>

@implementation WheelIndicator
- (id) initWithFrame:(CGRect)frame withLabelFrame:(CGRect)labelFrame withCircleFrame:(CGRect)circleFrame withLabelRotation:(CGFloat)labelRotation withLabelText:(NSString*)labelText showLabel:(BOOL) showLabel{
    // 1 - Call super init
    if ((self = [super initWithFrame:frame])) {
        //self.backgroundColor=[UIColor redColor];
        // 2 - Set properties
        
        UIColor* c = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
        if (showLabel){
            self.labelFrame = labelFrame;
            self.labelRotation = labelRotation;
            self.labelText = labelText;
            self.label = [[UILabel alloc] initWithFrame:labelFrame];
            //self.label.backgroundColor=[UIColor greenColor];
            self.label.transform=CGAffineTransformMakeRotation(3.14/2.0);
            self.label.text=self.labelText;
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.font = [UIFont systemFontOfSize:10];
            self.label.textColor = c;
            [self addSubview:self.label];
        }
        
        
        self.circleView = [[UIView alloc] initWithFrame:circleFrame];
        self.circleView.alpha = 0.5;
        self.circleView.layer.cornerRadius = CGRectGetWidth(circleFrame)/2.0;
        self.circleView.backgroundColor = c;
        [self addSubview:self.circleView];
        
    }
    return self;
}
@end
