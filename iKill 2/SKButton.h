//
//  SKButton.h
//  UnofficialSprite
//
//  Created by Udayan Bulchandani on 26/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {kLeftButton, kRightButton, kUpButton, kPauseButton, kAimSlider, kChangeWeaponButton} ButtonType;

@interface SKButton : SKSpriteNode

-(id) initWithType: (ButtonType) buttonType;

@property BOOL pressed;
@property BOOL isActive;
@property ButtonType buttonType;

@end
