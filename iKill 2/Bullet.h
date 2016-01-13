//
//  Bullet.h
//  iKill 2
//
//  Created by Udayan Bulchandani on 28/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bullet : SKSpriteNode

@property NSMutableArray *blowFrames;

@property float damage;

- (void) explodeAndRemove;

-(id) initWithEnemyType: (int) type;
-(id) initWithType: (int) type;

@end
