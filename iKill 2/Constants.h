//
//  Constants.h
//  iKill 2
//
//  Created by Udayan Bulchandani on 27/12/2015.
//  Copyright © 2015 Udayan Bulchandani. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;


//zPositions for rendering order
extern const int kBackgroundZ;
extern const int kForegroundZ;
extern const int kShipZ;
extern const int kPlayerZ;
extern const int kPlayerWeaponZ;
extern const int kBulletz;
extern const int kUIElementsZ;
extern const int kCoverZ;
extern const int kDebugZ;


//Collision bitmasks
extern const uint32_t shipCategory;
extern const uint32_t groundCategory;
extern const uint32_t playerBulletCategory;
extern const uint32_t enemyBulletCategory;
extern const uint32_t playerCategory;



inline extern CGPoint pointAdd(CGPoint a, CGPoint b);

inline extern CGPoint pointSub(CGPoint a, CGPoint b);

inline extern CGPoint pointMult(CGPoint a, float b);

inline extern float pointLength(CGPoint a);