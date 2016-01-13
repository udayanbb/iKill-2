//
//  Ship.m
//  iKill 2
//
//  Created by Udayan Bulchandani on 28/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import "Ship.h"
#import "Constants.h"
#import "GameScene.h"
#import "Bullet.h"

@implementation Ship

-(id) initWithScene: (GameScene*) scene type: (int) typeCode {
    
    typeCode = (arc4random() % 4) + 1;
    
    self.code = typeCode;
    
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"Ship1Glow1"]];
    
    self.timeOfLastTrigger = 0;
    
    self.shouldDelete = NO;
    
    self.parentScene = scene;
    
    self.health = 100;
    self.maxHealth = 100;
    
    self.noTarget = NO;
    self.timeOfLastShot = 0;
    self.timeUntilNextShot = 0;
    self.AIState = 0;
    
    
    
    //Load textures
    self.glowFrames = [NSMutableArray arrayWithCapacity:3];
    
    
    
    
    NSString *atlasString = [NSString stringWithFormat:@"ship%d", self.code];
    NSLog(atlasString);
    SKTextureAtlas *shipAtlas = [SKTextureAtlas atlasNamed:atlasString];
    NSString *textureName = [NSString stringWithFormat:@"Ship%dGlow%d.png", self.code, 1];
    NSLog(textureName);
    
    self = [super initWithTexture:[shipAtlas textureNamed:textureName]];
    
    textureName = [NSString stringWithFormat:@"Ship%dGlow%d.png", self.code, 1];
    [self.glowFrames addObject:[shipAtlas textureNamed:textureName]];
    [self.glowFrames addObject:[shipAtlas textureNamed:textureName]];
    
    textureName = [NSString stringWithFormat:@"Ship%dGlow%d.png", self.code, 2];
    [self.glowFrames addObject:[shipAtlas textureNamed:textureName]];
    

    self.blowFrames = [NSMutableArray arrayWithCapacity:4];
    textureName = [NSString stringWithFormat:@"Ship%dBlow%d.png", self.code, 1];
    [self.blowFrames addObject:[shipAtlas textureNamed:textureName]];
    textureName = [NSString stringWithFormat:@"Ship%dBlow%d.png", self.code, 2];
    [self.blowFrames addObject:[shipAtlas textureNamed:textureName]];
    textureName = [NSString stringWithFormat:@"Ship%dBlow%d.png", self.code, 3];
    [self.blowFrames addObject:[shipAtlas textureNamed:textureName]];
    textureName = [NSString stringWithFormat:@"Ship%dBlow%d.png", self.code, 4];
    [self.blowFrames addObject:[shipAtlas textureNamed:textureName]];
 
    [self glow];
    
    self.zPosition = kShipZ;
    
    //Configure man physics
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width-85, self.frame.size.height - 60)];
    self.physicsBody.restitution = 0;
    self.physicsBody.categoryBitMask = shipCategory;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = playerBulletCategory;
    self.physicsBody.usesPreciseCollisionDetection = TRUE;
    
    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.friction = 0.0;
    
    self.physicsBody.mass = 10000;
    
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    
    self.healthSliderMaxWidth = self.frame.size.width - 50;
    
    self.healthSlider = [SKShapeNode shapeNodeWithRect:CGRectMake(-self.healthSliderMaxWidth/2, -self.frame.size.height/2 + 15, self.healthSliderMaxWidth, 3) cornerRadius:1];
    self.healthSlider.alpha = 0;
    self.healthSlider.fillColor = [SKColor redColor];
    self.healthSlider.zPosition = 1;
    
    [self addChild: self.healthSlider];
    
    return self;
    
}

-(void) glow {
    SKAction *animation = [SKAction animateWithTextures:self.glowFrames timePerFrame:0.1f resize:YES restore:NO];
    SKAction *infinteLoop = [SKAction repeatActionForever:animation];
    [self runAction:infinteLoop withKey:@"glow"];
    
}


