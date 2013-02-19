#import "ILSeries.h"
#import <Foundation/Foundation.h>

@protocol ILValuesSeriesDataSource;

@protocol ILValuesSeries <ILSeries>

@property (nonatomic, weak) id <ILValuesSeriesDataSource> dataSource;

@end

@interface ILValuesSeries : NSObject <ILValuesSeries>

@property (nonatomic, weak) id <ILValuesSeriesDataSource> dataSource;

@end
