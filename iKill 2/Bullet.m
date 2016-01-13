//
//  Bullet.m
//  iKill 2
//
//  Created by Udayan Bulchandani on 28/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import "Bullet.h"
#import "Constants.h"




@implementation Bullet

-(id) initWithEnemyType: (int) type {
    

    NSString *bulletImageString = [NSString stringWithFormat:@"EnemyBullet%d.png", type];
    
    self = [super initWithTexture:[SKTexture textureWithImageNamed:bulletImageString]];

    self.blowFrames = [NSMutableArray arrayWithCapacity:3];
    
    
    bulletImageString = [NSString stringWithFormat:@"EnemyBullet%dExplosion%d.png", type, 1];
    [self.blowFrames addObject:[SKTexture textureWithImageNamed:bulletImageString]];
    bulletImageString = [NSString stringWithFormat:@"EnemyBullet%dExplosion%d.png", type, 2];
    [self.blowFrames addObject:[SKTexture textureWithImageNamed:bulletImageString]];
    bulletImageString = [NSString stringWithFormat:@"EnemyBullet%dExplosion%d.png", type, 3];
    [self.blowFrames addObject:[SKTexture textureWithImageNamed:bulletImageString]];

    
    self.zPosition = kPlayerWeaponZ;
    
    //Configure bullet physics
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width/2];
    self.physicsBody.restitution = 0;
    self.physicsBody.categoryBitMask = enemyBulletCategory;
    self.physicsBody.collisionBitMask = groundCategory;
    self.physicsBody.contactTestBitMask = playerCategory | groundCategory;
    

    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.friction = 0.0;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = YES;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    //self.physicsBody.velocity = CGVectorMake(2000, 0);
    self.physicsBody.mass = 0.001;
    
    self.damage = 1;
    
    return self;
    
}


-(id) initWithType: (int) type {
    
    
    int rand = (arc4random() % 12) + 1;
    
    NSString *bulletImageString = [NSString stringWithFormat:@"Bullet%d.png", rand];
    
    self = [super initWithTexture:[SKTexture textureWithImageNamed:bulletImageString]];
    
    
    self.blowFrames = [NSMutableArray arrayWithCapacity:5];
    
    SKTextureAtlas *bulletBlowAtlas = [SKTextureAtlas atlasNamed:@"manBullet"];
    [self.blowFrames addObject:[bulletBlowAtlas textureNamed:@"Explosion1"]];
    [self.blowFrames addObject:[bulletBlowAtlas textureNamed:@"Explosion2"]];
    [self.blowFrames addObject:[bulletBlowAtlas textureNamed:@"Explosion3"]];
    [self.blowFrames addObject:[bulletBlowAtlas textureNamed:@"Explosion4"]];
    
    
    self.zPosition = kPlayerWeaponZ + 1;
    
    //Configure bullet physics
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width/2];
    self.physicsBody.restitution = 0;
    self.physicsBody.categoryBitMask = playerBulletCategory;
    self.physicsBody.collisionBitMask = groundCategory;
    self.physicsBody.contactTestBitMask = shipCategory | groundCategory;
    
    
    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.friction = 0.0;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = YES;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    self.physicsBody.mass = 0.001;
    
    self.damage = 20;
    
    return self;
    
}


- (void) explodeAndRemove {
    self.physicsBody.collisionBitMask = 0x0;
    SKAction *animation = [SKAction animateWithTextures:self.blowFrames timePerFrame:0.05f resize:YES restore:YES];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[animation, removeNode]];
    [self runAction:sequence];
}


@end
