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
@end

@implementation VXGraphView

// -- Initialization --------------------------------------------------------

- (void)awakeFromNib
{

}

// -- Graph Drawing Methods ---------------------------------------------

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    [self drawBackgroundGradient];

    [self drawGraphData];

    [self drawGraphAxes];

    [self drawGraphAxisTicks];

    [self drawGraphOuterBorder];
}

- (void)drawBackgroundGradient
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

    // Draw a basic gradient for the view background
    [gradient drawInRect:self.bounds angle:90.0];
}

- (void)drawGraphOuterBorder
{
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

- (void)drawGraphAxes
{
    // Plotting Setup
    double graphBorderLeft = NSMinX([self bounds]);
    double graphBorderRight = NSMaxX([self bounds]);
    double graphBorderTop = NSMaxY([self bounds]);
    double graphBorderBottom = NSMinY([self bounds]);

    double xDataMinimum = [_graphData getXMinimum];
    double xDataMaximum = [_graphData getXMaximum];
    double yDataMinimum = [_graphData getYMinimum];
    double yDataMaximum = [_graphData getYMaximum];

    // Create data path
    double xScaleFactor = (graphBorderRight - graphBorderLeft) / (xDataMaximum - xDataMinimum);
    double yScaleFactor = (graphBorderTop - graphBorderBottom) / (yDataMaximum - yDataMinimum);

    // Draw Y-Axis
    NSBezierPath *yaxis = [NSBezierPath bezierPath];
    [yaxis moveToPoint:NSMakePoint((0.0-xDataMinimum) * xScaleFactor, graphBorderBottom)];
    [yaxis lineToPoint:NSMakePoint((0.0-xDataMinimum) * xScaleFactor, graphBorderTop)];
    [yaxis setLineWidth:2.0];
    [[NSColor grayColor] set];
    [yaxis stroke];

    // Draw X-Axis
    NSBezierPath *xaxis = [NSBezierPath bezierPath];
    [xaxis moveToPoint:NSMakePoint(graphBorderLeft, (0.0-yDataMinimum) * yScaleFactor)];
    [xaxis lineToPoint:NSMakePoint(graphBorderRight, (0.0-yDataMinimum) * yScaleFactor)];
    [xaxis setLineWidth:2.0];
    [[NSColor grayColor] set];
    [xaxis stroke];
}

- (void)drawGraphAxisTicks
{
    // Plotting Setup
    double graphBorderLeft = NSMinX([self bounds]);
    double graphBorderRight = NSMaxX([self bounds]);
    double graphBorderTop = NSMaxY([self bounds]);
    double graphBorderBottom = NSMinY([self bounds]);

    double xDataMinimum = [_graphData getXMinimum];
    double xDataMaximum = [_graphData getXMaximum];
    double yDataMinimum = [_graphData getYMinimum];
    double yDataMaximum = [_graphData getYMaximum];

    // Calculate data scale factors
    double xScaleFactor = (graphBorderRight - graphBorderLeft) / (xDataMaximum - xDataMinimum);
    double yScaleFactor = (graphBorderTop - graphBorderBottom) / (yDataMaximum - yDataMinimum);

    // Draw Y-Axis Ticks
    double yTickInterval = 2.0;
    double yTickLength = 10;

    double yTickNextPoint = yTickInterval * ceil(yDataMinimum / yTickInterval);
    NSBezierPath *yticks = [NSBezierPath bezierPath];

    while (yTickNextPoint < yDataMaximum)
    {
        //double x = (0.0-xDataMinimum) * xScaleFactor;
        double x = graphBorderLeft;
        double y = (yTickNextPoint-yDataMinimum) * yScaleFactor;
        [yticks moveToPoint:NSMakePoint(x, y)];
        [yticks lineToPoint:NSMakePoint(x + yTickLength, y)];
        yTickNextPoint += yTickInterval;
    }

    [yticks setLineWidth:1.0];
    [[NSColor grayColor] set];
    [yticks stroke];

    // Draw X-Axis Ticks
    double xTickInterval = 1.0;
    double xTickLength = 10;

    double xTickNextPoint = xTickInterval * ceil(xDataMinimum / xTickInterval);
    NSBezierPath *xTicks = [NSBezierPath bezierPath];

    while (xTickNextPoint < xDataMaximum)
    {
        double x = (xTickNextPoint-xDataMinimum) * xScaleFactor;
        //double y = (0.0-yDataMinimum) * yScaleFactor;
        double y = graphBorderBottom;
        [xTicks moveToPoint:NSMakePoint(x, y)];
        [xTicks lineToPoint:NSMakePoint(x, y + xTickLength)];
        xTickNextPoint += xTickInterval;
    }

    [xTicks setLineWidth:1.0];
    [[NSColor grayColor] set];
    [xTicks stroke];
}

- (void)drawGraphData
{
    // Plotting Setup
    double graphBorderLeft = NSMinX([self bounds]);
    double graphBorderRight = NSMaxX([self bounds]);
    double graphBorderTop = NSMaxY([self bounds]);
    double graphBorderBottom = NSMinY([self bounds]);

    double xDataMinimum = [_graphData getXMinimum];
    double xDataMaximum = [_graphData getXMaximum];
    double yDataMinimum = [_graphData getYMinimum];
    double yDataMaximum = [_graphData getYMaximum];

    // Calculate data scale factors
    double xScaleFactor = (graphBorderRight - graphBorderLeft) / (xDataMaximum - xDataMinimum);
    double yScaleFactor = (graphBorderTop - graphBorderBottom) / (yDataMaximum - yDataMinimum);

    CGMutablePathRef path = CGPathCreateMutable();

    for (int i = 0; i < [_graphData.xData count]; i++)
    {
        double x = [[_graphData.xData objectAtIndex:i] doubleValue];
        double y = [[_graphData.yData objectAtIndex:i] doubleValue];

        if (i == 0)
        {
            CGPathMoveToPoint (path, NULL, (x-xDataMinimum) * xScaleFactor, (y-yDataMinimum) * yScaleFactor);
            continue;
        }

        CGPathAddLineToPoint (path, NULL, (x-xDataMinimum) * xScaleFactor, (y-yDataMinimum) * yScaleFactor);
    }

    _dataPlotLayer = [CAShapeLayer new];
    _dataPlotLayer.path = path;
    _dataPlotLayer.fillColor = [[NSColor clearColor] CGColor];
    _dataPlotLayer.strokeColor = [[NSColor redColor] CGColor];
    _dataPlotLayer.lineWidth = 2.0;
    _dataPlotLayer.strokeEnd = 1.0;

    [self.layer addSublayer:_dataPlotLayer];
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
