#import "ILLayer.h"
#import <QuartzCore/QuartzCore.h>

@class ILBarsSeries;

@interface ILBarsGroupLayer : ILLayer

@property (nonatomic) ILBarsSeries *barsSeries;
@property (nonatomic) NSUInteger    groupIndex;
@property (nonatomic) BOOL          scrolling;

@end
