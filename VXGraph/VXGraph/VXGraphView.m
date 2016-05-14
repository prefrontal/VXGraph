//
//  VXGraphView.m
//  Testing
//
//  Created by Craig Bennett on 5/1/16.
//  Copyright © 2016 Voxelwise. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VXGraphView.h"

@interface VXGraphView ()
@property CAShapeLayer *dataPlotLayer;

// Properties defining the view boundary cache
@property (nonatomic,assign) double graphBorderTop;
@property (nonatomic,assign) double graphBorderBottom;
@property (nonatomic,assign) double graphBorderLeft;
@property (nonatomic,assign) double graphBorderRight;

// Properties defining the data boundary cache
@property (nonatomic,assign) double xDataMinimum;
@property (nonatomic,assign) double xDataMaximum;
@property (nonatomic,assign) double yDataMinimum;
@property (nonatomic,assign) double yDataMaximum;

// Proeprties defining the data scale factor cache
@property (nonatomic,assign) double xScaleFactor;
@property (nonatomic,assign) double yScaleFactor;
@end

@implementation VXGraphView

// -- Initialization --------------------------------------------------------

- (void)awakeFromNib
{
    // Border Properties
    _borderLineWidth = 4.0;
    
    // Axis Properties
    _axisLineWidth = 2.0;
    _axisColor = [NSColor grayColor];
    
    // Axis Tick Properties
    _xTickInterval = 0.5;
    _yTickInterval = 0.5;

    _xTickLength = 10;
    _yTickLength = 10;
    
    _tickColor = [NSColor grayColor];
    
    // Data Properties
    _dataLineWidth = 2.0;
    _dataColor = [NSColor redColor];
    
    // View and data cache initialization
    _graphBorderLeft   = NSMinX([self bounds]);
    _graphBorderRight  = NSMaxX([self bounds]);
    _graphBorderTop    = NSMaxY([self bounds]);
    _graphBorderBottom = NSMinY([self bounds]);
    
    _xDataMinimum = -10;
    _xDataMaximum = 10;
    _yDataMinimum = -10;
    _yDataMaximum = 10;
    
    _xScaleFactor = 1;
    _yScaleFactor = 1;
}

// -- Graph Drawing Methods ---------------------------------------------
#pragma mark Graph Drawing Methods

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Do not proceed if there is no graph data object present
    if (!_graphData)
        return;
    
    // Plotting Setup
    _graphBorderLeft   = NSMinX([self bounds]);
    _graphBorderRight  = NSMaxX([self bounds]);
    _graphBorderTop    = NSMaxY([self bounds]);
    _graphBorderBottom = NSMinY([self bounds]);
    
    _xDataMinimum = [_graphData xMinimum];
    _xDataMaximum = [_graphData xMaximum];
    _yDataMinimum = [_graphData yMinimum];
    _yDataMaximum = [_graphData yMaximum];
    
    // Calculate data scale factors
    _xScaleFactor = (_graphBorderRight - _graphBorderLeft) / (_xDataMaximum - _xDataMinimum);
    _yScaleFactor = (_graphBorderTop - _graphBorderBottom) / (_yDataMaximum - _yDataMinimum);

    [self drawBackgroundGradient];

    [self drawGraphData];

    [self drawGraphAxes];

    [self drawGraphAxisTicks];

    [self drawGraphOuterBorder];
}

- (void)drawBackgroundGradient {
    // Draw a basic gradient for the view background
    CGFloat red1   =    0.0 / 255.0;
    CGFloat green1 =   72.0 / 255.0;
    CGFloat blue1  =  127.0 / 255.0;

    CGFloat red2    =   0.0 / 255.0;
    CGFloat green2  =  43.0 / 255.0;
    CGFloat blue2   =  76.0 / 255.0;

    NSColor* gradientTop    = [NSColor colorWithCalibratedRed:red1 green:green1 blue:blue1 alpha:1.0];
    NSColor* gradientBottom = [NSColor colorWithCalibratedRed:red2 green:green2 blue:blue2 alpha:1.0];
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:gradientBottom endingColor:gradientTop];

    [gradient drawInRect:self.bounds angle:90.0];
}

