#import "ILBarsSeries+Private.h"

#import "ILBarsSeriesDelegate.h"
#import "ILBarsSeriesCalculator.h"

#include <objc/runtime.h>

static char ownershipsKey_;

@implementation ILBarsSeries (Private)

- (ILBarsSeriesCalculator *)calculator
{
    if ( !objc_getAssociatedObject(self, &ownershipsKey_))
    {
        objc_setAssociatedObject(self, &ownershipsKey_, [ILBarsSeriesCalculator new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &ownershipsKey_);
}

- (BOOL)useAnimation
{
    return [self.delegate respondsToSelector: @selector(useAnimationInBarsSeries:)]
           ? [self.delegate useAnimationInBarsSeries: self]
           : YES;
}

- (BOOL)respondsToUserInteraction
{
    return [self.delegate respondsToSelector: @selector(respondsToUserInteractionBarsSeries:)]
           ? [self.delegate respondsToUserInteractionBarsSeries: self]
           : NO;
}

- (UIColor *)backgroundColor
{
    return [self.delegate respondsToSelector: @selector(backgroundColorForBarsSeries:)]
           ? [self.delegate backgroundColorForBarsSeries: self]
           : [UIColor clearColor];
}

- (CGFloat)borderWidth
{
   return [self.delegate respondsToSelector: @selector(borderWidthForBarsSeries:)]
          ? [self.delegate borderWidthForBarsSeries: self]
          : 0.f;
}

- (UIColor *)borderColor
{
    return [self.delegate respondsToSelector: @selector(borderColorForBarsSeries:)]
           ? [self.delegate borderColorForBarsSeries: self]
           : [UIColor clearColor];
}

- (NSUInteger)groupsCount
{
    return [self.delegate numberOfGroupsInBarsSeries: self];
}

- (NSUInteger)numberOfBarsInGroup:(NSUInteger)groupIndex
{
    return [self.delegate barsSeries: self numberOfBarsInGroup: groupIndex];
}

- (CGFloat)valueForBarAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat value = [self.delegate barsSeries: self valueForBarAtIndexPath: indexPath];
    
    if (value < 0 || value > 1)
    {
        NSLog( @"[!!!WARNING!!!]SCBarsSeriesDelegate value should be in [0..1] interval" );
        value = 0.f;
    }

    return value;
}

- (UIColor *)fillColorForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate respondsToSelector: @selector(barsSeries:fillColorForBarAtIndexPath:)]
           ? [self.delegate barsSeries: self fillColorForBarAtIndexPath: indexPath]
           : [UIColor blackColor];
}

- (NSUInteger)maxGroupSize
{
    return [self.delegate respondsToSelector: @selector(maxGroupSizeInBarsSeries:)]
        ? [self.delegate maxGroupSizeInBarsSeries: self]
        : 50.f;
}

- (BOOL)drawBarBorderForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate respondsToSelector: @selector(barsSeries:drawBarBorderForBarAtIndexPath:)]
        ? [self.delegate barsSeries: self drawBarBorderForBarAtIndexPath: indexPath]
        : NO;
}

- (BOOL)drawGradientForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate respondsToSelector: @selector( barsSeries:drawGradientForBarAtIndexPath:)]
           ? [self.delegate barsSeries: self drawGradientForBarAtIndexPath: indexPath]
           : NO;
}

- (CGFloat)borderWidthForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate respondsToSelector: @selector( barsSeries:borderWidthForBarAtIndexPath:)]
           ? [self.delegate barsSeries: self borderWidthForBarAtIndexPath: indexPath]
           : 1.f;
}

- (UIColor *)borderColorForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate respondsToSelector: @selector(barsSeries:borderColorForBarAtIndexPath:)]
           ? [self.delegate barsSeries: self borderColorForBarAtIndexPath: indexPath]
           : [UIColor lightGrayColor];
}

- (CGGradientRef)gradientForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate respondsToSelector: @selector(barsSeries:gradientForBarAtIndexPath:)]
           ? [self.delegate barsSeries: self gradientForBarAtIndexPath: indexPath]
           : nil;
}

- (NSString *)valueTextAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate respondsToSelector: @selector( barsSeries:valueTextAtIndexPath:)]
           ? [self.delegate barsSeries: self valueTextAtIndexPath: indexPath]
           : nil;
}

- (NSString *)maxValueText
{
    return [self.delegate respondsToSelector: @selector(maxValueTextForBarsSeries:)]
        ? [self.delegate maxValueTextForBarsSeries: self]
        : nil;
}

- (UIFont *)valuesTextFont
{
    return [self.delegate respondsToSelector: @selector(valuesTextFontInBarsSeries:)]
           ? [self.delegate valuesTextFontInBarsSeries: self]
           : [UIFont systemFontOfSize: 10.f];
}

- (void)didTapBarAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.delegate respondsToSelector: @selector(barsSeries:didSelectBarAtIndexPath:)])
    {
        [self.delegate barsSeries: self didSelectBarAtIndexPath: indexPath];
    }
}

@end
