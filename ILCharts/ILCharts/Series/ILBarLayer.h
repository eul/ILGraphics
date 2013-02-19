#import <QuartzCore/QuartzCore.h>

@class ILBarState;

@interface ILBarLayer : CALayer

@property (nonatomic) BOOL      useAnimation;
@property (nonatomic) CGFloat   value;
@property (nonatomic) UIColor  *fillColor;
@property (nonatomic) BOOL      horizontal;
@property (nonatomic) NSString *valueText;
@property (nonatomic) BOOL      showValue;
@property (nonatomic) UIFont   *valuesFont;
@property (nonatomic) BOOL      drawBarBorder;
@property (nonatomic) BOOL      drawGradient;
@property (nonatomic) CGFloat   barBorderWidth;
@property (nonatomic) CGFloat   roundCornerRadius;
@property (nonatomic) UIColor  *barBorderColor;
@property (nonatomic) UIColor  *valueTextColor;

@property (nonatomic, unsafe_unretained) CGGradientRef gradient;

- (void)setupWithBarState:(ILBarState *)state
                 animated:(BOOL)animated;

@end
