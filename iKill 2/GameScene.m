//
//  GameScene.m
//  iKill 2
//
//  Created by Udayan Bulchandani on 26/12/2015.
//  Copyright (c) 2015 Udayan Bulchandani. All rights reserved.
//

#import "GameScene.h"
#import "SKButton.h"
#import "Player.h"
#import "Ship.h"
#import "Bullet.h"
#import "Weapon.h"
#import "Constants.h"






@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.size = view.frame.size;                                    //Set SKView to correct dimensions
    self.anchorPoint = CGPointMake(0, 0);
    
    self.physicsWorld.gravity = CGVectorMake(0,-10);                  //Intialise physics
    self.physicsWorld.contactDelegate = self;
    
    self.controlSurfaces = [NSMutableArray arrayWithCapacity:5];    //initialise control surface array
    
    //NSLog(@"View dimensions: x %f, y %f", view.frame.size.width, view.frame.size.height);
    NSLog(@"Scene dimensions: x %f, y %f", self.frame.size.width, self.frame.size.height);

    
    //Add background node with appropriate image
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"1Background"];
    float scale = view.frame.size.width/background.frame.size.width;
    background.anchorPoint = CGPointZero;
    background.xScale = scale;
    background.yScale = scale;
    background.position =  CGPointMake(0, -100);
    background.zPosition = kBackgroundZ;
    [self addChild:background];
    
    
    //Add test foreground: world node
    self.worldNode = [SKSpriteNode spriteNodeWithImageNamed:@"1Foreground1"];
    //NSLog(@"Foreground dimensions: x %f, y %f", self.worldNode.size.width, self.worldNode.size.height);
    self.worldNode.anchorPoint = CGPointZero;
    self.worldNode.position = CGPointZero;
    self.worldNode.zPosition = kForegroundZ;
    
    CGRect worldBoundRect = CGRectMake(self.worldNode.frame.origin.x, self.worldNode.frame.origin.x, self.worldNode.frame.size.width, self.worldNode.frame.size.height + 1000);
    
    self.worldNode.physicsBody = [SKPhysicsBody  bodyWithEdgeLoopFromRect: worldBoundRect];
    self.worldNode.physicsBody.categoryBitMask = groundCategory;
    self.worldNode.physicsBody.collisionBitMask = playerCategory;
    self.worldNode.physicsBody.restitution = 0;
    self.worldNode.physicsBody.dynamic = NO;
    
    //self.worldNode.xScale = 1.3;
    //self.worldNode.yScale = 1.3;
    
    [self addChild:self.worldNode];
    
    self.debugLabel = [SKLabelNode labelNodeWithText:@"nope"];
    self.debugLabel.fontColor = [SKColor darkGrayColor];
    self.debugLabel.zPosition = kDebugZ;
    self.debugLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 150);
    [self addChild:self.debugLabel];
    
    self.ammoLabel = [SKLabelNode labelNodeWithText:@"100"];
    self.ammoLabel.fontColor = [SKColor darkGrayColor];
    self.ammoLabel.zPosition = kUIElementsZ;
    self.ammoLabel.position = CGPointMake(CGRectGetMidX(self.frame)+180, CGRectGetMidY(self.frame) + 150);
    [self addChild:self.ammoLabel];
    
    
    //Ground collision masks
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1Rectangles1" ofType:@"plist"];
    NSMutableArray *groundRectangles = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
    for(int i = 0; i < [groundRectangles count]; i = i + 4) {
        CGRect rectangle = CGRectMake([[groundRectangles objectAtIndex:i] intValue], 320-[[groundRectangles objectAtIndex:i+1] intValue] -[[groundRectangles objectAtIndex:i+3] intValue], [[groundRectangles objectAtIndex:i+2] intValue], [[groundRectangles objectAtIndex:i+3] intValue]);
        SKNode *collisionMask = [[SKNode alloc] init];
        collisionMask.position = CGPointMake(CGRectGetMidX(rectangle), CGRectGetMidY(rectangle));
        collisionMask.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rectangle.size];
        collisionMask.physicsBody.dynamic = NO;
        collisionMask.physicsBody.categoryBitMask = groundCategory;
        collisionMask.physicsBody.collisionBitMask =  playerCategory | enemyBulletCategory;
        collisionMask.physicsBody.contactTestBitMask = playerBulletCategory | enemyBulletCategory;
        collisionMask.physicsBody.restitution = 0;
        //collisionMask.physicsBody.usesPreciseCollisionDetection = YES;
        [self.worldNode addChild:collisionMask];
    }
    
    self.pauseCover = [SKShapeNode shapeNodeWithRect:self.frame];
    self.pauseCover.fillColor = [SKColor whiteColor];
    self.pauseCover.alpha = 0;
    self.pauseCover.zPosition = kCoverZ + 1;
    [self addChild:self.pauseCover];
    
    //Man Tests
    self.player =  [[Player alloc] initWithScene:self];
    self.player.position = CGPointMake(20, CGRectGetMidY(self.frame) + 200);
    [self.worldNode addChild:self.player];
    
    
    //Ship tests
    [self spawnShip];
    
    
    //Weapon Tests
    
    self.weapons = [NSMutableArray arrayWithCapacity:12];
    for (int i = 1; i <= 12; i++) {
        [self.weapons addObject:[[Weapon alloc]initWithScene:self wCode:i]];
    }
    
    self.weapon = [self.weapons objectAtIndex:0];
    [self.player addChild:self.weapon];
    self.player.weapon = self.weapon;

    
    //Prototype navigation buttons
    //Left button
    SKButton *leftButton = [SKButton spriteNodeWithImageNamed:@"LeftArrow"];
    leftButton.xScale = 1.5;
    leftButton.yScale = 1.5;
    leftButton.anchorPoint = CGPointZero;
    leftButton.position = CGPointZero;
    leftButton.zPosition = kUIElementsZ;
    leftButton.pressed = FALSE;
    leftButton.buttonType = kLeftButton;
    leftButton.isActive = YES;
    [self addChild: leftButton];
    [self.controlSurfaces addObject:leftButton];
    //Right Button
    SKButton *rightButton = [SKButton spriteNodeWithImageNamed:@"RightArrow"];
    rightButton.xScale = 1.5;
    rightButton.yScale = 1.5;
    rightButton.anchorPoint = CGPointZero;
    rightButton.position = CGPointMake(leftButton.frame.size.width, 0);
    rightButton.zPosition = kUIElementsZ;
    rightButton.pressed = FALSE;
    rightButton.buttonType = kRightButton;
    rightButton.isActive = YES;
    [self addChild:rightButton];
    [self.controlSurfaces addObject:rightButton];
    //Up Button
    SKButton *upButton = [SKButton spriteNodeWithImageNamed:@"UpArrow"];
    upButton.xScale = 1.5;
    upButton.yScale = 1.5;
    upButton.anchorPoint = CGPointZero;
    upButton.position = CGPointMake(leftButton.frame.size.width/2, rightButton.frame.size.height);
    upButton.zPosition = kUIElementsZ;
    upButton.pressed = FALSE;
    upButton.isActive = YES;
    upButton.buttonType = kUpButton;
    [self addChild:upButton];
    [self.controlSurfaces addObject:upButton];
    SKButton *pauseButton = [SKButton spriteNodeWithImageNamed:@"pause"];
    pauseButton.anchorPoint = CGPointZero;
    pauseButton.position = CGPointMake(0, self.frame.size.height - pauseButton.frame.size.height);
    pauseButton.zPosition = kCoverZ + 1;
    pauseButton.pressed = FALSE;
    pauseButton.buttonType = kPauseButton;
    pauseButton.isActive = NO;
    [self addChild:pauseButton];
    [self.controlSurfaces addObject:pauseButton];
    
    
    //Change weapon button
    self.changeWeaponButton = [SKButton spriteNodeWithImageNamed:@"Drop1.png"];
    self.changeWeaponButton.zPosition = kUIElementsZ;
    self.changeWeaponButton.anchorPoint = CGPointZero;
    self.changeWeaponButton.position = CGPointMake(self.frame.size.width - self.changeWeaponButton.frame.size.width, self.frame.size.height - self.changeWeaponButton.frame.size.height);
    
    self.changeWeaponButton.pressed = FALSE;
    self.changeWeaponButton.buttonType = kChangeWeaponButton;
    self.changeWeaponButton.isActive = NO;
    [self addChild:self.changeWeaponButton];
    [self.controlSurfaces addObject:self.changeWeaponButton];
    
    //Shoot control prototype

    
    SKButton *aimSlider = [[SKButton alloc]initWithType:kAimSlider];
    aimSlider.xScale = 2.4;
    aimSlider.yScale = 2;
    aimSlider.position = CGPointMake(self.frame.size.width - aimSlider.frame.size.width, 5);
    [self addChild: aimSlider];
    [self.controlSurfaces addObject:aimSlider];
    self.defaultNubX = aimSlider.frame.origin.x + aimSlider.frame.size.width/2;
    
    
    self.aimNub = [SKSpriteNode spriteNodeWithImageNamed:@"aimNub"];
    self.aimNub.xScale = 1.5;
    self.aimNub.yScale = 1.5;
    
    self.aimNub.position = CGPointMake(self.defaultNubX, 10 + aimSlider.frame.size.height/2);
    self.aimNub.zPosition = kUIElementsZ + 1;
    [self addChild:self.aimNub];
    
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self.worldNode addChild:[self.weapon createBulletWithPosition:self.player.position withVelocity:self.player.physicsBody.velocity]];
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    for (SKButton *surface in self.controlSurfaces) {
        if ([surface containsPoint:location]) {
            surface.pressed = TRUE;
            switch (surface.buttonType) {
                case kLeftButton:
                    [self.player walk];
                    self.player.physicsBody.velocity = CGVectorMake(-300, self.player.physicsBody.velocity.dy);
                    //[self.player setLeft:YES ];
                    break;
                case kRightButton:
                    [self.player walk];
                    self.player.physicsBody.velocity = CGVectorMake(300, self.player.physicsBody.velocity.dy);
                    //[self.player setLeft:NO ];
                    break;
                case kUpButton:
                    [self.player.physicsBody applyImpulse:CGVectorMake(0, 70000)];
                    break;
                case kPauseButton:
                    break;
                case kAimSlider:
                    self.timeAimNubTouchBegan = [NSDate date];
                                    
                    self.aimNub.position = CGPointMake(location.x, self.aimNub.position.y);
                    if (location.x - self.defaultNubX > 0) {
                        self.weapon.barrel.zRotation = (location.x - self.defaultNubX) / 60;
                        [self.player setLeft:NO];
                    }
                    else {
                        self.weapon.barrel.zRotation = (-location.x + self.defaultNubX) / 60;
                        [self.player setLeft:YES];
                    }
                    
                    break;
                case kChangeWeaponButton:
                    [self changeWeapon];
                    break;
                default:
                    [NSException raise:@"Whuut" format:@"%d", surface.buttonType];
            }
            
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    for (SKButton *surface in self.controlSurfaces) {
        if ([surface containsPoint:location]) {
            surface.pressed = TRUE;
            switch (surface.buttonType) {
                case kLeftButton:
                    break;
                case kRightButton:
                    break;
                case kUpButton:
                    break;
                case kPauseButton:
                    break;
                case kAimSlider:
                    self.aimNub.position = CGPointMake(location.x, self.aimNub.position.y);
                    if (location.x - self.defaultNubX > 0) {
                        self.weapon.barrel.zRotation = (location.x - self.defaultNubX) / 60;
                        [self.player setLeft:NO];
                    }
                    else {
                        self.weapon.barrel.zRotation = (-location.x + self.defaultNubX) / 60;
                        [self.player setLeft:YES];
                    }
                    break;
                case kChangeWeaponButton:
                    break;
                default:
                    [NSException raise:@"Whuut" format:@"%d", surface.buttonType];
            }

        }
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    for (SKButton *surface in self.controlSurfaces) {
        self.player.physicsBody.velocity = CGVectorMake(0, self.player.physicsBody.velocity.dy);
        [self.player stop];
        if ([surface containsPoint:location]) {
            surface.pressed = false;
            NSDate *currentTime = [NSDate date];
            NSTimeInterval elapsed;
            switch (surface.buttonType) {
                case kLeftButton:
                    self.player.physicsBody.velocity = CGVectorMake(0, self.player.physicsBody.velocity.dy);
                    break;
                case kRightButton:
                    self.player.physicsBody.velocity = CGVectorMake(0, self.player.physicsBody.velocity.dy);
                    break;
                case kUpButton:
                    break;
                case kPauseButton:
                    break;
                case kAimSlider:
                    //self.aimNub.position = CGPointMake(self.defaultNubX, self.aimNub.position.y);
                    elapsed = [currentTime timeIntervalSinceDate:self.timeAimNubTouchBegan];
                    if (elapsed < 0.3) [self.weapon fire];
                    break;
                case kChangeWeaponButton:
                    break;
                default:
                    [NSException raise:@"Whuut" format:@"%d", surface.buttonType];
            }
        }
        if([surface containsPoint:location] && surface.buttonType == kPauseButton){
            [self pause];
        }
    }
}



-(void)update:(NSTimeInterval)currentTime {
    
    //Called with every frame
    
    //Update debug label
    CGPoint positionInScreen = [self convertPoint:self.player.position fromNode:self.worldNode];
    //self.debugLabel.text = [NSString stringWithFormat: @"x:%f and y:%f", self.worldNode.position.x, self.worldNode.position.y];
    self.debugLabel.text = [NSString stringWithFormat: @"Health: %f", self.player.health];

    self.ammoLabel.text = [NSString stringWithFormat: @"%d", self.weapon.ammo];
    
    //update worldNode position so view is centered on player
    if (positionInScreen.x > 600) {
        self.worldNode.position = CGPointMake( self.worldNode.position.x - (positionInScreen.x - 600) - 1, self.worldNode.position.y);
        if (self.worldNode.position.x < -1440 + self.frame.size.width) self.worldNode.position =CGPointMake(-1440 + self.frame.size.width, self.worldNode.position.y);
    }
    else if (positionInScreen.x < 100) {
        self.worldNode.position = CGPointMake( self.worldNode.position.x + (100-positionInScreen.x) + 1, self.worldNode.position.y);
        if(self.worldNode.position.x > 0) self.worldNode.position =CGPointMake(0, self.worldNode.position.y);

    }
    if (positionInScreen.y > 250) {
        self.worldNode.position = CGPointMake(self.worldNode.position.x, self.worldNode.position.y  -(positionInScreen.y -250) - 1);
        //if(self.worldNode.position.x > 0) self.worldNode.position =CGPointMake(0, self.worldNode.position.y);
    }
    else if (positionInScreen.y < 200) {
        if(self.worldNode.position.y != 0) self.worldNode.position = CGPointMake(self.worldNode.position.x, self.worldNode.position.y +  (200 - positionInScreen.y) + 1);
        if(self.worldNode.position.y > 0) self.worldNode.position =CGPointMake(self.worldNode.position.x, 0);
    }
    
    
    
    [self.ship updateAIWithTime:currentTime WorldPosition:self.worldNode.position PlayerPosition:self.player.position];
    
    //very crude stopping mech:
    int stopCount = 2;
    
    for (SKButton *surface in self.controlSurfaces) {
        if (surface.pressed) {
            switch (surface.buttonType) {
                case kLeftButton:
                    stopCount -= 1;
                    [self.player walk];
                    self.player.physicsBody.velocity = CGVectorMake(-300, self.player.physicsBody.velocity.dy);
                    //[self.player setLeft:YES ];
                    break;
                case kRightButton:
                    stopCount -= 1;
                    [self.player walk];
                    self.player.physicsBody.velocity = CGVectorMake(300, self.player.physicsBody.velocity.dy);
                    //[self.player setLeft:NO ];
                    break;

                case kUpButton:
                    break;
                case kPauseButton:
                    break;
                case kAimSlider:
                    break;
                case kChangeWeaponButton:
                    break;
                default:
                    [NSException raise:@"Unrecog button in update()" format:@"%d", surface.buttonType];
            }
        }
    }
    
    if (stopCount == 2) self.player.physicsBody.velocity = CGVectorMake(0, self.player.physicsBody.velocity.dy);
    
    if(self.ship.shouldDelete) {
        [self.ship removeFromParent];
        [self spawnShip];
    }

}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
  
    if (secondBody.categoryBitMask == playerBulletCategory)
    {
        Bullet *tempBullet = (Bullet*) secondBody.node;
        tempBullet.physicsBody.dynamic = NO;
        if(firstBody.categoryBitMask == groundCategory) [tempBullet explodeAndRemove];
        else if (firstBody.categoryBitMask == shipCategory) {
            [self.ship takeDamage:tempBullet.damage];
            [tempBullet explodeAndRemove];
        }
        tempBullet.physicsBody.categoryBitMask = 0x0;
    }
    if (secondBody.categoryBitMask == enemyBulletCategory)
    {
        Bullet *tempBullet = (Bullet*) secondBody.node;
        tempBullet.physicsBody.dynamic = NO;
        if(firstBody.categoryBitMask == groundCategory) [tempBullet explodeAndRemove];
        else if (firstBody.categoryBitMask == playerCategory) {
            [self.player takeDamage:tempBullet.damage];
            [tempBullet explodeAndRemove];
        }
        tempBullet.physicsBody.categoryBitMask = 0x0;
    }
    
}

-(void) playerDead {
    self.ship.noTarget = YES;
    self.debugLabel.fontColor = [SKColor redColor];
    //[self pause];
    //self.debugLabel.text = [NSString stringWithFormat: @"you appear to be dead"];

}

-(void) pause {
    SKAction *fade;
    if(self.worldNode.paused) {
         fade = [SKAction fadeAlphaTo:0 duration:0.1];
        self.physicsWorld.speed = 1;
    }
    else {
        fade = [SKAction fadeAlphaTo:0.3 duration:0.1];
        self.physicsWorld.speed = 0;
    }
    self.worldNode.paused = !self.worldNode.paused;
    [self.pauseCover runAction:fade];
}

-(void) spawnShip {
    self.ship = [[Ship alloc] initWithScene:self type:1];
    self.ship.position = CGPointMake(self.frame.origin.x-100 , CGRectGetMidY(self.frame) +90);
    [self.worldNode addChild:self.ship];
}

-(void) changeWeapon {
    int index = self.weapon.code % 12;
    Weapon *temp = [self.weapons objectAtIndex:index];
    int ammo = temp.ammo;
    while(ammo == 0) {
        index = (index + 1) %12;
        temp = [self.weapons objectAtIndex:index];
        ammo = temp.ammo;
    }
    temp.barrel.zRotation = self.weapon.barrel.zRotation;
    
    [self.weapon removeFromParent];
    [self.player addChild:temp];
    self.weapon = temp;
    self.changeWeaponButton.texture = self.weapon.buttonTexture;
}

@end
