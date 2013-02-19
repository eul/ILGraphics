#import "ILSeries.h"
#import "ILValuesSeriesDataSource.h"

#import <Foundation/Foundation.h>

@protocol ILBarsSeriesDelegate;

@interface ILBarsSeries : NSObject <ILSeries, ILValuesSeriesDataSource>

@property (nonatomic, weak) id <ILBarsSeriesDelegate> delegate;

@property (nonatomic) BOOL horizontal;

@end
