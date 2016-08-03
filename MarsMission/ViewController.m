//
//  ViewController.m
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 26/07/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "AppSettings.h"
#import "Rover.h"
#import "RPoint.h"
#import "RoverCellCollectionViewCell.h"

#define N 10
#define CELL_SIZE 50

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (strong, nonatomic) NSMutableArray* obstaclesArr;
@property (weak, nonatomic) IBOutlet UITextField *commandTxt;
@property (strong, nonatomic) Rover* rover;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSIndexPath* currentIndexPath;
@property (strong, nonatomic) NSMutableArray* highlightedPathArr;
@end

@implementation ViewController {
    BOOL isSafePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)reloadData
{
    [self customSetup];
    [self initContent];
    [self generateRandomNumberObstacles];
    [self.rover setGridLayoutObstacles:self.obstaclesArr];
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [AppSettings matrixSize];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [AppSettings matrixSize];
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoverCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"roverCell" forIndexPath:indexPath];
      cell.imgView.hidden = YES;
    if(indexPath.section == [self.rover currentLocation].x && indexPath.row == [self.rover currentLocation].y) {
        cell.imgView.hidden = NO;
    }
    if([self isIndexPathObstacle:indexPath]) {
        cell.layer.backgroundColor = [UIColor blackColor].CGColor;
    } else {
         cell.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    if([self isIndexPathHighLighted:indexPath]) {
         cell.layer.backgroundColor = [UIColor blueColor].CGColor;
    }
    return cell;
}

- (void)initContent
{
    self.obstaclesArr = [NSMutableArray array];
    self.rover = [[Rover alloc]init];
    if([AppSettings matrixSize] == 0) {
        [AppSettings setMatrixSize:N];
    }
    if([AppSettings cellSize] == 0) {
        [AppSettings setCellSize:50];
    }
    RPoint* point = [[RPoint alloc]initWithX:0 yValue:0];
    self.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.rover setCurrentPoint:point];
}

- (void)generateRandomNumberObstacles
{
    NSInteger matrixSize = [AppSettings matrixSize];
    for(NSInteger i = 0; i < matrixSize; i++) {
            NSInteger j = (NSInteger)(1 + arc4random_uniform(matrixSize-1));
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
        [self.obstaclesArr addObject:indexPath];
    }
}

- (BOOL)isIndexPathHighLighted:(NSIndexPath*)currentIndexPath
{
    BOOL isHighlighted = NO;
    if(isSafePath) {
        for (NSIndexPath* indexPath in self.highlightedPathArr) {
            if([currentIndexPath compare:indexPath] == NSOrderedSame) {
                isHighlighted = YES;
                break;
            }
        }
    }
    return isHighlighted;
}

- (BOOL)isIndexPathObstacle:(NSIndexPath*)currentIndexPath
{
    BOOL isObstacle = NO;
    for (NSIndexPath* indexPath in self.obstaclesArr) {
        if([currentIndexPath compare:indexPath] == NSOrderedSame) {
            isObstacle = YES;
            break;
        }
    }
    return isObstacle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.leftBarButton setTarget: self.revealViewController];
        [self.leftBarButton setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

- (IBAction)goAction:(id)sender {
    
    NSString* commandStr = self.commandTxt.text;
    [self deSelectPath];
    [self.rover.currentPointsArr removeAllObjects];
    [self.highlightedPathArr removeAllObjects];
    if([self.rover isValidCommand:commandStr]) {
        NSInteger strLen = [commandStr length];
        NSMutableString* tempStr = [NSMutableString string];
        isSafePath = YES;
        RPoint* currentLocation = [[self.rover currentLocation] copy];
        self.currentIndexPath = [NSIndexPath indexPathForItem:currentLocation.y inSection:currentLocation.x];
        for(NSInteger i = 0; i < strLen; i++) {
            char ch = [commandStr characterAtIndex:i];
            if(isdigit(ch)) {
                [tempStr appendFormat:@"%c", ch];
                continue;
            }
            NSInteger value = [tempStr integerValue];
            [tempStr setString:@""];
            if(ch == 'E') {
                if(![self.rover isSafeToMoveInDirection:EAST offset:value]) {
                    isSafePath = NO;
                    break;
                }
            } else if(ch == 'W') {
                if(![self.rover isSafeToMoveInDirection:WEST offset:value]) {
                    isSafePath = NO;
                    break;
                }
            } else if(ch == 'S') {
                if(![self.rover isSafeToMoveInDirection:SOUTH offset:value]) {
                    isSafePath = NO;
                    break;
                }
            } else if(ch == 'N') {
                if(![self.rover isSafeToMoveInDirection:NORTH offset:value]) {
                    isSafePath = NO;
                    break;
                }
            }
        }//end of for
        if(isSafePath) {
            self.highlightedPathArr = [[self.rover currentPointsArr] mutableCopy];
            [self.highlightedPathArr insertObject:self.currentIndexPath atIndex:0];
            [self highlightPath:[self.highlightedPathArr mutableCopy]];
             self.currentIndexPath  = [NSIndexPath indexPathForItem:[self.rover currentLocation].y inSection:[self.rover currentLocation].x];
        } else {
             self.highlightedPathArr = [[self.rover currentPointsArr] copy];
            [self alertNoPath:self.highlightedPathArr];
            [self.rover setCurrentLocation:currentLocation];
        }
    }
}

- (void)deSelectPath
{
    if(isSafePath && [self.highlightedPathArr count] > 0) {
        NSMutableArray* pointArr = [[self.rover currentPointsArr] mutableCopy];
        [pointArr insertObject:self.currentIndexPath atIndex:0];
        for (NSIndexPath* path in  self.highlightedPathArr) {
            RoverCellCollectionViewCell* cell = (RoverCellCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:path];
            cell.layer.backgroundColor = [UIColor whiteColor].CGColor;
        }
    }
}

- (void)alertNoPath:(NSArray*)arr
{
    RoverCellCollectionViewCell* cell = (RoverCellCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
    cell.imgView.hidden = NO;
    for (NSIndexPath* path in arr) {
        RoverCellCollectionViewCell* cell = (RoverCellCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:path];
        [UIView animateWithDuration:1.0f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                            animations:^{
                                [UIView setAnimationRepeatCount:3];
                                cell.layer.backgroundColor = [UIColor redColor].CGColor;
                            } completion:^(BOOL finished) {
                              cell.layer.backgroundColor = [UIColor whiteColor].CGColor;
                            }];
    }
}

- (void)highlightPath:(NSMutableArray*)pathArray;
{
    if([pathArray count] > 0) {
        __weak typeof(self) weakSelf = self;
        NSIndexPath* indexPath = [pathArray firstObject];
        [pathArray removeObjectAtIndex:0];
        RoverCellCollectionViewCell* cell = (RoverCellCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:1.0
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             cell.imgView.hidden = NO;
                             cell.imgView.image = [UIImage imageNamed:@"rover_normal.png"];
                              cell.layer.backgroundColor = [UIColor blueColor].CGColor;
                         } completion:^(BOOL finished) {
                             if([pathArray count] != 0) {
                                  cell.imgView.hidden = YES;
                             }
                             [weakSelf highlightPath:pathArray];
                         }];
    }
}


@end
