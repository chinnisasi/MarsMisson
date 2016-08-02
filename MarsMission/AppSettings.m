//
//  AppSettings.m
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 02/08/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings


+ (NSInteger)matrixSize
{
    NSInteger mSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"matrixSize"] intValue];
    return mSize;
}

+ (NSInteger)cellSize
{
    NSInteger cSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cellSize"] intValue];
    return cSize;
}

+ (void)setMatrixSize:(NSInteger)matrixSize
{
    [[NSUserDefaults standardUserDefaults] setInteger:matrixSize forKey:@"matrixSize"];

}

+ (void)setCellSize:(NSInteger)cellSize
{
     [[NSUserDefaults standardUserDefaults] setInteger:cellSize forKey:@"cellSize"];
}
@end
