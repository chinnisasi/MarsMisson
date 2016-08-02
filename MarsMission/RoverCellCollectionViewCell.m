//
//  roverCellCollectionViewCell.m
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 27/07/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import "RoverCellCollectionViewCell.h"

@interface RoverCellCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *roverImgView;

@end
@implementation RoverCellCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setUp];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setUp];
    return self;
}

- (void)setUp
{
    self.imgView.hidden = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}
@end
