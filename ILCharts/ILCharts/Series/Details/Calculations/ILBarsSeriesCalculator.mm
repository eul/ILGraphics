#import "ILBarsSeriesCalculator.h"

#import "ILBarsSeries+Private.h"
#import "ILBarsContainerLayer.h"
#import "ILBarState.h"

@implementation ILBarsSeriesCalculator
{
    BOOL      _showValuesTextVerticaly;
    BOOL      _showValues;
    NSInteger _commonBarSize;
}

- (void)resetState
{
    self->_showValuesTextVerticaly = NO;
    self->_showValues    = YES;
    self->_commonBarSize = 0;

    [ self.barsState removeAllObjects ];
}

- (ILBarState *)stateForBarAtIndexPath:(NSIndexPath *)indexPath
{
    ILBarState *state = self.barsState[indexPath];
    if ( !state )
    {
        state = [ILBarState new ];

        state.horizontal     = self.barsContainerLayer.barsSeries.horizontal;
        state.frame          = [self frameForBarAtIndexPath:                                       indexPath];
        state.groupFrame     = [self frameForBarsGroupAtIndex: indexPath.section];
        state.value          = [self.barsContainerLayer.barsSeries valueForBarAtIndexPath:         indexPath];
        state.fillColor      = [self.barsContainerLayer.barsSeries fillColorForBarAtIndexPath:     indexPath];
        state.drawBarBorder  = [self.barsContainerLayer.barsSeries drawBarBorderForBarAtIndexPath: indexPath];
        state.drawGradient   = [self.barsContainerLayer.barsSeries drawGradientForBarAtIndexPath:  indexPath];
        state.barBorderWidth = [self.barsContainerLayer.barsSeries borderWidthForBarAtIndexPath:   indexPath];
        state.barBorderColor = [self.barsContainerLayer.barsSeries borderColorForBarAtIndexPath:   indexPath];
        state.gradient       = [self.barsContainerLayer.barsSeries gradientForBarAtIndexPath:      indexPath];
        state.valueText      = [self.barsContainerLayer.barsSeries valueTextAtIndexPath:           indexPath];
        state.maxValueText   = [self.barsContainerLayer.barsSeries maxValueText];
        state.valueTextFont  = [self.barsContainerLayer.barsSeries valuesTextFont];
        state.barRect        = [self barRectForBarWithState: state];
        state.valueDisplayingFrame = [self calculateFrameForValueDisplayingWithBarState: state];

        self.barsState[indexPath] = state;
    }
    return state;
}

//STODO fix this
- (ILBarState *)stateForBarAtIndex:(NSUInteger)index
{
    __block ILBarState *barState = nil;
    __block NSUInteger  counter  = 0;

    [self.barsState enumerateKeysAndObjectsUsingBlock: ^( NSIndexPath *statePath, ILBarState *state, BOOL *stop)
    {
        if ( counter == index)
        {
            barState = state;
            (*stop) = YES;
        }
        ++counter;
    } ];

    return barState;
}

- (NSUInteger)numberOfBars
{
    return [self.barsState count];
}

- (NSUInteger)numberOfValuesToDisplay
{
    return self->_showValues
        ? [self numberOfBars]
        : 0;
}

- (CGRect)frameForBarAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect result = CGRectZero;

    NSUInteger barSize = [ self barSizeAtIndexPath: indexPath ];
    CGRect groupFrame  = [ self frameForBarsGroupAtIndex: (NSUInteger)indexPath.section ];

    if ( self.barsContainerLayer.barsSeries.horizontal )
    {
        result.origin.y    = barSize * (NSUInteger)indexPath.row;
        result.size.width  = groupFrame.size.width;
        result.size.height = barSize;
    }
    else
    {
        result.origin.x    = barSize * (NSUInteger)indexPath.row;
        result.size.width  = barSize;
        result.size.height = groupFrame.size.height;
    }

    return CGRectIntegral( result );
}

