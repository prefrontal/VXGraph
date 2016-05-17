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

@property (nonatomic,assign) double xLabelHeight;
@property (nonatomic,assign) double yLabelWidth;

// Properties defining the view boundary cache
@property (nonatomic,assign) double viewBorderTop;
@property (nonatomic,assign) double viewBorderBottom;
@property (nonatomic,assign) double viewBorderLeft;
@property (nonatomic,assign) double viewBorderRight;

// Properties defining the graph area boundary cache
@property (nonatomic,assign) double graphBorderTop;
@property (nonatomic,assign) double graphBorderBottom;
@property (nonatomic,assign) double graphBorderLeft;
@property (nonatomic,assign) double graphBorderRight;

// Properties defining the data boundary cache
@property (nonatomic,assign) double xDataMinimum;
@property (nonatomic,assign) double xDataMaximum;
@property (nonatomic,assign) double yDataMinimum;
@property (nonatomic,assign) double yDataMaximum;

// Properties defining the data scale factor cache
@property (nonatomic,assign) double xScaleFactor;
@property (nonatomic,assign) double yScaleFactor;

@end

@implementation VXGraphView

// -- Initialization --------------------------------------------------------
#pragma mark Class Initialization Methods

- (void)awakeFromNib
{
    _yLabelWidth = 0.0;
    _xLabelHeight = 100.0;

    // Border Properties
    _borderLineWidth = 2.0;
    
    // Axis Properties
    _axisLineWidth = 2.0;
    _axisColor = [NSColor grayColor];
    
    // Axis Tick Properties
    _xTickInterval = 2.0;
    _yTickInterval = 1.0;

    _xTickLength = 10;
    _yTickLength = 10;
    
    _tickColor = [NSColor grayColor];
    
    // Data Properties
    _dataLineWidth = 2.0;
    _dataColor = [NSColor redColor];
    
    // View and data cache initialization
    _viewBorderLeft   = NSMinX([self bounds]);
    _viewBorderRight  = NSMaxX([self bounds]);
    _viewBorderTop    = NSMaxY([self bounds]);
    _viewBorderBottom = NSMinY([self bounds]);

    _graphBorderTop    = _viewBorderTop - 10;
    _graphBorderBottom = _viewBorderBottom + 10;
    _graphBorderLeft   = _viewBorderLeft + 10;
    _graphBorderRight  = _viewBorderRight - 10;
    
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
    
    // Do not proceed if there is no graph data present
    if (!_graphData)
        return;
    
    // Reload caches prior to drawing
    _viewBorderLeft   = NSMinX([self bounds]);
    _viewBorderRight  = NSMaxX([self bounds]);
    _viewBorderTop    = NSMaxY([self bounds]);
    _viewBorderBottom = NSMinY([self bounds]);

    _xDataMinimum = [_graphData xMinimum];
    _xDataMaximum = [_graphData xMaximum];
    _yDataMinimum = [_graphData yMinimum] * 1.1;
    _yDataMaximum = [_graphData yMaximum] * 1.1;

    [self determineYLabelWidth];
    //[self drawXAxisLabels];

    _graphBorderTop    = _viewBorderTop;
    _graphBorderBottom = _viewBorderBottom + _xLabelHeight;
    _graphBorderLeft   = _viewBorderLeft + _yLabelWidth;
    _graphBorderRight  = _viewBorderRight;

    _xScaleFactor = (_graphBorderRight - _graphBorderLeft) / (_xDataMaximum - _xDataMinimum);
    _yScaleFactor = (_graphBorderTop - _graphBorderBottom) / (_yDataMaximum - _yDataMinimum);

    // Draw graph contents
    [self drawBackgroundGradient];
    [self drawYAxisLabels];
    [self drawXAxisLabels];



    [self drawGraphYAxis];
    [self drawGraphXAxis];
    [self drawGraphYAxisTicks];
    [self drawGraphXAxisTicks];
    [self drawGraphInnerBorder];
    [self drawGraphOuterBorder];

    if (1 < [_graphData.xData count])
        [self drawGraphData];
}

