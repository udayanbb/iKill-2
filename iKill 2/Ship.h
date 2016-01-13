//
//  Ship.h
//  iKill 2
//
//  Created by Udayan Bulchandani on 28/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameScene;

@interface Ship : SKSpriteNode

-(id) initWithScene: (GameScene*) scene type: (int) typeCode;

@property (weak, nonatomic) GameScene *parentScene;

@property NSMutableArray *glowFrames;
@property NSMutableArray *blowFrames;

@property int code;

@property int AIState;
@property NSTimeInterval timeOfLastShot;
@property NSTimeInterval timeUntilNextShot;


@property SKShapeNode *healthSlider;
@property float healthSliderMaxWidth;
@property NSDate *timeOfLastTrigger;

@property bool noTarget;

@property float health;
@property float maxHealth;

@property BOOL shouldDelete;

-(void) updateAIWithTime: (NSTimeInterval) currentTime WorldPosition: (CGPoint) worldPosition PlayerPosition: (CGPoint) playerPosition;

-(void) takeDamage: (float) damage;

@end
