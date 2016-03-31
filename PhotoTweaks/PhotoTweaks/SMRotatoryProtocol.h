//
//  SMRotatoryProtocol.h
//  RotatoryWheelProject
//
//  Created by Toni Bagur on 28/3/16.
//  Copyright © 2016 Toni Bagur. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMRotatoryProtocol <NSObject>

- (void) wheelDidChangeValue:(CGFloat)newValue;
- (void) wheelUp;
@end