-(void) updateAIWithTime: (NSTimeInterval) currentTime WorldPosition: (CGPoint) worldPosition PlayerPosition: (CGPoint) playerPosition {
    //NSTimeInterval delta =  currentTime - self.previousTime;
    //self.previousTime = currentTime;
    
    int speed = 300;
    
    switch (self.AIState) {
        case 0:                         //Initial state
            self.timeUntilNextShot = 1;
            if (self.position.x > playerPosition.x) {           //Trigger Left run
                self.xScale = -1;
                self.AIState = 1;
                self.physicsBody.velocity = CGVectorMake(-speed, self.physicsBody.velocity.dy);
            }
            else {
                self.xScale = 1;
                self.AIState = 2;
                self.physicsBody.velocity = CGVectorMake(speed, self.physicsBody.velocity.dy);
            }
            break;
        case 1:                                                     //Left Run
            if (self.position.x < (-worldPosition.x) - 100) {
                self.AIState = 2;
                self.physicsBody.velocity = CGVectorMake(speed, self.physicsBody.velocity.dy);
                self.xScale = 1;
            }
            break;
        case 2:                                                     //Right Run
            if (self.position.x > (-worldPosition.x) + self.parentScene.frame.size.width + 100) {
                self.AIState = 1;
                self.physicsBody.velocity = CGVectorMake(-speed, self.physicsBody.velocity.dy);
                self.xScale = -1;
            }
            break;
        default:
            NSLog(@"Error");
            break;
    }
    
    
    if ((currentTime - self.timeOfLastShot) > self.timeUntilNextShot && !self.noTarget) {
        self.timeOfLastShot = currentTime;
        self.timeUntilNextShot = 0.5;
        Bullet *newBullet = [[Bullet alloc]initWithEnemyType:self.code];
        newBullet.position = self.position;
        CGPoint psuedoRelative = pointSub(self.position, playerPosition);
        psuedoRelative =  pointMult(psuedoRelative, 1/pointLength(psuedoRelative));
        CGVector vel = CGVectorMake(-psuedoRelative.x * 500, -psuedoRelative.y*500);
        newBullet.physicsBody.velocity = vel;
        [self.parentScene.worldNode addChild:newBullet];
    }
    
}

-(void) takeDamage: (float) damage {
    
    self.health -= damage;
    
    if (self.health <= 0) {
        self.physicsBody.dynamic = NO;
        self.noTarget = YES;
        self.health = 0;
        SKAction *updateHealthSlider = [SKAction scaleXTo:0 duration:0.2];
        [self.healthSlider runAction:updateHealthSlider];
        [self shipBlow];
    }
    else {
        self.healthSlider.alpha = 0.2; //UPDATE THIS WITH CONSTANT
        [self.healthSlider removeAllActions];
        
        float newScale = (self.health/self.maxHealth);
        SKAction *updateHealthSlider = [SKAction scaleXTo:newScale duration:0.2];
        [self.healthSlider runAction:updateHealthSlider];
        
        
        SKAction *waitToFadeHealthSlider = [SKAction waitForDuration:3];
        SKAction *fadeHealthSlider = [SKAction fadeAlphaTo:0 duration:1];
        SKAction *fadeSequence = [SKAction sequence:@[waitToFadeHealthSlider, fadeHealthSlider]];
        [self.healthSlider runAction:fadeSequence];
        
    }
}


-(void)shipBlow {
    self.alpha = 0.8;
    [self removeAllActions];
    self.physicsBody.contactTestBitMask = 0x0;
    self.physicsBody.categoryBitMask = 0x0;
    SKAction *animateExplosion = [SKAction animateWithTextures: self.blowFrames timePerFrame:0.08f resize:NO restore:NO];
    SKAction *setTransparent = [SKAction fadeAlphaTo:0 duration:0];
    SKAction *callSetDelete = [SKAction runBlock:^{self.shouldDelete = YES;}];
    SKAction *wait = [SKAction waitForDuration:1];
    
    SKAction *destroySequence = [SKAction sequence:@[animateExplosion, setTransparent, wait, callSetDelete]];
    [self runAction: destroySequence];
    return;
}


@end
