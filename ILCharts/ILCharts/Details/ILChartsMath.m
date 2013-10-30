#import "ILChartsMath.h"

@implementation ILChartsMath

+(CGFloat)distanceFromPoint:( CGPoint )pointA_
                    toPoint:( CGPoint )pointB_
{
    return sqrtf( powf( ( pointA_.x - pointB_.x ), 2.f ) + powf( ( pointA_.y - pointB_.y ), 2.f ) );
}

+(CGFloat)angleBetweenPoint:( CGPoint )pointA_
                   andPoint:( CGPoint )pointB_
{
    CGFloat angle_ = atan2f( pointA_.y - pointB_.y, pointA_.x - pointB_.x );

    if ( angle_ < 0.f )
    {
        angle_ = (float)DOUBLE_M_PI + angle_;
    }

    return angle_;
}

@end
