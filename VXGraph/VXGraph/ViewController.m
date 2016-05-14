//
//  ViewController.m
//  VXGraph
//
//  Created by Craig Bennett on 5/1/16.
//  Copyright © 2016 Voxelwise. All rights reserved.
//

#import "VXGraphData.h"
#import "VXGraphView.h"
#import "ViewController.h"

@interface ViewController ()
@property (weak) IBOutlet VXGraphView *mainGraph;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    // Add data to the graph
    VXGraphData* data = [VXGraphData new];
    
    NSMutableArray *x = [NSMutableArray new];
    NSMutableArray *y = [NSMutableArray new];
    
    for (double i = -4*M_PI; i <= 4*M_PI; i += M_PI/20.0) {
        [x addObject:[NSNumber numberWithDouble:i]];
        [y addObject:[NSNumber numberWithDouble:10*sin(i)]];
    }
    
    [data setXData:x];
    [data setYData:y];
    
    [_mainGraph setGraphData:data];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)action1:(id)sender {
    [_mainGraph startAnimation1];
}

- (IBAction)action2:(id)sender {
    [_mainGraph startAnimation2];
}

@end
