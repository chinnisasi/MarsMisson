//
//  Rover.h
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 27/07/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPoint.h"

typedef NS_ENUM(NSInteger, RoverDirection) {
    NORTH,
    EAST,
    SOUTH,
    WEST
};

@interface Rover : NSObject
@property (nonatomic, assign) RoverDirection direction;
@property (nonatomic, strong) RPoint* currentPoint;
@property (nonatomic, strong) RPoint* gridDimension;
@property (nonatomic, strong) NSMutableArray* obstaclesArr;
@property (nonatomic, strong) NSMutableArray *currentPointsArr;
- (void)updatePosition:(RPoint*)point;
- (BOOL)isSafeToMoveInDirection:(RoverDirection)direction offset:(NSInteger)offset;
-(void)setGridLayoutObstacles:(NSArray*)obstaclesArr;
- (RPoint*)currentLocation;
- (void)setCurrentLocation:(RPoint*)currentPoint;
-(BOOL)isValidCommand:(NSString*)string;
@end
