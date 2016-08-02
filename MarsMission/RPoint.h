//
//  RPoint.h
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 27/07/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPoint : NSObject
- (instancetype)initWithX:(NSInteger)x yValue:(NSInteger)y;
@property (nonatomic, assign)NSInteger x;
@property (nonatomic, assign)NSInteger y;
@end
