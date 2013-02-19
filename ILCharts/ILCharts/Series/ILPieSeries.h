#import <ILCharts/Series/ILSeries.h>

#import <Foundation/Foundation.h>

@protocol ILPieSeriesDelegate;

@interface ILPieSeries : NSObject <ILSeries>

@property (nonatomic, weak) id<ILPieSeriesDelegate> delegate;

@end
