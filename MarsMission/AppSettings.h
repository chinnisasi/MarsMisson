//
//  AppSettings.h
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 02/08/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

+ (NSInteger)matrixSize;
+ (NSInteger)cellSize;
+ (void)setMatrixSize:(NSInteger)matrixSize;
+ (void)setCellSize:(NSInteger)cellSize;


@end
