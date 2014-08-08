//
//  Button.h
//  johnnychen
//
//  Created by Johnny Chen on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ThingThatAppear.h"
@class ElevatorLobby;

@interface Button : ThingThatAppear

@property (nonatomic, strong) ElevatorLobby *correspondingElevatorLobby;

//@property (nonatomic, weak) MainScene *main;
//- (void)addButton;

+(Button*) makeNewButton;
- (void)addButton: (float) yPosition;
- (void)addButtonAtPosition: (CGPoint)p;

@end
