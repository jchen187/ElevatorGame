//
//  GamePlay.h
//  johnnychen
//
//  Created by Johnny Chen on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Character.h"
#import "Button.h"

@interface GamePlay : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic,assign) int elevatorSpeed;

- (Button*)getNextButton;
- (ElevatorLobby*)getNextElevatorLobby;

@end