- (void) determineYLabelWidth {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName:@"Helvetica" size:14], NSFontAttributeName,
                                [NSColor grayColor], NSForegroundColorAttributeName,
                                nil];
    double yLabelPadding = 8.0;

    double yTickNextPoint = _yTickInterval * ceil(_yDataMinimum / _yTickInterval);

    while (yTickNextPoint < _yDataMaximum) {
        NSString* text = [NSString stringWithFormat:@"%1.1f", yTickNextPoint];
        NSAttributedString *currentText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        if (_yLabelWidth < [currentText size].width)
            _yLabelWidth = [currentText size].width + 2 * yLabelPadding;
        yTickNextPoint += _yTickInterval;
    }
}

- (void)determineXLabelHeight {

}

- (void)drawYAxisLabels {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName:@"Helvetica" size:14], NSFontAttributeName,
                                [NSColor grayColor], NSForegroundColorAttributeName,
                                nil];
    double yLabelPadding = 8.0;

    double yTickNextPoint = _yTickInterval * ceil(_yDataMinimum / _yTickInterval);

    while (yTickNextPoint < _yDataMaximum) {
        double x = _viewBorderLeft + yLabelPadding;
        double y = (yTickNextPoint-_yDataMinimum) * _yScaleFactor + _graphBorderBottom;

        // Draw tick label
        NSString* text = [NSString stringWithFormat:@"%1.1f", yTickNextPoint];
        NSAttributedString *currentText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        double yOffset = [currentText size].height / 2;
        NSPoint point = NSMakePoint(x, y - yOffset);
        [currentText drawAtPoint:point];

        if (_yLabelWidth < [currentText size].width)
            _yLabelWidth = [currentText size].width + 2 * yLabelPadding;

        yTickNextPoint += _yTickInterval;
    }
}

- (void)drawXAxisLabels {
    //_xLabelHeight = 40.0;
}

- (void)drawBackgroundGradient {
    // Draw a basic gradient for the view background
    NSColor* gradientTop    = [NSColor colorWithCalibratedRed:0.000 green:0.282 blue:0.498 alpha:1.0];
    NSColor* gradientBottom = [NSColor colorWithCalibratedRed:0.000 green:0.169 blue:0.298 alpha:1.0];
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:gradientBottom endingColor:gradientTop];

    [gradient drawInRect:self.bounds angle:90.0];
}

- (void)drawGraphInnerBorder {
    NSBezierPath *border = [NSBezierPath bezierPath];
    [border moveToPoint:NSMakePoint(NSMinX([self bounds])+_yLabelWidth, NSMinY([self bounds])+_xLabelHeight)];
    [border lineToPoint:NSMakePoint(NSMinX([self bounds])+_yLabelWidth, NSMaxY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMaxY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMinY([self bounds])+_xLabelHeight)];
    [border lineToPoint:NSMakePoint(NSMinX([self bounds])+_yLabelWidth, NSMinY([self bounds])+_xLabelHeight)];
    [border setLineWidth:_borderLineWidth];
    [[NSColor grayColor] set];
    [border stroke];
}

