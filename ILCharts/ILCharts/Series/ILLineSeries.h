#import <ILCharts/Series/ILSeries.h>

#import <Foundation/Foundation.h>

@protocol ILLineSeriesDelegate;

@interface ILLineSeries : NSObject <ILCSeries>

@property (nonatomic, weak) id<SCLineSeriesDelegate> delegate;

@end
