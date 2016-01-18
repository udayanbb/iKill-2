//
//  SKButton.m
//  UnofficialSprite
//
//  Created by Udayan Bulchandani on 26/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import "SKButton.h"
#import "Constants.h"

@implementation SKButton

-(id) initWithType: (ButtonType) buttonType {
    
    switch (buttonType) {
        case kAimSlider:
            self = [super initWithImageNamed:@"BlankThumb"];
            self.xScale = 2;
            self.yScale = 1;
            self.buttonType = kAimSlider;
            break;
        default:
            [NSException raise:@"bad button init" format:@"%d", buttonType];
    }

    self.pressed = FALSE;
    self.isActive = YES;
    self.zPosition = kUIElementsZ;
    self.anchorPoint = CGPointZero;
    
    return self;
}


@end
