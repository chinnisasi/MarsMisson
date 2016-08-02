//
//  MainViewController.m
//  MarsRoverMission
//
//  Created by Sasidhar Koti on 01/08/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "AppSettings.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *matrixSize;
@property (weak, nonatomic) IBOutlet UITextField *cellSize;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if([self.matrixSize.text integerValue] > 0 && [self.cellSize.text integerValue] > 0) {
        ViewController* viewController = segue.destinationViewController;
       
        
        [AppSettings setMatrixSize:[self.matrixSize.text integerValue]];
        [AppSettings setCellSize:[self.cellSize.text integerValue]];
        self.matrixSize.text = @"";
        self.cellSize.text = @"";
        
        [viewController reloadData];
    }
  
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
