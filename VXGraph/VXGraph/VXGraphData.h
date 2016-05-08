//
//  VXGraphData.h
//  VXGraph
//
//  Created by Craig Bennett on 5/6/16.
//  Copyright © 2016 Voxelwise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VXGraphData : NSObject

@property (nonatomic,retain) NSArray* xData;
@property (nonatomic,retain) NSArray* yData;

-(double)getXMaximum;
-(double)getXMinimum;

-(double)getYMaximum;
-(double)getYMinimum;

@end
