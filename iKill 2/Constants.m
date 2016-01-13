//
//  Constants.m
//  iKill 2
//
//  Created by Udayan Bulchandani on 27/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import "Constants.h"

//zPositions for rendering order
const int kBackgroundZ = 0;
const int kForegroundZ = 1;
const int kShipZ = 5;
const int kPlayerZ = 10;
const int kPlayerWeaponZ = 15;
const int kBulletZ = 20;
const int kUIElementsZ = 25;
const int kCoverZ = 30;


const int kDebugZ = 100;



//Collision bitmasks
const uint32_t shipCategory         = 0x1 << 0;
const uint32_t groundCategory       = 0x1 << 1;
const uint32_t playerCategory       = 0x1 << 2;
const uint32_t playerBulletCategory = 0x1 << 3;
const uint32_t enemyBulletCategory  = 0x1 << 4;


inline CGPoint pointAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

inline CGPoint pointSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

inline CGPoint pointMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

inline float pointLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}