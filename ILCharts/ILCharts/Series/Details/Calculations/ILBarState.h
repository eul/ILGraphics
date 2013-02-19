#import <QuartzCore/QuartzCore.h>

@interface ILBarState : NSObject

@property (nonatomic) BOOL      horizontal;
@property (nonatomic) CGRect    frame;
@property (nonatomic) CGRect    groupFrame;
@property (nonatomic) CGFloat   value;
@property (nonatomic) UIColor  *fillColor;
@property (nonatomic) BOOL      drawBarBorder;
@property (nonatomic) BOOL      drawGradient;
@property (nonatomic) CGFloat   barBorderWidth;
@property (nonatomic) UIColor  *barBorderColor;
@property (nonatomic) CGRect    barRect;
@property (nonatomic) CGRect    valueDisplayingFrame;
@property (nonatomic) NSString *valueText;
@property (nonatomic) NSString *maxValueText;
@property (nonatomic) UIFont   *valueTextFont;

@property (nonatomic , unsafe_unretained) CGGradientRef gradient;

@end
