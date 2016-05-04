//
//  ViewController.m
//  VXGraph
//
//  Created by Craig Bennett on 5/1/16.
//  Copyright © 2016 Voxelwise. All rights reserved.
//

#import "VXGraphView.h"
#import "ViewController.h"

@interface ViewController ()
@property (weak) IBOutlet VXGraphView *mainGraph;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
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
