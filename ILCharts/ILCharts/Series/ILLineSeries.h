#import "ILSeries.h"

#import <Foundation/Foundation.h>

@protocol ILLineSeriesDelegate;

@interface ILLineSeries : NSObject <ILSeries>

@property (nonatomic, weak) id<ILLineSeriesDelegate> delegate;

@end
