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

@property (nonatomic,retain) VXGraphData *graphData;

// Border
@property (nonatomic,assign) double borderLineWidth;

// Axes
@property (nonatomic,assign) double yAxisMaximum;
@property (nonatomic,assign) double yAxisMinimum;

@property (nonatomic,assign) double xAxisMaximum;
@property (nonatomic,assign) double xAxisMinimum;

@property (nonatomic,assign) double axisLineWidth;
@property (nonatomic,retain) NSColor *axisColor;

// Ticks
@property (nonatomic,assign) double xTickInterval;
@property (nonatomic,assign) double yTickInterval;

@property (nonatomic,assign) double xTickLength;
@property (nonatomic,assign) double yTickLength;

@property (nonatomic,retain) NSColor *tickColor;

// Data
@property (nonatomic,assign) double dataLineWidth;
@property (nonatomic,retain) NSColor *dataColor;

- (void)startAnimation1;
- (void)startAnimation2;

@end
