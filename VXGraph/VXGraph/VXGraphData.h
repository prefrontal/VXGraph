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

@property (nonatomic,retain) NSString *xDataTitle;
@property (nonatomic,retain) NSString *yDataTitle;

// Metadata Access Methods
-(int)count;

-(double)xMaximum;
-(double)xMinimum;
-(double)xAverage;

-(double)yMaximum;
-(double)yMinimum;
-(double)yAverage;

@end
