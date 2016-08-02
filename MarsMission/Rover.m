//
//  Rover.m
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 27/07/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import "Rover.h"
#import "AppSettings.h"
#import <UIKit/UITableView.h>
#import <UIKit/UICollectionView.h>

@interface Rover ()
@end

@implementation Rover {
    NSInteger **grid;
    NSInteger dimension;
}

- (instancetype)init
{
    if(self = [super init]) {
        self.direction = EAST;
        self.currentPointsArr = [NSMutableArray array];
    }
    return self;
}

-(void)setGridLayoutObstacles:(NSArray*)obstaclesArr
{
    dimension = [AppSettings matrixSize];
    if(grid){
        [self destroyTwoDimenArrayOnHeapUsingFree:grid row:dimension col:dimension];
    }
    grid = (NSInteger **)malloc(dimension * sizeof(NSInteger));
    for (NSInteger i = 0; i < dimension; i++) {
        grid[i] = (NSInteger *)malloc(dimension * sizeof(NSInteger));
    }
    
    for(NSInteger i = 0; i < dimension; i++) {
        for(NSInteger j = 0; j < dimension; j++) {
            grid[i][j] = 0;
        }
    }
    for(NSIndexPath* indexPath in obstaclesArr) {
        NSInteger row = [indexPath row];
        NSInteger section = [indexPath section];
        grid[section][row] = 1;
    }
   
}

- (void) destroyTwoDimenArrayOnHeapUsingFree:(NSInteger **) ptr row:(NSInteger) row col:(NSInteger) col
{
    for(NSInteger i = 0; i < row; i++)
    {
        free(ptr[i]);
    }
    free(ptr);
}

- (void)printGrid
{
    for(int i = 0; i<dimension; i++)
    {
        for(int j = 0; j<dimension; j++)
        {
            printf("%ld", (long)grid[i][j]);
            printf("\t");
            
        }
        printf("\n");
    }
}

- (void)updatePosition:(RPoint*)point
{
    self.currentPoint = point;
}



- (BOOL)isSafeToMoveInDirection:(RoverDirection)direction offset:(NSInteger)offset
{
    NSInteger xValue = self.currentPoint.x;
    NSInteger yValue = self.currentPoint.y;
    if(offset > 0) {
        BOOL isBoundaryCondition = NO;
        if (direction == NORTH) {
            for(NSInteger i = 0; i < offset; ++i) {
                xValue--;
                if(![self evaluteBoundaryCondition:xValue yValue:yValue]) {
                    isBoundaryCondition = YES;
                    break;
                }
            }
            if(isBoundaryCondition) {
                return NO;
            }
        } else if (direction == SOUTH) {
            for(NSInteger i = 0; i < offset; ++i) {
                xValue++;
                if(![self evaluteBoundaryCondition:xValue yValue:yValue]) {
                    isBoundaryCondition = YES;
                    break;
                }
            }
            if(isBoundaryCondition) {
                return NO;
            }
        } else if (direction == EAST) {
            for(NSInteger i = 0; i < offset; ++i) {
                yValue++;
               
                if(![self evaluteBoundaryCondition:xValue yValue:yValue]) {
                    isBoundaryCondition = YES;
                    break;
                }
            }
            if(isBoundaryCondition) {
                return NO;
            }
            
        } else if (direction == WEST) {
            for(NSInteger i = 0; i < offset; ++i) {
                yValue--;
                if(![self evaluteBoundaryCondition:xValue yValue:yValue]) {
                    isBoundaryCondition = YES;
                    break;
                }
            }
            if(isBoundaryCondition) {
                return NO;
            }
        }
    }
    self.currentPoint.x = xValue;
    self.currentPoint.y = yValue;
    return YES;
}

- (BOOL)evaluteBoundaryCondition:(NSInteger)xValue yValue:(NSInteger)yValue
{
    if((xValue < 0 || yValue < 0) || ((xValue > dimension - 1) || (yValue > dimension-1))) {
        return NO;
    }
    if(grid[xValue][yValue]) {
        return NO;
    }
    [self.currentPointsArr addObject:[NSIndexPath indexPathForItem:yValue inSection:xValue]];

    return YES;
}

- (RPoint*)currentLocation
{
    return self.currentPoint;
}

- (void)setCurrentLocation:(RPoint*)currentPoint
{
    self.currentPoint.x = currentPoint.x;
    self.currentPoint.y = currentPoint.y;
}

-(BOOL)isValidCommand:(NSString*)string
{
    BOOL validCommand = NO;
    NSInteger strLen = [string length];
    NSMutableString *temp = [NSMutableString string];
    if((strLen > 1)) {
        for(NSInteger i = 0; i < strLen; i++) {
            if(i == strLen-1) {
                if((!isalpha([string characterAtIndex:i])) || !isdigit([string characterAtIndex:i-1])) {
                    validCommand = NO;
                } else {
                    char alphabet = (char)[string characterAtIndex:i];
                    if([self isValidDirectionChar:alphabet]) {
                        validCommand = YES;
                    } else {
                        validCommand = NO;
                        break;
                    }
                }
                break;
            }
            
            if(isdigit([string characterAtIndex:i])) {
                [temp appendFormat:@"%c", [string characterAtIndex:i]];
                continue;
            }
            if(i > 0) {
                if((!isalpha([string characterAtIndex:i])) || !isdigit([string characterAtIndex:i-1])) {
                    validCommand = NO;
                    break;
                }
                NSInteger value = [temp integerValue];
                if(value < 0) {
                    validCommand = NO;
                    break;
                }
                [temp setString:@""];
                char alphabet = (char)[string characterAtIndex:i];
                if([self isValidDirectionChar:alphabet]) {
                    validCommand = YES;
                } else {
                    validCommand = NO;
                    break;
                }
            }
        }
    }
    return validCommand;
}

- (BOOL)isValidDirectionChar:(char)alphabet
{
    if((alphabet ==  'E') || (alphabet == 'W') || (alphabet == 'N') || (alphabet == 'S')) {
        return YES;
    } else {
        return NO;
    }
}


@end
