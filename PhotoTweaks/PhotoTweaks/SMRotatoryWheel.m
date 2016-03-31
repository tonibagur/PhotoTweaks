//
//  SMRotatoryWheel.m
//  RotatoryWheelProject
//
//  Created by Toni Bagur on 28/3/16.
//  Copyright © 2016 Toni Bagur. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SMRotatoryWheel.h"
#import "WheelIndicator.h"

CGFloat deltaAngle,angleDifference;

@implementation SMRotatoryWheel

@synthesize startTransform;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@synthesize delegate, container, numberOfSections;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber  withHiddenMask:(CGRect) hiddenMask withInitialRotation:(CGFloat) initialRotation{
    self.initialRotation=initialRotation;
    // 1 - Call super init
    if ((self = [super initWithFrame:frame])) {
        // 2 - Set properties
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
        // 3 - Draw wheel
        [self drawWheel];
        
        
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        self.maskRect = hiddenMask;
        
        // Create a path with the rectangle in it.
        CGPathRef path = CGPathCreateWithRect(self.maskRect, NULL);
        
        // Set the path to the mask layer.
        maskLayer.path = path;
        
        // Release the path since it's not covered by ARC.
        CGPathRelease(path);
        
        // Set the mask of the view.
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void) drawWheel {
    // 1
    container = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    // 2
    CGFloat angleSize = 2*M_PI/numberOfSections;
    // 3
    for (int i = 0; i < numberOfSections; i++) {
        // 4
        BOOL showLabel=(i%5==0);
        CGRect circleRect;
        if(showLabel){
            circleRect=CGRectMake(0, 7, 4, 4);
        }else{
            circleRect=CGRectMake(0, 9, 2, 2);
        }
        WheelIndicator * wi=[[WheelIndicator alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)/2.0, 20) withLabelFrame:CGRectMake(5, 5, 20, 10) withCircleFrame:circleRect  withLabelRotation:3.14/2. withLabelText:[NSString stringWithFormat:@"%i", -(i*2-180)] showLabel:showLabel];
        wi.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        // 5
        wi.layer.position = CGPointMake(container.bounds.size.width/2.0,
                                        container.bounds.size.height/2.0);
        wi.transform = CGAffineTransformMakeRotation(angleSize * i);
        wi.tag = i;
        //wi.backgroundColor=[UIColor redColor];
        // 6
        [container addSubview:wi];
    }
    // 7
    container.userInteractionEnabled = NO;
    //container.backgroundColor = [UIColor blueColor];
    
    [self addSubview:container];
    [self resetRotation];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(self.maskRect , point)){
        return self;
    }
    else{
        return nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"Began");
    // 1 - Get touch position
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    // 2 - Calculate distance from center
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    // 3 - Calculate arctangent value
    deltaAngle = atan2(dy,dx);
    // 4 - Save current transform
    startTransform = container.transform;
    self.initialAngle=self.currentAngle;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"Moved");
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x  - container.center.x;
    float dy = pt.y  - container.center.y;
    float ang = atan2(dy,dx);
    float limit=M_PI/4.;
    float angleDifference = MAX(MIN(deltaAngle - ang,limit-self.initialAngle),-limit-self.initialAngle);
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    self.currentAngle=self.initialAngle+angleDifference;
    [self.delegate wheelDidChangeValue:self.currentAngle];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate wheelUp];
}

- (void) resetRotation{
    self.currentAngle=0;
    container.transform=CGAffineTransformRotate(CGAffineTransformIdentity, self.initialRotation);
    
}


@end
