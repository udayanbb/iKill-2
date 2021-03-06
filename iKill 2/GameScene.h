//
//  GameScene.h
//  iKill 2
//

//  Copyright (c) 2015 Udayan Bulchandani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>



@class Player;
@class Ship;
@class Bullet;
@class Weapon;
@class SKButton;

@interface GameScene : SKScene <SKPhysicsContactDelegate>


@property (nonatomic) NSDate *timeAimNubTouchBegan;

@property (nonatomic) SKSpriteNode *worldNode;

@property (nonatomic) SKShapeNode *pauseCover;

@property (nonatomic) SKSpriteNode *aimNub;

@property (nonatomic) Player *player;
@property (nonatomic) Ship *ship;
@property (nonatomic) Weapon *weapon;

@property (nonatomic) SKLabelNode *debugLabel;
@property (nonatomic) SKLabelNode *ammoLabel;

@property (nonatomic) float defaultNubX;

@property  NSMutableArray *controlSurfaces;
@property  NSMutableArray *weapons;

@property (nonatomic) SKButton *changeWeaponButton;

-(void) playerDead;

@end