- (CGRect)frameForBarsGroupAtIndex:(NSUInteger)groupIndex
{
    CGFloat groupsInterval = self.barsContainerLayer.barsSeries.horizontal
        ? self.barsContainerLayer.bounds.size.height / self.barsContainerLayer.barsSeries.groupsCount
        : self.barsContainerLayer.bounds.size.width  / self.barsContainerLayer.barsSeries.groupsCount;

    CGRect result = CGRectZero;
    CGFloat magicKoeficient = 1.5f;

    CGFloat groupSize = groupsInterval / magicKoeficient;

    groupSize = groupSize > self.barsContainerLayer.barsSeries.maxGroupSize
                 ? self.barsContainerLayer.barsSeries.maxGroupSize
                 : groupSize;

    CGFloat startOffset = [ self verticalGroupsStartOffset ];

    CGFloat startPosition = groupsInterval * groupIndex - groupSize / 2.f + startOffset;

    if ( !self.barsContainerLayer.barsSeries.horizontal )
    {
        result = CGRectMake( startPosition
                             , 0.f
                             , groupSize
                             , self.barsContainerLayer.bounds.size.height );
    }
    else
    {
        result = CGRectMake( 0.f
                             , startPosition
                             , self.barsContainerLayer.bounds.size.width
                             , groupSize );
    }

    return CGRectIntegral( result );
}

- (CGFloat)verticalGroupsStartOffset
{
    NSUInteger numOfGroups = self.barsContainerLayer.barsSeries.groupsCount;
    if ( 0 == numOfGroups )
        return 0.f;

    CGFloat result_ = 0.f;

    if ( !self.barsContainerLayer.barsSeries.horizontal )
    {
        result_ = self.barsContainerLayer.bounds.size.width / numOfGroups / 2.f;
    }
    else
    {
        result_ = self.barsContainerLayer.bounds.size.height / numOfGroups / 2.f;
    }
    return roundf( result_ );
}

- (NSUInteger)barSizeAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger barsCount = [ self.barsContainerLayer.barsSeries numberOfBarsInGroup: (NSUInteger)indexPath.section ];

    CGRect groupFrame = [ self frameForBarsGroupAtIndex: (NSUInteger)indexPath.section ];

    NSInteger result = self.barsContainerLayer.barsSeries.horizontal
                        ? (NSInteger)( groupFrame.size.height / barsCount )
                        : (NSInteger)( groupFrame.size.width  / barsCount );

    if ( self->_commonBarSize == 0 )
    {
        self->_commonBarSize = result;
    }

    if ( abs( self->_commonBarSize - result ) < 2 )
    {
        result = self->_commonBarSize;
    }

    return (NSUInteger)result;
}

- (CGRect)barRectForBarWithState:(ILBarState *)state
{
    CGRect result = CGRectZero;

    if ( !state.horizontal )
    {
        result = CGRectMake
        (
         0.f, 
         state.frame.size.height - state.frame.size.height * state.value, 
         state.frame.size.width, 
         state.frame.size.height * state.value
         );
    }
    else
    {
        result = CGRectMake
        (
         0.f, 
         0.f,
         state.frame.size.width * state.value, 
         state.frame.size.height
         );
    }
    return CGRectIntegral( result );
}

//STODO fix it
- (NSIndexPath *)indexPathByIndex:(NSUInteger)index
{
    return [ self.barsState allKeys ][index];
}

- (CGRect)inverseRect:(CGRect)rect
{
    return CGRectIntegral( CGRectMake( CGRectGetMidX( rect ) - rect.size.height / 2.f
                                      , CGRectGetMidY( rect ) - rect.size.width  / 2.f
                                      , rect.size.height
                                      , rect.size.width ) );
}

///EUL TO DO REFACTORING!!!
- (CGRect)calculateFrameForValueDisplayingWithBarState:(ILBarState *)state
{
    CGRect result = CGRectZero;

    if ( !state )
    {
        return result;
    }

    CGSize textSize = [state.valueText sizeWithFont: state.valueTextFont];
    CGSize maxTextSize = [state.maxValueText sizeWithFont: state.valueTextFont];

    static CGFloat widthIndent = 6.f;
    
    textSize.width += widthIndent;
    maxTextSize.width += widthIndent;

    if ( MIN( textSize.width, textSize.height ) > MIN( state.frame.size.width,  state.frame.size.height ) )
    {
        self->_showValues = NO;
        return CGRectZero;
    }

    result = CGRectIntegral( CGRectMake(  CGRectGetMidX( state.barRect ) - textSize.width  / 2.f
                                         , CGRectGetMidY( state.barRect ) - textSize.height / 2.f 
                                         , textSize.width
                                         , textSize.height ) );

    if ( !CGRectContainsRect( state.barRect , result ) )
    {
        if ( !state.horizontal && state.barRect.size.width < maxTextSize.width )
        {
            self->_showValuesTextVerticaly = YES;
        }
    }

    if ( CGRectIsEmpty( result) )
    {
        self->_showValues = NO;
    }

    return CGRectIntegral( result );
}

