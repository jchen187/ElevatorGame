//
//  Character.h
//  johnnychen
//
//  Created by Johnny Chen on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#define CP_ALLOW_PRIVATE_ACCESS 1
//you need to do this if you want to do the physicbody.body.body

#import "CCNode.h"
#import "CCPhysics+ObjectiveChipmunk.h"
//@class MainScene;


@interface Character : CCNode

@property (nonatomic, assign) NSInteger distanceTraveled;

//need to do this becuase of some linking issue
- (void)setSpeed: (float)s;
- (void)setDesiredX: (int)x;
- (void)setAcceleration: (int)a;
- (void)setSpeedMultiplier: (float)s;
- (void)setSlowDown: (BOOL)b;
- (BOOL)getSlowDown;

- (instancetype)initCharacter;

static void playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt);

- (void) restartDistance;
@end

