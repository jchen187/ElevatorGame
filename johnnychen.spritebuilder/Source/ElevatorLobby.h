//
//  ElevatorLobby.h
//  johnnychen
//
//  Created by Johnny Chen on 7/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ThingThatAppear.h"
@class MainScene;

@interface ElevatorLobby : ThingThatAppear

@property (nonatomic, weak) MainScene *main;
//- (void)addButton;

//for mainscene
+(ElevatorLobby*) makeNewElevatorLobby:(MainScene*)mainscene;

//for gameply
+(ElevatorLobby*) makeNewElevatorLobby;
- (void)addElevatorLobby: (float) xPosition also:(float) yPosition;
-(void)setFloor:(int)floor;

@end
