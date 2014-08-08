//
//  Character.m
//  johnnychen
//
//  Created by Johnny Chen on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Character.h"
#define SW ([[CCDirector sharedDirector] viewSize].width)
#define SH ([[CCDirector sharedDirector] viewSize].height)
//#import "MainScene.h"

@implementation Character

float speed;
int desiredX;
int acceleration;
float speedMultiplier;
BOOL slowDown; //slow down before popup


- (void)setSpeed: (float)s{
    speed = s;
}

- (void)setDesiredX: (int)x{
    desiredX = x;
}

- (void)setAcceleration: (int)a{
    acceleration = a;
}

- (void)setSpeedMultiplier: (float)s{
    speedMultiplier = s;
}

- (void)setSlowDown: (BOOL)b{
    slowDown = b;
}

- (BOOL)getSlowDown{
    return slowDown;
}

- (instancetype)initCharacter{
    if (self){
        self = (Character*)[CCBReader load:@"Character"];
    }
    return self;
}

- (void)didLoadFromCCB{
    self.positionInPoints = ccp(SW/2,SH/2 - 200);
    //    _character.positionType = CCPositionTypeNormalized;
    //    _character.positionInPoints = ccp(0.5, 0.3);
    //    _character.positionType = CCPositionTypePoints;
    self.distanceTraveled = 0;
    self.physicsBody.body.body->velocity_func = playerUpdateVelocity;
    //self.physicsBody.collisionType = @"character";
}


static void playerUpdateVelocity(cpBody *body, cpVect gravity,cpFloat damping,cpFloat dt){
    cpAssertSoft(body->m > 0.0f && body->i > 0.0f, "Body's mass and moment must be positive to simulate. (Mass: %f Moment: %f)", body->m, body->i);
    
	body->v = cpvadd(cpvmult(body->v, damping), cpvmult(cpvadd(gravity, cpvmult(body->f, body->m_inv)), dt));
	body->w = body->w*damping + body->t*body->i_inv*dt;
    
	// Reset forces.
	body->f = cpvzero;
    body->t = 0.0f;
    
    if (slowDown && speedMultiplier > 0) {
        speedMultiplier -= 0.05;
    } else if (slowDown && speedMultiplier <= 0) {
        slowDown = NO;
    }
    
    if (body->v.y <= 180)
        body->v.y = (body->v.y += acceleration) *speedMultiplier;
    
    //TODO:slow down once u get near make it more fluid. might have to use
    if (abs(speed) > 3) {
        body->v.x = speed;
    }
    if (abs(body->p.x - desiredX) < 3) {
        speed = 0;
        body->v.x = 0;
    }
}


- (void)restartDistance{
    self.distanceTraveled = 0;
}

@end
