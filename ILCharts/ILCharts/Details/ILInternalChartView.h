#include <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <JFFUtils/JFFMulticastDelegate.h>

@class UIView;
@class UIScrollView;

@protocol ILChartViewInternalDelegate;

@protocol ILInternalChartView <NSObject>

@required
@property (nonatomic) CGSize contentSize;

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIView       *contentView;
@property (nonatomic, readonly) CGRect       *contentViewInsetsPtr;

@property (nonatomic, readonly) JFFMulticastDelegate<ILChartViewInternalDelegate> *internalDelegate;

- (CGSize)getContentViewSize;

@end
