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

@property NSGradient* backgroundGradient;
@property CAShapeLayer *dataPlotLayer;

@property double XAXIS_OFFSET;
@property double YAXIS_OFFSET;

@end

@implementation VXGraphView

// -- Initialization --------------------------------------------------------

- (void)awakeFromNib
{
    // Initialize member variables
    _XAXIS_OFFSET = 50;
    _YAXIS_OFFSET = 50;
    
    // Setup gradient to draw the background of the view
    [self setupBackgroundGradient];

//    // Everything is normalized to the maximum x-value
//    double xmax = self.bounds.size.width - _XAXIS_OFFSET;
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    // Segment 1
//    CGPathMoveToPoint (path, NULL, _XAXIS_OFFSET, _YAXIS_OFFSET);
//    CGPathAddLineToPoint (path, NULL, (858.0/880.0)*xmax, (160.0/880.0)*xmax);
//    CGPathAddLineToPoint (path, NULL, xmax, _YAXIS_OFFSET);
//    // Segment 2
//    CGPathMoveToPoint (path, NULL, _XAXIS_OFFSET, _YAXIS_OFFSET);
//    CGPathAddLineToPoint (path, NULL, (100.0/880.0)*xmax, (245.0/880.0)*xmax);
//    CGPathAddLineToPoint (path, NULL, xmax, _YAXIS_OFFSET);
//    // Segment 3
//    CGPathMoveToPoint (path, NULL, _XAXIS_OFFSET, _YAXIS_OFFSET);
//    CGPathAddLineToPoint (path, NULL, (277.0/880.0)*xmax, (406.0/880.0)*xmax);
//    CGPathAddLineToPoint (path, NULL, xmax, _YAXIS_OFFSET);
//    // Segment 4
//    CGPathMoveToPoint (path, NULL, _XAXIS_OFFSET, _YAXIS_OFFSET);
//    CGPathAddLineToPoint (path, NULL, (580.0/880.0)*xmax, (419.0/880.0)*xmax);
//    CGPathAddLineToPoint (path, NULL, xmax, _YAXIS_OFFSET);
//    // Segment 5
//    CGPathMoveToPoint (path, NULL, _XAXIS_OFFSET, _YAXIS_OFFSET);
//    CGPathAddLineToPoint (path, NULL, (723.0/880.0)*xmax, (337.0/880.0)*xmax);
//    CGPathAddLineToPoint (path, NULL, xmax, _YAXIS_OFFSET);
//    
//    _dataPlotLayer = [CAShapeLayer new];
//    _dataPlotLayer.path = path;
//    _dataPlotLayer.fillColor = [[NSColor clearColor] CGColor];
//    _dataPlotLayer.strokeColor = [[NSColor redColor] CGColor];
//    _dataPlotLayer.lineWidth = 3.0;
//    _dataPlotLayer.strokeEnd = 0.0;
//    
//    [self.layer addSublayer:_dataPlotLayer];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Draw a basic gradient for the view background
    [self.backgroundGradient drawInRect:self.bounds angle:90.0];

    // Plotting Setup
    double graphBorderLeft = NSMinX([self bounds]) + _YAXIS_OFFSET;
    double graphBorderRight = NSMaxX([self bounds]) - _XAXIS_OFFSET;
    double graphBorderTop = NSMaxY([self bounds]) - _YAXIS_OFFSET;
    double graphBorderBottom = NSMinY([self bounds]) + _YAXIS_OFFSET;

    double xDataMinimum = [_graphData getXMinimum];
    double xDataMaximum = [_graphData getXMaximum];
    double yDataMinimum = [_graphData getYMinimum];
    double yDataMaximum = [_graphData getYMaximum];

    // Create data path
    double xScaleFactor = (graphBorderRight - graphBorderLeft) / (xDataMaximum - xDataMinimum);
    double yScaleFactor = (graphBorderTop - graphBorderBottom) / (yDataMaximum - yDataMinimum);

    CGMutablePathRef path = CGPathCreateMutable();

    for (int i = 0; i < [_graphData.xData count]; i++)
    {
        double x = [[_graphData.xData objectAtIndex:i] doubleValue];
        double y = [[_graphData.yData objectAtIndex:i] doubleValue];

        if (i == 0)
        {
            CGPathMoveToPoint (path, NULL, (x-xDataMinimum) * xScaleFactor + _XAXIS_OFFSET, (y-yDataMinimum) * yScaleFactor + _YAXIS_OFFSET);
            continue;
        }

        CGPathAddLineToPoint (path, NULL, (x-xDataMinimum) * xScaleFactor + _XAXIS_OFFSET, (y-yDataMinimum) * yScaleFactor + _YAXIS_OFFSET);
    }

    _dataPlotLayer = [CAShapeLayer new];
    _dataPlotLayer.path = path;
    _dataPlotLayer.fillColor = [[NSColor clearColor] CGColor];
    _dataPlotLayer.strokeColor = [[NSColor redColor] CGColor];
    _dataPlotLayer.lineWidth = 2.0;
    _dataPlotLayer.strokeEnd = 1.0;

    [self.layer addSublayer:_dataPlotLayer];

    // Draw Y-Axis
    NSBezierPath *yaxis = [NSBezierPath bezierPath];
    [yaxis moveToPoint:NSMakePoint((0.0-xDataMinimum) * xScaleFactor + _YAXIS_OFFSET, graphBorderBottom)];
    [yaxis lineToPoint:NSMakePoint((0.0-xDataMinimum) * xScaleFactor + _YAXIS_OFFSET, graphBorderTop)];
    [yaxis setLineWidth:2.0];
    [[NSColor grayColor] set];
    [yaxis stroke];

    // Draw X-Axis
    NSBezierPath *xaxis = [NSBezierPath bezierPath];
    [xaxis moveToPoint:NSMakePoint(graphBorderLeft, (0.0-yDataMinimum) * yScaleFactor + _YAXIS_OFFSET)];
    [xaxis lineToPoint:NSMakePoint(graphBorderRight, (0.0-yDataMinimum) * yScaleFactor + _YAXIS_OFFSET)];
    [yaxis setLineWidth:2.0];
    [[NSColor grayColor] set];
    [xaxis stroke];

    // Draw Y-Axis Ticks

    // Draw X-Axis Ticks

    // Graph Border Definition
    NSBezierPath *graphBorder = [NSBezierPath bezierPath];
    [graphBorder moveToPoint:NSMakePoint(graphBorderLeft, graphBorderBottom)];
    [graphBorder lineToPoint:NSMakePoint(graphBorderLeft, graphBorderTop)];
    [graphBorder lineToPoint:NSMakePoint(graphBorderRight, graphBorderTop)];
    [graphBorder lineToPoint:NSMakePoint(graphBorderRight, graphBorderBottom)];
    [graphBorder lineToPoint:NSMakePoint(graphBorderLeft, graphBorderBottom)];
    [graphBorder setLineWidth:1.0];
    [[NSColor whiteColor] set];
    [graphBorder stroke];

    // Outer Border Definition
    NSBezierPath *border = [NSBezierPath bezierPath];
    [border moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMinX([self bounds]), NSMaxY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMaxY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMinY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [border setLineWidth:4.0];
    [[NSColor grayColor] set];
    [border stroke];

}

// -- Methods to help with drawing ---------------------------------------------

- (void)setupBackgroundGradient
{
    CGFloat red1   =    0.0 / 255.0;
    CGFloat green1 =   72.0 / 255.0;
    CGFloat blue1  =  127.0 / 255.0;

    CGFloat red2    =   0.0 / 255.0;
    CGFloat green2  =  43.0 / 255.0;
    CGFloat blue2   =  76.0 / 255.0;

    NSColor* gradientTop    = [NSColor colorWithCalibratedRed:red1 green:green1 blue:blue1 alpha:1.0];
    NSColor* gradientBottom = [NSColor colorWithCalibratedRed:red2 green:green2 blue:blue2 alpha:1.0];
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:gradientBottom endingColor:gradientTop];

    self.backgroundGradient = gradient;
}

// -- Graph data methods ------------------------------------------------------



// -- Random methods ----------------------------------------------------------

- (void)startAnimation1
{
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = 4.0f;
    circleAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    circleAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _dataPlotLayer.strokeEnd = 1.0f;
    [_dataPlotLayer addAnimation:circleAnimation forKey:@"strokeEnd"];
}

- (void)startAnimation2
{
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
