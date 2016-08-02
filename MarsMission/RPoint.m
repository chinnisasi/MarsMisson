

//
//  RPoint.m
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 27/07/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import "RPoint.h"

@implementation RPoint
- (instancetype)initWithX:(NSInteger)x yValue:(NSInteger)y
{
    if(self = [super init]) {
        self.x = x;
        self.y = y;
    }
    
    return self;
}

-(id)copyWithZone:(NSZone*)zone
{
    RPoint* rpoint = [RPoint new];
    rpoint.x = self.x;
    rpoint.y = self.y;
    return rpoint;
}
@end
