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

@property (weak) IBOutlet NSTextField *xAxisMaximumField;
@property (weak) IBOutlet NSTextField *xAxisMinimumField;
@property (weak) IBOutlet NSTextField *yAxisMaximumField;
@property (weak) IBOutlet NSTextField *yAxisMinimumField;

@property (weak) IBOutlet NSTextField *xTickIntervalField;
@property (weak) IBOutlet NSTextField *yTickIntervalField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    // Add data to the graph
    VXGraphData* data = [VXGraphData new];
    
    NSMutableArray *x = [NSMutableArray new];
    NSMutableArray *y = [NSMutableArray new];
    
    for (double i = -8*M_PI; i <= 8*M_PI; i += M_PI/800.0) {
        [x addObject:[NSNumber numberWithDouble:i]];
        [y addObject:[NSNumber numberWithDouble:cos(i)]];
    }
    
    [data setXData:x];
    [data setYData:y];
    
    [_mainGraph setGraphData:data];

    [self updateFields];
}

- (void) updateFields
{
    NSString *xAxisMaximum = [NSString stringWithFormat:@"%f", [_mainGraph xAxisMaximum]];
    [_xAxisMaximumField setStringValue:xAxisMaximum];

    NSString *xAxisMinimum = [NSString stringWithFormat:@"%f", [_mainGraph xAxisMinimum]];
    [_xAxisMinimumField setStringValue:xAxisMinimum];

    NSString *yAxisMaximum = [NSString stringWithFormat:@"%f", [_mainGraph yAxisMaximum]];
    [_yAxisMaximumField setStringValue:yAxisMaximum];

    NSString *yAxisMinimum = [NSString stringWithFormat:@"%f", [_mainGraph yAxisMinimum]];
    [_yAxisMinimumField setStringValue:yAxisMinimum];

    NSString *xTickInterval = [NSString stringWithFormat:@"%f", [_mainGraph xTickInterval]];
    [_xTickIntervalField setStringValue:xTickInterval];

    NSString *yTickInterval = [NSString stringWithFormat:@"%f", [_mainGraph yTickInterval]];
    [_yTickIntervalField setStringValue:yTickInterval];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)xAxisTickFieldChange:(id)sender {
    NSLog(@"Test!");
}
- (IBAction)yaxisTickFieldChanged:(id)sender {

}
- (IBAction)updateValuesButton:(id)sender {
    [self updateFields];
}

- (IBAction)action1:(id)sender {
    [_mainGraph startAnimation1];
}

- (IBAction)action2:(id)sender {
    [_mainGraph startAnimation2];
}

@end
