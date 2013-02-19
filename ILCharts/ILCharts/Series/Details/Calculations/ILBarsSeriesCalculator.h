#import <Foundation/Foundation.h>

@class ILBarState;
@class ILBarsContainerLayer;

@interface ILBarsSeriesCalculator : NSObject

@property (nonatomic, weak ) ILBarsContainerLayer *barsContainerLayer;

@property (nonatomic) NSMutableDictionary *barsState;
@property (nonatomic) NSUInteger barSize;

-(void)resetState;

- (NSUInteger)numberOfBars;
- (NSUInteger)numberOfValuesToDisplay;
- (NSInteger)nearestBarsGroupIndexToPoint:(CGPoint)point;
- (NSIndexPath *)barsIndexPathAtPoint:(CGPoint)point;
- (ILBarState *)stateForBarAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)frameForBarAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)frameForBarsGroupAtIndex:(NSUInteger)groupIndex;
- (CGRect)frameForValueDisplayingAtIndex:(NSUInteger)valueIndex;
- (NSIndexPath *)indexPathByIndex:(NSUInteger)index;
- (BOOL)shouldShowVerticalValuesText;

@end
