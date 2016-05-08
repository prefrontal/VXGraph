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
    [data setXData:@[@1,@2,@3,@4,@5,@6]];
    [data setYData:@[@1,@4,@9,@16,@25,@36]];
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