- (void)drawGraphOuterBorder {
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

- (void)drawGraphYAxis {
    // Draw Y-Axis, but only if it is within the view
    if (_yDataMaximum < (_yDataMaximum - _yDataMinimum)) {
        NSBezierPath *yaxis = [NSBezierPath bezierPath];
        [yaxis moveToPoint:NSMakePoint(-1.0 * _xDataMinimum * _xScaleFactor + _graphBorderLeft, _viewBorderBottom+_xLabelHeight)];
        [yaxis lineToPoint:NSMakePoint(-1.0 * _xDataMinimum * _xScaleFactor + _graphBorderLeft, _viewBorderTop)];
        [yaxis setLineWidth:_axisLineWidth];
        [_axisColor set];
        [yaxis stroke];
    }
}

- (void)drawGraphXAxis {
    // Draw X-Axis, but only if it is within the view
    if (_xDataMaximum < (_xDataMaximum - _xDataMinimum)) {
        NSBezierPath *xaxis = [NSBezierPath bezierPath];
        [xaxis moveToPoint:NSMakePoint(_viewBorderLeft+_yLabelWidth, -1.0 * _yDataMinimum * _yScaleFactor + _graphBorderBottom)];
        [xaxis lineToPoint:NSMakePoint(_viewBorderRight, -1.0 * _yDataMinimum * _yScaleFactor + _graphBorderBottom)];
        [xaxis setLineWidth:_axisLineWidth];
        [_axisColor set];
        [xaxis stroke];
    }
}

- (void)drawGraphYAxisTicks {
    double yTickNextPoint = _yTickInterval * ceil(_yDataMinimum / _yTickInterval);
    NSBezierPath *yticks = [NSBezierPath bezierPath];

    while (yTickNextPoint < _yDataMaximum) {
        double x = _graphBorderLeft;
        double y = (yTickNextPoint-_yDataMinimum) * _yScaleFactor + _xLabelHeight;

        [yticks moveToPoint:NSMakePoint(x, y)];
        [yticks lineToPoint:NSMakePoint(x + _yTickLength, y)];

        yTickNextPoint += _yTickInterval;
    }

    [yticks setLineWidth:1.0];
    [_tickColor set];
    [yticks stroke];
}

- (void)drawGraphXAxisTicks {
    double xTickNextPoint = _xTickInterval * ceil(_xDataMinimum / _xTickInterval);
    NSBezierPath *xTicks = [NSBezierPath bezierPath];

    while (xTickNextPoint < _xDataMaximum) {
        double x = (xTickNextPoint-_xDataMinimum) * _xScaleFactor + _yLabelWidth;
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
    CGMutablePathRef path = CGPathCreateMutable();

    for (int i = 0; i < [_graphData.xData count]; i++) {
        double x = [[_graphData.xData objectAtIndex:i] doubleValue];
        double y = [[_graphData.yData objectAtIndex:i] doubleValue];
        
        if (i == 0) {
            // Just move to the the point if this is the first element
            CGPathMoveToPoint (path, NULL, (x - _xDataMinimum) * _xScaleFactor + _yLabelWidth, (y - _yDataMinimum) * _yScaleFactor + _xLabelHeight);
            continue;
        }

        CGPathAddLineToPoint (path, NULL, (x - _xDataMinimum) * _xScaleFactor + _yLabelWidth, (y - _yDataMinimum) * _yScaleFactor + _xLabelHeight);
    }

    _dataPlotLayer = [CAShapeLayer new];
    _dataPlotLayer.path = path;
    _dataPlotLayer.fillColor = [[NSColor clearColor] CGColor];
    _dataPlotLayer.strokeColor = [_dataColor CGColor];
    _dataPlotLayer.lineWidth = _dataLineWidth;
    _dataPlotLayer.strokeEnd = 1.0;

    [self.layer addSublayer:_dataPlotLayer];
}

// -- Animation methods ----------------------------------------------------------
#pragma mark Graph Animation

- (void)startAnimation1 {
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = 4.0;
    circleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    circleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_dataPlotLayer setStrokeEnd:1.0];
    [_dataPlotLayer addAnimation:circleAnimation forKey:@"strokeEnd"];
}

- (void)startAnimation2 {
    // create a CGPath that implements two arcs (a bounce)
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint (thePath,NULL,0.0,0.0);
    CGPathAddCurveToPoint (thePath,NULL,74.0,500.0,320.0,500.0,320.0,74.0);
    CGPathAddCurveToPoint (thePath,NULL,320.0,500.0,566.0,500.0,566.0,74.0);
    CGPathAddCurveToPoint (thePath,NULL,246.0,500.0,246.0,500.0,0.0,0.0);
    
    // Create the animation object, specifying the position property as the key path
    CAKeyframeAnimation *theAnimation;
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    [theAnimation setPath:thePath];
    [theAnimation setDuration:5.0];
    
    // Add the animation to the layer.
    [_dataPlotLayer addAnimation:theAnimation forKey:@"position"];
}

@end
