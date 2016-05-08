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

-(double)getXMaximum
{
    return [[xData valueForKeyPath: @"@max.self"] doubleValue];
}

-(double)getXMinimum
{
    return [[xData valueForKeyPath: @"@min.self"] doubleValue];
}

-(double)getYMaximum
{
    return [[yData valueForKeyPath: @"@max.self"] doubleValue];
}

-(double)getYMinimum
{
    return [[yData valueForKeyPath: @"@min.self"] doubleValue];

}

@end
