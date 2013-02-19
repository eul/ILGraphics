#import <ILCharts/Series/ILSeries.h>
#import <ILCharts/Series/ILValuesSeriesDataSource.h>

#import <Foundation/Foundation.h>

@protocol ILBarsSeriesDelegate;

@interface ILBarsSeries : NSObject <ILSeries, ILValuesSeriesDataSource>

@property (nonatomic, weak) id <SCBarsSeriesDelegate> delegate;

@property (nonatomic) BOOL horizontal;

@end