- (void)drawGraphOuterBorder {
    // Outer Border Definition
    NSBezierPath *border = [NSBezierPath bezierPath];
    [border moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMinX([self bounds]), NSMaxY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMaxY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMinY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [border setLineWidth:_borderLineWidth];
    [[NSColor grayColor] set];
    [border stroke];
}

- (void)drawGraphAxes {
    // Draw Y-Axis, but only if it is within the view
    if (_yDataMaximum < (_yDataMaximum - _yDataMinimum)) {
        NSBezierPath *yaxis = [NSBezierPath bezierPath];
        [yaxis moveToPoint:NSMakePoint((0.0-_xDataMinimum) * _xScaleFactor, _graphBorderBottom)];
        [yaxis lineToPoint:NSMakePoint((0.0-_xDataMinimum) * _xScaleFactor, _graphBorderTop)];
        [yaxis setLineWidth:_axisLineWidth];
        [_axisColor set];
        [yaxis stroke];
    }

    // Draw X-Axis, but only if it is within the view
    if (_xDataMaximum < (_xDataMaximum - _xDataMinimum)) {
        NSBezierPath *xaxis = [NSBezierPath bezierPath];
        [xaxis moveToPoint:NSMakePoint(_graphBorderLeft, (0.0-_yDataMinimum) * _yScaleFactor)];
        [xaxis lineToPoint:NSMakePoint(_graphBorderRight, (0.0-_yDataMinimum) * _yScaleFactor)];
        [xaxis setLineWidth:_axisLineWidth];
        [_axisColor set];
        [xaxis stroke];
    }
}

- (void)drawGraphAxisTicks {
    // Draw Y-Axis Ticks
    double yTickNextPoint = _yTickInterval * ceil(_yDataMinimum / _yTickInterval);
    NSBezierPath *yticks = [NSBezierPath bezierPath];

    while (yTickNextPoint < _yDataMaximum) {
        //double x = (0.0-xDataMinimum) * xScaleFactor;
        double x = _graphBorderLeft;
        double y = (yTickNextPoint-_yDataMinimum) * _yScaleFactor;
        [yticks moveToPoint:NSMakePoint(x, y)];
        [yticks lineToPoint:NSMakePoint(x + _yTickLength, y)];
        yTickNextPoint += _yTickInterval;
    }

    [yticks setLineWidth:1.0];
    [_tickColor set];
    [yticks stroke];

    // Draw X-Axis Ticks
    double xTickNextPoint = _xTickInterval * ceil(_xDataMinimum / _xTickInterval);
    NSBezierPath *xTicks = [NSBezierPath bezierPath];

    while (xTickNextPoint < _xDataMaximum) {
        double x = (xTickNextPoint-_xDataMinimum) * _xScaleFactor;
        //double y = (0.0-yDataMinimum) * yScaleFactor;
        double y = _graphBorderBottom;
        [xTicks moveToPoint:NSMakePoint(x, y)];
        [xTicks lineToPoint:NSMakePoint(x, y + _xTickLength)];
        xTickNextPoint += _xTickInterval;
    }

    [xTicks setLineWidth:1.0];
    [_tickColor set];
    [xTicks stroke];
}

- (void)drawGraphData {
    // Edge case: One or fewer data points
    if (1 >= [_graphData.xData count])
        return;
    
    // Draw the graph data
    CGMutablePathRef path = CGPathCreateMutable();

    for (int i = 0; i < [_graphData.xData count]; i++) {
        double x = [[_graphData.xData objectAtIndex:i] doubleValue];
        double y = [[_graphData.yData objectAtIndex:i] doubleValue];
        
        if (i == 0) {
            // Just move to the the point if this is the first element
            CGPathMoveToPoint (path, NULL, (x - _xDataMinimum) * _xScaleFactor, (y - _yDataMinimum) * _yScaleFactor);
            continue;
        }

        CGPathAddLineToPoint (path, NULL, (x - _xDataMinimum) * _xScaleFactor, (y -_yDataMinimum) * _yScaleFactor);
    }

    _dataPlotLayer = [CAShapeLayer new];
    _dataPlotLayer.path = path;
    _dataPlotLayer.fillColor = [[NSColor clearColor] CGColor];
    _dataPlotLayer.strokeColor = [_dataColor CGColor];
    _dataPlotLayer.lineWidth = _dataLineWidth;
    _dataPlotLayer.strokeEnd = 1.0;

    [self.layer addSublayer:_dataPlotLayer];
}

// -- Graph data methods ------------------------------------------------------



// -- Random methods ----------------------------------------------------------

- (void)startAnimation1 {
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = 4.0f;
    circleAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    circleAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _dataPlotLayer.strokeEnd = 1.0f;
    [_dataPlotLayer addAnimation:circleAnimation forKey:@"strokeEnd"];
}

- (void)startAnimation2 {
    // create a CGPath that implements two arcs (a bounce)
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,0.0,0.0);
    CGPathAddCurveToPoint(thePath,NULL,74.0,500.0,
                          320.0,500.0,
                          320.0,74.0);
    CGPathAddCurveToPoint(thePath,NULL,320.0,500.0,
                          566.0,500.0,
                          566.0,74.0);
    CGPathAddCurveToPoint(thePath,NULL,246.0,500.0,
                          246.0,500.0,
                          0.0,0.0);
    
    CAKeyframeAnimation *theAnimation;
    
    // Create the animation object, specifying the position property as the key path.
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.duration=5.0;
    
    // Add the animation to the layer.
    [_dataPlotLayer addAnimation:theAnimation forKey:@"position"];

}

@end
