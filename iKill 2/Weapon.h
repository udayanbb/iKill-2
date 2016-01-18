//
//  Weapon.h
//  iKill 2
//
//  Created by Udayan Bulchandani on 28/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameScene;

@class Bullet;

@interface Weapon : SKNode

-(id) initWithScene: (GameScene*) scene wCode: (int) weaponCode;


@property (weak, nonatomic) GameScene *parentScene;

@property SKNode *referencePoint;
@property SKSpriteNode *barrel;
@property SKTexture *buttonTexture;

@property int code;
@property int ammo;

-(Bullet*) createBulletWithPosition: (CGPoint) position withVelocity: (CGVector) velocity;

-(void) fire;

@end
