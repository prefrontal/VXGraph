//
//  VXGraphView.h
//  Testing
//
//  Created by Craig Bennett on 5/1/16.
//  Copyright © 2016 Voxelwise. All rights reserved.
//

#import "VXGraphData.h"

#import <Cocoa/Cocoa.h>

@interface VXGraphView : NSView

- (void)startAnimation1;
- (void)startAnimation2;

@property (nonatomic,retain) VXGraphData *graphData;


// Axes
@property (nonatomic,retain) NSColor *axisColor;

// Ticks
@property (nonatomic,assign) double yTickInterval;
@property (nonatomic,assign) double yTickLength;
@property (nonatomic,assign) double xTickInterval;
@property (nonatomic,assign) double xTickLength;

@property (nonatomic,retain) NSColor *tickColor;

@end
