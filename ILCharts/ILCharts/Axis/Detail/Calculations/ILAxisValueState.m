#import "ILAxisValueState.h"

@implementation ILAxisValueState

-(CGSize)textSize
{
    if ( CGSizeEqualToSize( self->_textSize, CGSizeZero ) && self->_text && self.font )
    {
        self->_textSize = [ self.text sizeWithFont: self.font ];
    }
    return self->_textSize;
}

@end
