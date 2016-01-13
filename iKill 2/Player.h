//
//  Player.h
//  iKill 2
//
//  Created by Udayan Bulchandani on 27/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameScene;
@class Weapon;

@interface Player : SKSpriteNode

@property NSMutableArray *walkTextures;
@property NSMutableArray *dieTextures;

@property SKTexture *standTexture;
@property SKTexture *crouchTexture;

@property BOOL isDead;
@property BOOL isCrouching;

@property BOOL isLeft;
@property BOOL isWalking;

@property float health;

@property (weak, nonatomic) GameScene *parentScene;

@property (weak,nonatomic) Weapon *weapon;

-(id) initWithScene: (GameScene*) scene;

-(void) walk;
-(void) stop;
-(void) setLeft: (BOOL) left;

-(void) takeDamage: (float) damage;

@end
