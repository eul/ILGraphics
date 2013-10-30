#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

static const double DOUBLE_M_PI = 2.f * M_PI;

@interface ILChartsMath:NSObject

+(CGFloat)distanceFromPoint:(CGPoint)pointA_
                    toPoint:(CGPoint)pointB_;

+(CGFloat)angleBetweenPoint:(CGPoint)pointA_
                   andPoint:(CGPoint)pointB_;

@end

