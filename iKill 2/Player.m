//
//  Player.m
//  iKill 2
//
//  Created by Udayan Bulchandani on 27/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import "Player.h"
#import "Constants.h"
#import "GameScene.h"
#import "Weapon.h"

@implementation Player

-(id) initWithScene: (GameScene*) scene {
    
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"Standing-left"]];
    
    self.parentScene = scene;
    self.isLeft = YES;
    self.isDead = NO;
    self.isWalking = NO;
    
    //self.xScale = 2;
    //self.yScale = 2;
    //commit test
    
    //Load man textures
    SKTextureAtlas *walkAtlas =[SKTextureAtlas atlasNamed:@"manFrames"];
    self.walkTextures = [NSMutableArray arrayWithCapacity:9];
    [self.walkTextures addObject:[walkAtlas textureNamed:@"Walk1-left"]];
    [self.walkTextures addObject:[walkAtlas textureNamed:@"Walk2-left"]];
    [self.walkTextures addObject:[walkAtlas textureNamed:@"Walk3-left"]];
    [self.walkTextures addObject:[walkAtlas textureNamed:@"Walk4-left"]];
    [self.walkTextures addObject:[walkAtlas textureNamed:@"Walk5-left"]];
    [self.walkTextures addObject:[walkAtlas textureNamed:@"Walk6-left"]];
    [self.walkTextures addObject:[walkAtlas textureNamed:@"Walk7-left"]];
    [self.walkTextures addObject:[walkAtlas textureNamed:@"Standing-left"]];
    
    SKTextureAtlas *dieAtlas =[SKTextureAtlas atlasNamed:@"manDie"];
    self.dieTextures = [NSMutableArray arrayWithCapacity:3];
    [self.dieTextures addObject:[dieAtlas textureNamed:@"ManDie1"]];
    [self.dieTextures addObject:[dieAtlas textureNamed:@"ManDie2"]];
    [self.dieTextures addObject:[dieAtlas textureNamed:@"ManDie3"]];

    self.standTexture = [walkAtlas textureNamed:@"Standing-left"];
    
    //Configure man SpriteNode
    self.zPosition = kPlayerZ;
    
    //Configure man physics
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width-10, self.frame.size.height - 6)];
    self.physicsBody.restitution = 0.1;
    self.physicsBody.categoryBitMask = playerCategory;
    self.physicsBody.collisionBitMask = groundCategory;
    self.physicsBody.contactTestBitMask = enemyBulletCategory;
    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.angularDamping = 0.0;
    self.physicsBody.friction = 0.0;
    
    self.physicsBody.mass = 100;
    
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.dynamic = YES;
    
    self.health = 100;
    
    return self;

}


-(void) setLeft: (BOOL) left {
    if(left == NO) {
        self.isLeft = NO;
        self.xScale = -1;
    }
    else {
        self.isLeft = YES;
        self.xScale = 1;
    }
}

//Trigger walk animation
-(void) walk {
    if(!self.isDead && !self.isWalking) {
        self.isWalking = YES;
        SKAction *animation = [SKAction animateWithTextures:self.walkTextures timePerFrame:0.05f resize:YES restore:NO];
        SKAction *infinteLoop = [SKAction repeatActionForever:animation];
        [self runAction:infinteLoop withKey:@"walkAction"];
    }
}


-(void) die {
    self.alpha = 0.8;
    self.isDead = YES;
    [self removeAllActions];
    self.physicsBody.categoryBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    self.physicsBody.dynamic = NO;
    [self.weapon removeFromParent];
    SKAction *animateDeath = [SKAction animateWithTextures: self.dieTextures timePerFrame:0.06f resize:YES restore:NO];
    SKAction *setTransparent = [SKAction fadeAlphaTo:0 duration:0];
    //SKAction *callSetDelete = [SKAction runBlock:^{self.shouldDelete = YES;}];
    //SKAction *wait = [SKAction waitForDuration:1];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *dieSequence = [SKAction sequence:@[animateDeath, setTransparent, remove]];
    [self runAction: dieSequence];
    [self.parentScene playerDead];
    return;
    
}


//Trigger stationary texture
-(void) stop {
    if(!self.isDead && self.isWalking) {
        [self removeActionForKey:@"walkAction"];
        self.texture = self.standTexture;
        self.isWalking = NO;
    }
}


-(void) takeDamage: (float) damage {
    self.health -= damage;
    if (self.health <= 0) {
        self.health = 0;
        [self die];
    }
}



@end
