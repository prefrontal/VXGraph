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
@end

@implementation VXGraphView

- (void) awakeFromNib
{
    // Setup gradient to draw the background of the view
    [self setupBackgroundGradient];
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
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.layer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
