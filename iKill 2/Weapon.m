//
//  Weapon.m
//  iKill 2
//
//  Created by Udayan Bulchandani on 28/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import "Weapon.h"
#import "Bullet.h"
#import "Constants.h"
#import "GameScene.h"


@implementation Weapon

- (id) initWithScene: (GameScene*) scene wCode: (int) weaponCode {
    
    
    int rand = (arc4random() % 12) + 1;
    
    NSString *barrelImageString = [NSString stringWithFormat:@"Barrel%d.png", rand];
    
    self = [super initWithTexture:[SKTexture textureWithImageNamed:barrelImageString]];
    
    self.code = weaponCode;
    
    self.referencePoint = [[SKNode alloc]init];
    self.referencePoint.position = CGPointMake(0, self.frame.size.height/2);
    [self addChild: self.referencePoint];
    
    self.parentScene = scene;
    self.zPosition = 1;
    self.position = CGPointMake(0, 25);
    self.xScale = -1;
    return self;
}


/*
code = code1;
NSString *s1 = [[NSString alloc]initWithFormat:@"Weapon%d", code];
NSString *s2 = [[NSBundle mainBundle] pathForResource:s1 ofType:@"plist"];
[s1 release];
NSMutableArray *gunData = [[NSMutableArray alloc]initWithContentsOfFile:s2];
barrelView = [[UIImage imageNamed:[NSString stringWithFormat:@"Barrel%d.png", code]] retain];
HandleView = [[UIImage imageNamed:[NSString stringWithFormat:@"Back%d.png", code]] retain];
damage = [[gunData objectAtIndex:0] intValue];
reloadTime = [[gunData objectAtIndex:1] intValue];
speed = [[gunData objectAtIndex:2] intValue];
physics = [[gunData objectAtIndex:3] boolValue];
dropImage = [[UIImage imageNamed:[NSString stringWithFormat:@"Drop%d.png", code]] retain];
bullet = [[UIImage imageNamed:[NSString stringWithFormat:@"Bullet%d.png", code]] retain];
pivot = [[UIImage imageNamed:[NSString stringWithFormat:@"Pivot%d.png", code]] retain];
 */

-(Bullet*) createBulletWithPosition: (CGPoint) position withVelocity: (CGVector) velocity {
    Bullet *bullet =[[Bullet alloc]init];
    //bullet.position =  CGPointMake(position.x, position.y - 15);
    return bullet;
}

-(void) fire {
    Bullet *bullet =[[Bullet alloc]initWithType: self.code];
    bullet.position = [self convertPoint:self.referencePoint.position toNode:self.parentScene.worldNode];
    
    CGPoint psuedoRelative = pointSub([self convertPoint:self.position toNode:self.parentScene.worldNode], [self convertPoint:self.referencePoint.position toNode:self.parentScene.worldNode]);
    psuedoRelative =  pointMult(psuedoRelative, 1/pointLength(psuedoRelative));
    CGVector vel = CGVectorMake(-psuedoRelative.x * 500, -psuedoRelative.y*500);
    bullet.physicsBody.velocity = vel;
    [self.parentScene.worldNode addChild:bullet];
}



@end


