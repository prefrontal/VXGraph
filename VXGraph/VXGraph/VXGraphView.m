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
@property CAShapeLayer *circleLayer;
@end

@implementation VXGraphView

- (void)awakeFromNib
{
    // Setup gradient to draw the background of the view
    [self setupBackgroundGradient];
    
    CGRect smallBounds = CGRectMake(self.bounds.origin.x+20, self.bounds.origin.y+20, self.bounds.size.width/2, self.bounds.size.height/2);
    CGPathRef path = CGPathCreateWithEllipseInRect(smallBounds, NULL);
    
    _circleLayer = [CAShapeLayer new];
    _circleLayer.path = path;
    _circleLayer.fillColor = [[NSColor clearColor] CGColor];
    _circleLayer.strokeColor = [[NSColor redColor] CGColor];
    _circleLayer.lineWidth = 5.0;
    _circleLayer.strokeEnd = 0.0;
    
    [self.layer addSublayer:_circleLayer];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    double YAXIS_OFFSET = 50.0;
    double XAXIS_OFFSET = 50.0;
    
    // Background Fill
    // Draw a basic gradient for the view background
    [self.backgroundGradient drawInRect:self.bounds angle:90.0];

    // Border Definition
    NSBezierPath *border = [NSBezierPath bezierPath];
    [border moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMinX([self bounds]), NSMaxY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMaxY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMinY([self bounds]))];
    [border lineToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [border setLineWidth:4.0];
    [[NSColor grayColor] set];
    [border stroke];

    // Draw Y-Axis
    NSBezierPath *yaxis = [NSBezierPath bezierPath];
    [yaxis moveToPoint:NSMakePoint(NSMinX([self bounds])+YAXIS_OFFSET, NSMinY([self bounds])+YAXIS_OFFSET)];
    [yaxis lineToPoint:NSMakePoint(NSMinX([self bounds])+YAXIS_OFFSET, NSMaxY([self bounds])-YAXIS_OFFSET)];
    [border setLineWidth:2.0];
    [[NSColor whiteColor] set];
    [yaxis stroke];

    // Draw X-Axis
    NSBezierPath *xaxis = [NSBezierPath bezierPath];
    [xaxis moveToPoint:NSMakePoint(NSMinX([self bounds])+XAXIS_OFFSET, NSMinY([self bounds])+XAXIS_OFFSET)];
    [xaxis lineToPoint:NSMakePoint(NSMaxX([self bounds])-XAXIS_OFFSET, NSMinY([self bounds])+XAXIS_OFFSET)];
    [border setLineWidth:2.0];
    [[NSColor whiteColor] set];
    [xaxis stroke];

    // Plotting stuff...
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

- (void)startAnimation
{
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = 10.0f;
    circleAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    circleAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _circleLayer.strokeEnd = 1.0f;
    [_circleLayer addAnimation:circleAnimation forKey:@"strokeEnd"];
}

@end
