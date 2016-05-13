//
//  VXGraphData.m
//  VXGraph
//
//  Created by Craig Bennett on 5/6/16.
//  Copyright © 2016 Voxelwise. All rights reserved.
//

#import "VXGraphData.h"

@implementation VXGraphData

@synthesize xData;
@synthesize yData;

// -- Data Range Methods -------------------------------------------------------

-(double)xMaximum
{
    return [[xData valueForKeyPath: @"@max.self"] doubleValue];
}

-(double)xMinimum
{
    return [[xData valueForKeyPath: @"@min.self"] doubleValue];
}

-(double)yMaximum
{
    return [[yData valueForKeyPath: @"@max.self"] doubleValue];
}

-(double)yMinimum
{
    return [[yData valueForKeyPath: @"@min.self"] doubleValue];

}

@end