- (CGRect)normilizedToBarRectValueRect:(CGRect)rect
                                 state:(ILBarState *)state
{
    CGRect result = rect;

    CGSize maxTextSize = [ state.maxValueText sizeWithFont: state.valueTextFont ];
    if ( state.horizontal )
    {
        if ( state.barRect.size.width <= maxTextSize.width )
        {
            result.origin.x = CGRectGetMaxX( state.barRect ) + 4.f;
        }
        else
        {
            result.origin.x = fmaxf( 5.f, result.origin.x );
        }

        result.origin.y = CGRectGetMidY( state.barRect ) - result.size.height / 2.f;
    }
    else
    {
        if ( state.barRect.size.height < maxTextSize.height )
        {
            result.origin.y = CGRectGetMinY( state.barRect ) - result.size.height - 4.f;
        }

        result.origin.x = CGRectGetMidX( state.barRect ) - result.size.width / 2.f;
    }

    return result;
}

- (CGRect)frameForValueDisplayingAtIndex:(NSUInteger)valueIndex
{
    ILBarState *state = [self stateForBarAtIndex: valueIndex];

    if ( !state )
    {
        return CGRectZero;
    }

    CGRect result = ! CGRectIsEmpty( state.valueDisplayingFrame )
                    ? state.valueDisplayingFrame
                    : [self calculateFrameForValueDisplayingWithBarState: state];

    if (self->_showValuesTextVerticaly)
    {
        result = [self inverseRect: result];
    }

    result = [self normilizedToBarRectValueRect: result
                                          state: state];

    result.origin.x += state.groupFrame.origin.x + state.frame.origin.x;
    result.origin.y += state.groupFrame.origin.y + state.frame.origin.y;

    return result;
}

- (BOOL)shouldShowVerticalValuesText
{
    return self->_showValuesTextVerticaly;
}

- (NSInteger)nearestBarsGroupIndexToPoint:(CGPoint)point
{
    NSUInteger groupsCount = [self.barsContainerLayer.barsSeries groupsCount];
    if ( 0 == groupsCount )
        return -1;

    BOOL horizontal = self.barsContainerLayer.barsSeries.horizontal;

    CGFloat step = ( horizontal
                   ? self.barsContainerLayer.frame.size.height
                   : self.barsContainerLayer.frame.size.width ) / groupsCount;

    return (NSInteger)( ( horizontal ? point.y : point.x ) / step );
}

- (NSIndexPath *)barsIndexPathAtPoint:(CGPoint)point
{
    NSUInteger groupIndex = (NSUInteger)[self nearestBarsGroupIndexToPoint: point];

    NSUInteger barsIGroupCount = [self.barsContainerLayer.barsSeries numberOfBarsInGroup: groupIndex];

    for ( NSUInteger index_ = 0; index_ < barsIGroupCount; ++index_ )
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: (NSInteger)index_ inSection: (NSInteger)groupIndex];
        ILBarState  *state = [self stateForBarAtIndexPath: indexPath];
        
        CGRect barGloabalFrame = state.barRect;

        if ( state.horizontal )
        {
            barGloabalFrame.origin.y += state.groupFrame.origin.y + state.frame.origin.y;
        }
        else
        {
            barGloabalFrame.origin.x += state.groupFrame.origin.x + state.frame.origin.x;
        }

        if ( CGRectContainsPoint( barGloabalFrame, point) )
        {
            return indexPath;
        }
    }

    return nil;
}

#pragma mark- Lazy properties

- (NSMutableDictionary *)barsState
{
    if ( !self->_barsState )
    {
        self->_barsState = [NSMutableDictionary new];
    }
    return self->_barsState;
}

@end
